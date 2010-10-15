use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Exception;
use Test::Mayoi::Fixture::DBI;
use Path::Class;

use Mayoi::Model::DataSource;

my $test_dir = dir(__FILE__)->parent->subdir('disable_all_user_data_on_disabled_user_data');

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/user_data tweet following/],
    },
);

Test::Mayoi::Fixture::DBI->setup_fixture(
    {
        node     => 'MASTER',
        fixtures => [
            $test_dir->file('user_data_fixture.yaml')->stringify,
            $test_dir->file('tweet_fixture.yaml')->stringify,
            $test_dir->file('following_fixture.yaml')->stringify,
        ],
    },
);

Test::Mayoi::Fixture::DBI->setup_trigger(
    {
        node     => 'MASTER',
        database => 'mayoi',
    },
);

my $ds = Mayoi::Model::DataSource->new;

sub update_user_data{
    my ($user_id, $disabled) = @_;
    $ds->connector('MASTER')->txn(fixup => sub {
        my $dbh = shift;
        my ($stmt, @bind) = $ds->sql->update(
            'user_data',
            {
                disabled => $disabled,
            },
            {
                id => $user_id,
            },
        );
        $dbh->do($stmt, undef, @bind);
        $dbh->commit;
    });
}

sub get_tweet_count {
    my ($user_id) = @_;
    return _count($user_id, 'tweet');
}

sub get_following_count {
    my ($user_id) = @_;
    return _count($user_id, 'following');
}

sub _count {
    my ($user_id, $table) = @_;
    my ($count) = $ds->connector('SLAVE')->run(fixup => sub {
        my $dbh = shift;
        my ($stmt, @bind) = $ds->sql->select(
            $table,
            'COUNT(user_id)',
            {
                user_id  => $user_id,
                disabled => 0,
            },
        );
        $dbh->selectrow_array($stmt, undef, @bind);
    });
    return $count;
}

sub test_trigger {
    my %specs = @_;
    my ($input, $expects, $desc) = @specs{qw/input expects desc/};
    my ($user_id, $disabled) = @$input{qw/user_id disabled/};

    subtest $desc => sub {
        lives_ok {
            update_user_data($user_id, $disabled);
        } 'update_user_data success()';
        
        my $tweet_count = get_tweet_count($user_id);
        is $tweet_count, $expects->{tweet}, 'tweet count';

        my $following_count = get_following_count($user_id);
        is $following_count, $expects->{following}, 'following count';

        done_testing;
    };
}

test_trigger(
    input => {
        user_id  => 1,
        disabled => 0,
    },
    expects => {
        tweet     => 10,
        following => 4,
    },
    desc => 'user_id: 1, disabled: 0',
);

test_trigger(
    input => {
        user_id  => 1,
        disabled => 1,
    },
    expects => {
        tweet     => 0,
        following => 0,
    },
    desc => 'user_id: 1, disabled: 1',
);

done_testing;

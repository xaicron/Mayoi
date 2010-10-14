use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Exception;
use Test::Mayoi::Fixture::DBI;
use Path::Class;

use Mayoi::Model::DataSource;

my $test_dir = dir(__FILE__)->parent->subdir('disable_all_tweet');

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/tweet/],
    },
);

Test::Mayoi::Fixture::DBI->setup_fixture(
    {
        node     => 'MASTER',
        fixtures => [
            $test_dir->file('tweet_fixture.yaml')->stringify,
        ],
    },
);

my $ds = Mayoi::Model::DataSource->new;

sub call_procedure {
    my ($user_id) = @_;
    $ds->connector('MASTER')->txn(fixup => sub {
        my $dbh = shift;
        $dbh->do('CALL disable_all_tweet(?)', undef, $user_id);
        $dbh->commit;
    });
}

sub get_tweet_count {
    my ($user_id) = @_;
    my ($count) = $ds->connector('SLAVE')->run(fixup => sub {
        my $dbh = shift;
        my ($stmt, @bind) = $ds->sql->select(
            'tweet',
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

sub test_disalbe_all_tweet {
    my %specs = @_;
    my ($input, $desc) = @specs{qw/input desc/};
    my ($user_id) = @$input{qw/user_id/};

    subtest $desc => sub {
        lives_ok {
            call_procedure($user_id);
        } 'CALL disable_all_tweet() success';
        
        my $count = get_tweet_count($user_id);
        is $count, 0, 'all tweet is disabled';

        done_testing;
    };
}

test_disalbe_all_tweet(
    input => {
        user_id => 1,
    },
    desc => 'user_id: 1',
);

done_testing;

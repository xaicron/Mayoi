use strict;
use warnings;
use utf8;
use lib 't/lib';
use Test::More;
use Test::Exception;
use Test::Mayoi::Fixture::DBI;
use Encode 'encode_utf8';
use Path::Class;
use Mayoi::Exception;

use Mayoi::Model::DataSource::Tweet;

my $test_dir = dir(__FILE__)->parent->subdir('new_tweet');

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/user_data tweet seq_tweet/],
    },
);

Test::Mayoi::Fixture::DBI->setup_fixture(
    {
        node     => 'MASTER',
        fixtures => [
            $test_dir->file('user_data_fixture.yaml')->stringify,
            $test_dir->file('seq_tweet_fixture.yaml')->stringify,
        ],
    },
);

my $ds = Mayoi::Model::DataSource::Tweet->new;

sub test_created_tweet {
    my ($expects, $begin_time) = @_;

    my $tweet = $ds->connector('SLAVE')->run(fixup => sub {
        my $dbh = shift;
        my ($stmt, @bind) = $ds->sql->select(
            'tweet',
            '*',
            { id => $expects->{id} },
        );
        $dbh->selectrow_hashref($stmt, undef, @bind);
    });

    is $tweet->{user_id}, $expects->{user_id}, 'user_id';
    is $tweet->{tweet}, $expects->{tweet}, 'tweet';
    cmp_ok $tweet->{created_on}, '>=', $begin_time, 'created_on';
    cmp_ok $tweet->{updated_on}, '>=', $begin_time, 'updated_on';
}

sub test_new_tweet {
    my %specs = @_;
    my ($input, $expects, $is_succes, $desc) = @specs{qw/input expects is_succes desc/};

    subtest $desc => sub {
        unless ($is_succes) {
            throws_ok {
                $ds->new_tweet($input);
            } 'Mayoi::Exception';
            is_deeply $@, Mayoi::Exception->new(%$expects), 'exception ok';
            return;
        }

        my $got;
        my $begin_time = time;
        lives_ok {
            $got = $ds->new_tweet($input);
        } 'new_tweet success';

        is $got, $expects->{id}, 'seq ok';
        test_created_tweet($expects, $begin_time);

        done_testing;
    };
}

test_new_tweet(
    input => {
        user_id => 1,
        tweet   => 'だんこがい',
    },
    expects => {
        id      => 1,
        user_id => 1,
        tweet   => encode_utf8('だんこがい'),
    },
    is_succes => 1,
    desc => 'create new tweet',
);

test_new_tweet(
    input => {
        user_id => 2,
        tweet   => 'こがいだん',
    },
    expects => {
        code    => 404,
        message => 'user not found (user_id: 2)',
    },
    is_succes => 0,
    desc => 'user not found',
);

done_testing;

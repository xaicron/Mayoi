use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Exception;
use Test::Mayoi::Fixture::DBI;
use Path::Class;

use Mayoi::Model::DataSource::User;

my $test_dir = dir(__FILE__)->parent->subdir('get_user');

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/user_data/],
    },
);

Test::Mayoi::Fixture::DBI->setup_fixture(
    {
        node     => 'MASTER',
        fixtures => [
            $test_dir->file('user_data_fixture.yaml')->stringify,
        ],
    },
);

my $ds = Mayoi::Model::DataSource::User->new;
sub test_get_user_data {
    my %specs = @_;
    my ($input, $expects, $is_succes, $desc) = @specs{qw/input expects is_succes desc/};

    subtest $desc => sub {
        unless ($is_succes) {
            throws_ok {
                $ds->get_user_data($input);
            } 'Mayoi::Exception';
            is_deeply $@, $expects, 'exception ok';
            return;
        }

        my $got;
        lives_ok {
            $got = $ds->get_user_data($input);
        } 'get_user_data success';

        is_deeply $got, $expects, 'user_data ok';

        done_testing;
    };
}

test_get_user_data(
    input => {
        user_id => 1,
    },
    expects => {
        id   => 1,
        name => 'xaicron',
    },
    is_succes => 1,
    desc => 'get an user',
);

test_get_user_data(
    input => {
        user_id => 2,
    },
    expects => Mayoi::Exception->new(
        code => 404,
        message => 'user not found (user_id: 2)',
    ),
    is_succes => 0,
    desc => 'disabled: 1',
);

test_get_user_data(
    input => {
        user_id => 3,
    },
    expects => Mayoi::Exception->new(
        code => 404,
        message => 'user not found (user_id: 3)',
    ),
    is_succes => 0,
    desc => 'empty',
);

done_testing;

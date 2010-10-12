use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::Fixture::DBI;
use Test::Exception;
use Path::Class;

my $resolver = 'DBIx::DBHResolver';
my $test_dir = dir(__FILE__)->parent->subdir('setup_fixture');

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/user_data/],
    },
);

lives_ok {
    Test::Mayoi::Fixture::DBI->setup_fixture(
        {
            node    => 'MASTER',
            fixture => [
                $test_dir->file('user_data_fixture.yaml')->stringify,
            ],
        },
    );
} 'setup_fixture success';

done_testing;

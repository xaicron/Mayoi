use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::Fixture::DBI;

my $resolver = 'DBIx::DBHResolver';

my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => [qw/user_data/],
    },
);

isa_ok +Test::Mayoi::Fixture::DBI->dbh('MASTER'), 'DBI::db';

done_testing;

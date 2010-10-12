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

isa_ok $db, 'Test::Mayoi::DB';

ok $resolver->connect_info('MASTER'), 'MASTER exists';
ok $resolver->connect_info('SLAVE'), 'SLAVE exists';

done_testing;

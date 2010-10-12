use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::DB;

my $db = Test::Mayoi::DB->setup;
isa_ok +$db->dbh({dbname => 'test'}), 'DBI::db';

done_testing;

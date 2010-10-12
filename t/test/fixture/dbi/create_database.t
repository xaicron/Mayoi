use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::DB;
use Test::Mayoi::Fixture::DBI;

my $db = Test::Mayoi::DB->setup;
ok +Test::Mayoi::Fixture::DBI::create_database($db, 'hoge'), 'create_database';

done_testing;

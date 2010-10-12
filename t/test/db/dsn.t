use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::DB;

my $db = Test::Mayoi::DB->setup;
like +$db->dsn(dbname => 'hoge'), qr/dbname=hoge/;

done_testing;

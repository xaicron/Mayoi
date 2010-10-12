use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Exception;

use Test::Mayoi::DB;

my $db;
lives_ok {
    $db = Test::Mayoi::DB->setup;
} 'setup success';

isa_ok $db, 'Test::Mayoi::DB';

done_testing;

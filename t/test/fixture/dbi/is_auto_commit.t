use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Mayoi::Fixture::DBI;

ok !Test::Mayoi::Fixture::DBI->is_auto_commit('MASTER'), 'master';
ok +Test::Mayoi::Fixture::DBI->is_auto_commit('SLAVE'), 'slave';

done_testing;

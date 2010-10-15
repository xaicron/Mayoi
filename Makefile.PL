use inc::Module::Install;
use Module::Install::ExtendsMakeTest;
name 'Mayoi';
all_from 'lib/Mayoi.pm';

requires 'DBD::mysql';
requires 'DBIx::DBHResolver';
requires 'DBIx::Connector';
requires 'SQL::Abstract::Limit';
requires 'SQL::Abstract::Plugin::InsertMulti';
requires 'Class::Accessor::Fast';
requires 'Try::Tiny';
requires 'parent';
requires 'Data::Util';
requires 'Object::Container';
requires 'HTTP::Status';
requires 'Config::Any';
requires 'String::Random';
requires 'Path::Class';

test_requires 'Test::mysqld';
test_requires 'Test::Fixture::DBI';
test_requires 'Test::More', 0.96;
test_requires 'Test::Exception';

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..5;
author_tests 'xt';

replace_default_make_test(
    includes         => ['t/lib'],
    modules          => ['Test::Mayoi::DB'],
    before_run_codes => [
        sub {
            $SIG{INT} = sub { CORE::exit 1 };
            my $db = Test::Mayoi::DB->setup;
            $ENV{MAYOI_TEST_MY_SOCKET} = $db->my_cnf->{socket};
        },
    ],
);

auto_include();
auto_set_repository();

WriteAll;

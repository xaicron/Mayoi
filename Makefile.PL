use inc::Module::Install;
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

tests_recursive 't';
author_tests 'xt';

auto_include();
auto_set_repository();

WriteAll;

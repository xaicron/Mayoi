use inc::Module::Install;
name 'Mayoi';
all_from 'lib/Mayoi.pm';

#requires '';

#build_requires '';
test_requires 'Test::More', 0.96;

tests_recursive 't';
author_tests 'xt';

auto_include();
auto_set_repository();

WriteAll;

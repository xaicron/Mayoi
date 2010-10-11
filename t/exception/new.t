use strict;
use warnings;
use Test::More;
use Mayoi::Exception;

my $exception = new_ok 'Mayoi::Exception', [
    code    => 12345,
    message => 'hoge',
];
isa_ok $exception, 'Mayoi::Exception';
is +$exception->code, 12345, 'code';
is +$exception->message, 'hoge', 'message';

done_testing;

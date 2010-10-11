use strict;
use warnings;
use Test::More;
use Test::Exception;
use Mayoi::Exception;

my $exception = Mayoi::Exception->new(
    code    => 12345,
    message => 'hoge',
);

throws_ok {
    $exception->rethrow;
} Mayoi::Exception->new(
    code    => 12345,
    message => 'hoge',
);

done_testing;

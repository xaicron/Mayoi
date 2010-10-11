use strict;
use warnings;
use Test::More;
use Test::Exception;
use Mayoi::Exception;

throws_ok {
    Mayoi::Exception->throw(
        code    => 12345,
        message => 'hoge',
    );
} Mayoi::Exception->new(
    code    => 12345,
    message => 'hoge',
);

done_testing;

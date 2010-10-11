use strict;
use warnings;
use Test::More;
use Mayoi::Model;

my $model = new_ok 'Mayoi::Model';
isa_ok +$model, 'Mayoi::Model';

done_testing;

use strict;
use warnings;
use Test::More;
use Mayoi::Model;

my $model = Mayoi::Model->new;
isa_ok +$model->resolver, 'DBIx::DBHResolver';

done_testing;

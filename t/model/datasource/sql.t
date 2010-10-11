use strict;
use warnings;
use Test::More;
use Mayoi::Model;

my $model = Mayoi::Model->new;
isa_ok +$model->sql, 'SQL::Abstract::Limit';

done_testing;

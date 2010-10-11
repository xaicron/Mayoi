use strict;
use warnings;
use Test::More;
use Mayoi::Model::DataSource;

my $model = new_ok 'Mayoi::Model::DataSource';
isa_ok +$model, 'Mayoi::Model::DataSource';

done_testing;

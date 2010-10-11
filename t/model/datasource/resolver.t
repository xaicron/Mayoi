use strict;
use warnings;
use Test::More;
use Mayoi::Model::DataSource;

my $model = Mayoi::Model::DataSource->new;
isa_ok +$model->resolver, 'DBIx::DBHResolver';

done_testing;

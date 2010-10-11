use strict;
use warnings;
use Test::More;
use Test::Exception;
use Mayoi::Model::DataSource;

my $model = Mayoi::Model::DataSource->new;

dies_ok {
   $model->connector('foo'); 
} 'not registered node';

$model->setup_database({
    connect_info => {
        master => {
            dsn      => 'dbi:mysql:dbname=main;host=localhost',
            user     => 'master_user',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 0 },
        },
        slave => {
            dsn      => 'dbi:mysql:dbname=main;host=localhost',
            user     => 'slave_user',
            password => '',
            attrs    => +{ RaiseError => 1, AutoCommit => 1 },
        },
    },
});

my $connector;
lives_ok {
    $connector = $model->connector('master');
} 'connector success';

isa_ok $connector, 'DBIx::Connector';

done_testing;

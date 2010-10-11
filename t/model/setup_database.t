use strict;
use warnings;
use Test::More;
use Test::Exception;
use Mayoi::Model;

my $model = Mayoi::Model->new;

lives_ok {
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
} 'setup_database success';

done_testing;

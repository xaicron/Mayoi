#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';
use Mayoi::Model::DataSource;
use String::Random;

my $config_file = shift || die "usage: $0 db_config.pl";
my $config = do $config_file or die "$config_file $!";

my $rand = String::Random->new;
my $ds = Mayoi::Model::DataSource->new;
$ds->setup_database($config);

$ds->connector('MASTER')->txn(fixup => sub {
    my $dbh = shift;
    my $create_data = [];
    for my $id (1..1000) {
        push @$create_data, {
            id         => $id,
            name       => $rand->randregex('[A-Za-z0-9_]{12}'),
            created_on => \'UNIX_TIMESTAMP()',
            updated_on => \'UNIX_TIMESTAMP()',
        },
    }
    my ($stmt, @bind) = $ds->sql->insert_multi('user_data', $create_data);
    $dbh->do($stmt, undef, @bind);
    $dbh->commit;
});

$ds->connector('MASTER')->txn(fixup => sub {
    my $dbh = shift;
    my $create_data = [];
    for my $id (2..5) {
        push @$create_data, {
            user_id    => 1,
            target_id  => $id,
            created_on => \'UNIX_TIMESTAMP()',
            updated_on => \'UNIX_TIMESTAMP()',
        };
    }
    my ($stmt, @bind) = $ds->sql->insert_multi('following', $create_data);
    $dbh->do($stmt, undef, @bind);
    $dbh->commit;
});

$ds->connector('MASTER')->txn(fixup => sub {
    my $dbh = shift;
    my $create_data = [];
    for my $id (1..100) {
        push @$create_data, {
            id         => $id,
            user_id    => 1,
            tweet      => $rand->randregex('[A-Za-z0-9_]{12}'),
            created_on => \'UNIX_TIMESTAMP()',
            updated_on => \'UNIX_TIMESTAMP()',
        };
    }
    my ($stmt, @bind) = $ds->sql->insert_multi('tweet', $create_data);
    $dbh->do($stmt, undef, @bind);
    $dbh->commit;
});

$ds->connector('MASTER')->txn(fixup => sub {
    my $dbh = shift;
    $dbh->do('INSERT INTO seq_tweet(id) VALUES(0)');
    $dbh->commit;
});

$ds->connector('MASTER')->txn(fixup => sub {
    my $dbh = shift;
    $dbh->do('INSERT INTO seq_user_data(id) VALUES(0)');
    $dbh->commit;
});

__END__

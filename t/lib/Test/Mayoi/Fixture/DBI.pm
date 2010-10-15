package Test::Mayoi::Fixture::DBI;
use strict;
use warnings;
use Test::Mayoi::DB;
use Test::Fixture::DBI qw(:all);
use DBIx::DBHResolver;

our $SCHEMA_BASE_DIR  = 't/schema';
our $AUTO_COMMIT_RULE = qr/(?:W|M|MASTER)$/i;
my $resolver = 'DBIx::DBHResolver';

sub setup_database {
    my ($class, @configs) = @_;
    my $db = Test::Mayoi::DB->setup;
    
    for my $config (@configs) {
        my $dbname = $config->{database};
        create_database($db, $dbname);

        my $database_yaml = _database_yaml($dbname);
        construct_database(
            dbh      => $db->dbh({dbname => $dbname}, { AutoCommit => 1 }),
            database => $database_yaml,
            schema   => $config->{schema},
        );

        for my $node (@{$config->{node}}) {
            $resolver->config->{connect_info}{$node} = {
                dsn   => $db->dsn(dbname => $dbname),
                attrs => {
                    RaiseError => 1,
                    AutoCommit => $class->is_auto_commit($node),
                },
            };
        }
    }
    
    return $db;
}

sub setup_fixture {
    my ($class, @configs) = @_;

    for my $config (@configs) {
        construct_fixture(
            dbh     => $config->{dbh} || $class->dbh($config->{node}),
            fixture => $config->{fixtures},
        );
    }
}

sub setup_trigger {
    my ($class, @configs) = @_;

    for my $config (@configs) {
        construct_trigger(
            dbh      => $config->{dbh} || $class->dbh($config->{node}),
            database => _database_yaml($config->{database}),
        );
    }
}

sub _database_yaml {
    my ($dbname) = @_;
    return sprintf '%s/%s.yaml', $SCHEMA_BASE_DIR, $dbname;
}

#sub set_cluster {
#    my ($class, $config) = @_;
#}

sub dbh {
    my ($class, $node) = @_;
    local $DBIx::DBHResolver::DBI = 'DBI';
    local $DBIx::DBHResolver::DBI_CONNECT_METHOD = 'connect';
    local $DBIx::DBHResolver::DBI_CONNECT_CACHED_METHOD = 'connect_cache';
    return $resolver->connect($node);
}

sub is_auto_commit {
    my ($class, $node) = @_;
    $node =~ $AUTO_COMMIT_RULE ? 0 : 1;
}

sub create_database {
    my ($db, $dbname) = @_;
    my $dbh = $db->dbh({dbname => 'test'}, { AutoCommit => 1 });
    $dbh->do("CREATE DATABASE $dbname");
}

1;

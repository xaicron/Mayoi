package Mayoi::Model::DataSource;

use DBI;
use DBIx::Connector;
use DBIx::DBHResolver;
use SQL::Abstract::Limit;
use SQL::Abstract::Plugin::InsertMulti;
use parent 'Class::Accessor::Fast';

$DBIx::DBHResolver::DBI = 'DBIx::Connector';
$DBIx::DBHResolver::DBI_CONNECT_METHOD = 'new';
$DBIx::DBHResolver::DBI_CONNECT_CACHED_METHOD = 'new';

sub new {
    my ($class, %args) = @_;
    return $class->SUPER::new(\%args);
}

my $container = {};

sub sql {
    $container->{sql} ||= SQL::Abstract::Limit->new(limit_dialect => 'LimitXY');
}

sub resolver {
    $container->{resolver} ||= DBIx::DBHResolver->new;
}

sub setup_database {
    my ($self, $config) = @_;
    $self->resolver->config($config);
}

sub connector {
    my ($self, @args) = @_;
    $self->resolver->connect(@args);
}

1;

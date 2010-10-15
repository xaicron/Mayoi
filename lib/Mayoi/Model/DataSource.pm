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

__PACKAGE__->mk_accessors(qw/resolver/);

sub new {
    my ($class, %args) = @_;
    $args{resolver} = 'DBIx::DBHResolver';
    return $class->SUPER::new(\%args);
}

my $container = {};

sub sql {
    $container->{sql} ||= SQL::Abstract::Limit->new(limit_dialect => 'LimitXY');
}

sub next_seq {
    my ($self, $node, $dbname) = @_;
    my $seq = $self->connector($node)->txn(fixup => sub {
        my $dbh = shift;
        my $seq = $dbh->do("UPDATE $dbname SET id = id + 1");
        $dbh->commit;
        return $seq;
    });

    return $seq;
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

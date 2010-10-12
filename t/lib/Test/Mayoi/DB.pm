package Test::Mayoi::DB;
use strict;
use warnings;
use Test::mysqld;
use DBI;
use parent 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/mysqld/);

sub new {
    my ($class, %args) = @_;
    $class->SUPER::new(\%args);
}

sub setup {
    my ($class) = @_;
    my $mysqld = Test::mysqld->new(my_cnf => {
        'skip-networking' => '',
    });

    return $class->new(mysqld => $mysqld);
}

sub dsn {
    my ($self, %args) = @_;
    return $self->mysqld->dsn(%args);
}

sub dbh {
    my ($self, $args, $attrs) = @_;
    return DBI->connect($self->dsn(%$args), '', '', $attrs);
}

1;


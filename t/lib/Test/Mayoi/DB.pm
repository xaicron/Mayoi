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
    my $mysqld;
    if ($ENV{MAYOI_TEST_MY_SOCKET}) {
        $mysqld = $ENV{MAYOI_TEST_MY_SOCKET};
    }
    else {
        $mysqld = Test::mysqld->new(my_cnf => {
            'skip-networking' => '',
        });
    }
    return $class->new(mysqld => $mysqld);
}

sub my_cnf {
    $_[0]->mysqld->my_cnf; 
}

sub dsn {
    my ($self, %args) = @_;
    return $self->mysqld->dsn(%args) if ref $self->mysqld;
    my $socket = $self->mysqld;
    $args{user}   ||= 'root';
    $args{dbname} ||= 'test';
    return 'DBI:mysql:' . join(';', map { "$_=$args{$_}" } sort keys %args);
}

sub dbh {
    my ($self, $args, $attrs) = @_;
    return DBI->connect($self->dsn(%$args), '', '', $attrs);
}

1;


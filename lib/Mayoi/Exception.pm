package Mayoi::Exception;
use strict;
use warnings;
use parent 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/code message/);

use overload
    '""'     => 'as_string',
    fallback => 1,
;

sub new {
    my ($class, %args) = @_;
    $class->SUPER::new({
        code    => $args{code},
        message => $args{message},
    });
}

sub throw {
    my ($class, %args) = @_;
    die +$class->new(%args);
}

sub rethrow {
    my ($self) = @_;
    die +$self;
}

sub as_string {
    my ($self) = @_;
    return sprintf 'code: %s, message: %s', $self->code, $self->message;
}

1;


package Mayoi::Model::DataSource::User;

use strict;
use warnings;
use parent 'Mayoi::Model::DataSource';

use Try::Tiny;
use Mayoi::Exception;
use Mayoi::Model::Constant::Error qw/:all/;

sub get_uesr_data {
    my ($self, $params) = @_;
    my ($user_id) = @$params{qw/user_id/};

    my $row = try {
        $self->connector('USER_SLAVE', $user_id)->run(fixup => sub {
            my $dbh = shift;
            my ($stmt, @bind) = $self->sql->select(
                'user_data',
                [qw/name nickname/],
                { 
                    id       => $user_id,
                    disabled => 0,
                },
            );
            $dbh->selectrow_hashref($stmt, undef, @bind);
        });
    }
    catch {
        my $e = shift;
        Mayoi::Exception->throw(
            code    => INTERNAL_SERVER_ERROR,
            message => "$e",
        );
    };

    return $row;
}

1;

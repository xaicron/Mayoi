package Mayoi::Model::DataSource::Tweet;

use strict;
use warnings;
use parent 'Mayoi::Model::DataSource';

use Try::Tiny;
use Encode qw/encode_utf8/;
use Mayoi::Exception;
use Mayoi::Model::Constant::Error qw/:all/;
use Mayoi::Model::DataSource::User;

sub new_tweet {
    my ($self, $params) = @_;
    my ($user_id, $tweet, $is_public) =
        @$params{qw/user_id tweet is_public/};

    my $seq = try {
        # throws not found exception
        my $user = Mayoi::Model::DataSource::User->new;
        my $user_data = $user->get_user_data({ user_id => $user_id });

        my $seq = $self->next_seq('MASTER', 'seq_tweet');
        $self->connector('MASTER', $user_id)->run(fixup => sub {
            my $dbh = shift;
            my ($stmt, @bind) = $self->sql->insert(
                'tweet',
                {
                    id         => $seq,
                    user_id    => $user_id,
                    is_public  => $is_public ? 1 : 0,
                    tweet      => encode_utf8($tweet),
                    created_on => \'UNIX_TIMESTAMP()',
                    updated_on => \'UNIX_TIMESTAMP()',
                },
            );
            $dbh->do($stmt, undef, @bind);
            $dbh->commit;
            $seq;
        });
    }
    catch {
        my $e = shift;
        $e->rethrow if ref $e eq 'Mayoi::Exception';
        Mayoi::Exception->throw(
            code    => INTERNAL_SERVER_ERROR,
            message => "$e",
        );
    };

    return $seq;
}

1;

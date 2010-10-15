use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Exception;
use Test::Mayoi::Fixture::DBI;
use Path::Class;

use Mayoi::Model::DataSource;

my $tes_dir = dir(__FILE__)->parent->subdir('next_seq');
my $db = Test::Mayoi::Fixture::DBI->setup_database(
    {
        database => 'mayoi',
        node     => [qw/MASTER SLAVE/],
        schema   => ['seq_tweet'],
    },
);

Test::Mayoi::Fixture::DBI->setup_fixture(
    {
        node => 'MASTER',
        fixtures => [
            $tes_dir->file('seq_tweet_fixture.yaml')->stringify,
        ],
    },
);

my $ds = Mayoi::Model::DataSource->new;
sub test_next_seq {
    my %specs = @_;
    my ($expects, $desc) = @specs{qw/expects desc/};

    subtest $desc => sub {
        my $got;
        lives_ok {
            $got = $ds->next_seq('MASTER', 'seq_tweet');
        } 'next_seq() method success';

        is $got, $expects, 'seq ok';
        done_testing;
    };
}

test_next_seq(
    expects => 1,
    desc    => 'new seq is 1',
);

done_testing;

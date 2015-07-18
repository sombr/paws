package Paw::Watcher;
use Moo;

use Types::Standard qw/:all/;

use AnyEvent;
use AnyEvent::Filesys::Notify;

has dir => (
    is => "ro",
    isa => sub {
        my $val = shift;
        die "no such dir: $val" unless -d $val
    },
    required => 1,
);

has filter => (
    is => "ro",
    isa => RegexpRef,
    default => sub { qr// }
);

has interval => (
    is => "ro",
    isa => Int,
    default => 1.0,
);

has action => (
    is => "ro",
    isa => CodeRef,
    default => sub {
        sub {
            use Data::Dumper;
            print Dumper(["Dummy Processor", @_]);
        }
    },
);

sub start {
    my $self = shift;
    return if $self->{__watcher__};

    my $filter = $self->filter;
    my $action = $self->action;
    $self->{__watcher__} = AnyEvent::Filesys::Notify->new(
        dirs => [ $self->dir ],
        interval => $self->interval,
        filter => sub { shift =~ $filter },
        cb => sub {
            my @events = @_;
            $action->($_->{type}, $_->{path}) for grep { !$_->{is_dir} } @events;
        },
        parse_events => 1,
    );

    $self;
}

sub stop {
    my $self = shift;
    delete $self->{__watcher__};

    $self;
}

1;

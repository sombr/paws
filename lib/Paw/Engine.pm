package Paw::Engine;
use Moo;

use Types::Standard qw/:all/;
use String::ShellQuote qw/ shell_quote /;

use AnyEvent;
use Paw::Watcher;

has watchers => (
    is => "ro",
    isa => ArrayRef[InstanceOf["Paw::Watcher"]],
    default => sub { [] }
);

sub add_watcher {
    my ($self, @params) = @_;
    push @{$self->{watchers}}, Paw::Watcher->new( @params )->start;

    $self;
}

sub cmd {
    my ($self, $cmd, %params) = @_;
    system($cmd, map { ($_, shell_quote($params{$_})) } keys %params);
}

sub run {
    my $self = shift;
    AnyEvent->condvar->recv;
}

1;

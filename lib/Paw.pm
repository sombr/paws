package Paw;
use strict;
use warnings;

use Paw::Engine;

use base qw/Exporter/;
our @EXPORT = qw/ watch cmd /;

my $ENGINE = Paw::Engine->new;

sub watch {
    $ENGINE->add_watcher(@_);
}

sub cmd {
    $ENGINE->cmd(@_)
}

1;

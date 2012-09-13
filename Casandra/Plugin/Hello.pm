package Casandra::Plugin::Hello;
use warnings;
use strict;
use base 'Casandra::Plugin';

sub privmsg {
    my ( $self, $nick, $user, $host, $target, $message ) = @_;

    $self->write_privmsg( $nick, "Hello World" );
}

1;

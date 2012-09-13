package Casandra::Plugin;
use warnings;
use strict;

sub new {
    my ( $class, $args ) = @_;

    my $self = bless { %{ $args } }, $class;

    die "Error: We MUST recieve an ->{irc}" unless $self->{irc};

    return $self;
}

sub write {
    my ( $self, $message ) = @_;

    my $sym = $self->{irc};
    print $sym "$message\r\n";
}

sub write_privmsg {
    my ( $self, $target, $message ) = @_;

    $self->write( "PRIVMSG $target :$message" );
}

1;

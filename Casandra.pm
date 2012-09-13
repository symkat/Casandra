package Casandra;
use warnings;
use strict;
use Module::Find;
use IO::Socket::INET;
use Config::Layered;

my $config = Config::Layered->load_config(
    default => {
        nick    => "casandra",
        user    => "casandra",
        real    => "Casandra - Kaitlyn's Bot",
        host    => "irc.freenode.org",
        port    => 6667,
        timeout => 30,
        channels => [ '#laopensource' ],
    },
);

my @plugins = usesub Casandra::Plugin;

my $conn = IO::Socket::INET->new(
    PeerHost    => $config->{host},
    PeerPort    => $config->{port},
    Proto       => "tcp",
    Timeout     => $config->{timeout},
);

my @modules;
for my $plugin ( @plugins ) {
    push @modules, $plugin->new( { %{ $config }, irc => $conn } );
}

sub dispatch {
    my ( $event, @args ) = @_;
    for my $plugin ( @modules ) {
        $plugin->$event(@args) if $plugin->can( $event );
    }
}

sub irc_send {
    my ( $message ) = @_;

    print "<< $message\n";
    print $conn "$message\r\n"
}


irc_send sprintf("NICK %s", $config->{nick});
irc_send sprintf("USER %s 8 * :%s", $config->{user}, $config->{real});

while ( my $line = <$conn> ) {
    chomp $line;
    print ">>> $line\n";

    if ( $line =~ /^:([^!]+)!([^@]+)@([^ ]+) PRIVMSG ([^ ]*) (.*)$/ ) {
        my ( $nick, $user, $host, $target, $message ) = ( $1, $2, $3, $4, $5 );
        dispatch( "privmsg", $nick, $user, $host, $target, $message  );
    }

}

1;

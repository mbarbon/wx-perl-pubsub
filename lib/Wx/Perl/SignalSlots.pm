package Wx::Perl::SignalSlots;

use strict;
use warnings;

=head1 NAME

Wx::Perl::SignalSlots - alternative event dispatching for wxPerl

=cut

use Wx::Event qw();
use Wx::Perl::SignalSlots::Events;
use Scalar::Util qw(refaddr weaken);
use Exporter 'import';

our @EXPORT_OK = qw(emit subscribe sender);
our %EXPORT_TAGS =
  ( all     => \@EXPORT_OK,
    default => [ 'emit', 'subscribe' ],
    );

our $VERSION = '0.01';
our( %SENDERS, %SIGNAL_MAP );
*SIGNAL_MAP = \%Wx::Perl::SignalSlots::Events::SIGNAL_MAP;

sub _cleanup {
    my( $sender ) = @_;
    my $sender_addr = refaddr( $sender );

    delete $SENDERS{$sender_addr};
}

sub _bind2 {
    my( $sender, $signal, $info, $dest ) = @_;
    my $sender_addr = refaddr( $sender );

    if( !exists $SENDERS{$sender_addr} ) {
        Wx::Event::EVT_DESTROY( $sender, $sender, \&_cleanup );
    }

    if( !exists $SENDERS{$sender_addr}{$signal} ) {
        $info->[1]->( $sender, $info->[2] );
    }

    push @{$SENDERS{$sender_addr}{$signal} ||= []}, $dest;
    weaken( $SENDERS{$sender_addr}{$signal}[-1][0] );
}

sub _bind3 {
    my( $sender, $signal, $info, $dest ) = @_;
    my $sender_addr = refaddr( $sender );

    if( !exists $SENDERS{$sender_addr} ) {
        Wx::Event::EVT_DESTROY( $sender, $sender, \&_cleanup );
    }

    if( !exists $SENDERS{$sender_addr}{$signal} ) {
        $info->[1]->( $sender, $sender, $info->[2] );
    }

    push @{$SENDERS{$sender_addr}{$signal} ||= []}, $dest;
    weaken( $SENDERS{$sender_addr}{$signal}[-1][0] );
}

sub subscribe {
    my( $sender, $signal, @dest ) = @_;
    my $entry = $SIGNAL_MAP{$signal} or die "Invalid signal name: $signal";

    for( my $i = 0; $i < $#$entry; ++$i ) {
        next unless $sender->isa( $entry->[$i] );

        if( $entry->[$i + 1][0] == 3 ) {
            _bind3( $sender, $signal, $entry->[$i + 1], \@dest );
            return;
        } elsif( $entry->[$i + 1][0] == 2 ) {
            _bind2( $sender, $signal, $entry->[$i + 1], \@dest );
            return;
        }

        die "Invalid signal entry";
    }
}

sub emit {
    my( $sender, $signal, @args ) = @_;
    my $sender_addr = refaddr( $sender );

    return unless $SENDERS{$sender_addr} && $SENDERS{$sender_addr}{$signal};

    foreach my $receiver ( @{$SENDERS{$sender_addr}{$signal}} ) {
        my $method = $receiver->[1];
        if( $method ) {
            $receiver->[0]->$method( @args );
        } else {
            $receiver->[0]->( @args );
        }
    }
}

1;

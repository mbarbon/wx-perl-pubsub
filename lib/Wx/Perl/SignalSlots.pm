package Wx::Perl::SignalSlots;

use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Wx::Perl::SignalSlots - alternative event dispatching for wxPerl

=cut

use Wx::Event qw();
use Wx::Perl::SignalSlots::Events;
use Scalar::Util qw(refaddr weaken blessed);
use Exporter 'import';

our @EXPORT_OK = qw(emit subscribe sender);
our %EXPORT_TAGS =
  ( all     => \@EXPORT_OK,
    default => [ 'emit', 'subscribe' ],
    );

# %SENDERS maps senders => signals => target list
# the target list contains array references with either one or two elements:
# - one-element array for code references
# - two-element array for methods
# if the first entry is undef, the target has been destroyed/GCd
#
# %TARGETS maps targets => senders => signals
# it only contains entries for C<Wx::Window>-derived objects and is used
# to cleanup object references when the window is destroyed
our( %SENDERS, %TARGETS, %SIGNAL_MAP );
*SIGNAL_MAP = \%Wx::Perl::SignalSlots::Events::SIGNAL_MAP;

# called when a sender is destroyed to remove all references to it
sub _cleanup_sender {
    my( $sender ) = @_;
    my $sender_addr = refaddr( $sender );

    foreach my $signal ( keys %{$SENDERS{$sender_addr}} ) {
        foreach my $target ( @{$SENDERS{$sender_addr}{$signal}} ) {
            next unless blessed( $target->[0] );
            _unbind_signal_addrs( $sender_addr, $signal, refaddr( $target->[0] ) );
        }
    }

    delete $SENDERS{$sender_addr};
}

# called when a target is destroyed to remove all references to it
sub _cleanup_target {
    my( $target ) = @_;
    my $target_addr = refaddr( $target );

    foreach my $sender_addr ( keys %{$TARGETS{$target_addr}} ) {
        foreach my $signal ( keys %{$TARGETS{$target_addr}{$sender_addr}} ) {
            _unbind_signal_addrs( $sender_addr, $signal, $target_addr );
        }
    }

    delete $TARGETS{$target_addr};
}

sub _unbind_signal_addrs {
    my( $sender_addr, $signal, $target_addr ) = @_;

    my $targets = $SENDERS{$sender_addr}{$signal};
    for( my $i = $#$targets; $i >= 0; --$i ) {
        next unless refaddr( $targets->[$i][0] ) == $target_addr;
        $targets->[$i][0] = undef;
    }

    return unless my $senders = $TARGETS{$target_addr};
    return unless my $signals = $senders->{$sender_addr};
    delete $signals->{$signal};
}

sub _bind_target {
    my( $target, $sender, $signal ) = @_;
    my $target_addr = refaddr( $target );
    my $sender_addr = refaddr( $sender );

    if( !exists $TARGETS{$target_addr} ) {
        Wx::Event::EVT_DESTROY( $target, $target, \&_cleanup_target );
    }

    $TARGETS{$target_addr}{$sender_addr}{$signal} ||= 1;
}

sub _bind {
    my( $sender, $signal, $arg_count, $info, $dest ) = @_;
    my $sender_addr = refaddr( $sender );

    if( !exists $SENDERS{$sender_addr} ) {
        Wx::Event::EVT_DESTROY( $sender, $sender, \&_cleanup_sender );
    }

    if( !exists $SENDERS{$sender_addr}{$signal} ) {
        if( $arg_count == 2 ) {
            $info->[1]->( $sender, $info->[2] );
        } elsif( $arg_count == 3 ) {
            $info->[1]->( $sender, $sender, $info->[2] );
        } else {
            die "Invalid signal entry for '$signal'";
        }
    }

    push @{$SENDERS{$sender_addr}{$signal} ||= []}, $dest;
    weaken( $SENDERS{$sender_addr}{$signal}[-1][0] );

    if( blessed( $dest->[0] ) && $dest->[0]->isa( 'Wx::Window' ) ) {
        _bind_target( $dest->[0], $sender, $signal );
    }
}

sub subscribe {
    my( $sender, $signal, @dest ) = @_;
    my $entry = $SIGNAL_MAP{$signal} or die "Invalid signal name: '$signal'";

    for( my $i = 0; $i < $#$entry; ++$i ) {
        next unless $sender->isa( $entry->[$i] );

        _bind( $sender, $signal, $entry->[$i + 1][0], $entry->[$i + 1],
               \@dest );
        return;
    }
}

sub emit {
    my( $sender, $signal, @args ) = @_;
    my $sender_addr = refaddr( $sender );

    return unless $SENDERS{$sender_addr} && $SENDERS{$sender_addr}{$signal};

    my $targets = $SENDERS{$sender_addr}{$signal};
    for( my $i = $#$targets; $i >= 0; --$i ) {
        my $receiver = $targets->[$i];
        if( !$receiver->[0] ) {
            splice @$targets, $i, 1;
            next;
        }

        my $method = $receiver->[1];
        if( $method ) {
            $receiver->[0]->$method( @args );
        } else {
            $receiver->[0]->( @args );
        }
    }
}

1;

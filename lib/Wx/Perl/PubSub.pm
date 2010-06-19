package Wx::Perl::PubSub;

use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Wx::Perl::PubSub - alternative event dispatching for wxPerl

=head1 SYNOPSIS

    use Wx::Perl::PubSub qw(:default);

    my $frame = MyFrame->new( ... );
    my $listbox = Wx::ListBox->new( $frame, -1, ... );

    subscribe( $listbox, 'ItemSelected', $frame, 'OnItemSelected' );

    # in MyFrame.pm

    sub OnItemSelected {
        my( $self, $index ) = @_;

        # ...
    }

=head1 DESCRIPTION

This module implements an alternative event hanling model for wxPerl,
in some ways similar to Qt signal/slot mechanism.  The advantages
compared to wxWidgets/wxPerl standard event handling are:

=over 4

=item simpler

No need to deal with wxWidgets event objects.

=item multicast

The C<EVT_FOO> binders can only bind an event once per object.

=item cleaner

No need to import the various C<EVT_FOO> binders.

=back

=head1 FUNCTIONS

=cut

use Wx::Event qw();
use Wx::Perl::PubSub::Events;
use Scalar::Util qw(refaddr weaken blessed);
use Exporter 'import';

our @EXPORT_OK = qw(emit subscribe unsubscribe sender);
our %EXPORT_TAGS =
  ( all     => \@EXPORT_OK,
    default => [ 'emit', 'subscribe', 'unsubscribe' ],
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
*SIGNAL_MAP = \%Wx::Perl::PubSub::Events::SIGNAL_MAP;

# called when a sender is destroyed to remove all references to it
sub _cleanup_sender {
    my( $sender ) = @_;
    my $sender_addr = refaddr( $sender );

    emit( $sender, 'Destroyed', $sender );

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

# removes a single connection
sub _unbind_signal_addrs {
    my( $sender_addr, $signal, $target_addr ) = @_;

    my $targets = $SENDERS{$sender_addr}{$signal};
    for( my $i = $#$targets; $i >= 0; --$i ) {
        next unless refaddr( $targets->[$i][0] ) == $target_addr;
        $targets->[$i][0] = undef;
    }

    _unbind_target( $sender_addr, $signal, $target_addr );
}

# sets up garbage collection for a target derived from wxWindow
sub _bind_target {
    my( $target, $sender, $signal ) = @_;
    my $target_addr = refaddr( $target );
    my $sender_addr = refaddr( $sender );

    if( !exists $TARGETS{$target_addr} ) {
        Wx::Event::EVT_DESTROY( $target, $target, undef );
        Wx::Event::EVT_DESTROY( $target, $target, \&_cleanup_target );
    }

    $TARGETS{$target_addr}{$sender_addr}{$signal} ||= 1;
}

# clean up garbage collection for a target
sub _unbind_target {
    my( $sender_addr, $signal, $target_addr ) = @_;

    return unless my $senders = $TARGETS{$target_addr};
    return unless my $signals = $senders->{$sender_addr};

    delete $senders->{$signal};
    delete $signals->{$sender_addr} if !keys %$signals;
    delete $TARGETS{$target_addr} if !keys %$senders;
}

sub _bind {
    my( $sender, $signal, $arg_count, $info, $dest ) = @_;
    my $sender_addr = refaddr( $sender );

    if( !exists $SENDERS{$sender_addr} ) {
        Wx::Event::EVT_DESTROY( $sender, $sender, \&_cleanup_sender );
        # Destroyed is special because it is emitted by _cleanup_sender above
        $SENDERS{$sender_addr}{Destroyed} = [];
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

=head2 C<subscribe>

    subscribe( $sender, 'SignalName', $object, 'MethodName' );
    subscribe( $sender, 'SignalName', \&_function );

Connects a signal to a receiver.  Every time the signal is emitted,
the receiver method/function will be called with zero or more
arguments specific to the signal (for example the C<Clicked> signal
takes no arguments while the C<ItemSelected> signal takes the item
index as argument).

When multiple receivers are connected to the same sender/signal, the
call order is undefined.

Both sender and receiver converted into weak references; if a window
is destroyed or an object is garbage collected all the associated
connections are automatically removed.

The available events are listed in L<Wx::Perl::PubSub::Events>.

=cut

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

sub _same_destination {
    my( $d1, $d2 ) = @_;

    return 0 if $#$d1 != $#$d2 || !defined $d1->[0];
    return 0 if refaddr( $d1->[0] ) != refaddr( $d2->[0] );
    return 1 if $#$d1 == 0;
    return $d1->[1] eq $d2->[1];
}

sub _same_destination_wildcard {
    my( $d1, $d2 ) = @_;

    return 0 if !defined $d1->[0];
    return 1 if $#$d2 == -1;
    return 0 if $#$d1 != $#$d2;
    return 0 if refaddr( $d1->[0] ) != refaddr( $d2->[0] || $d1->[0] );
    return 1 if $#$d1 == 0;
    return $d1->[1] eq ( $d2->[1] || $d1->[1] );
}

=head2 C<unsubscribe>

    unsubscribe( $sender, 'SignalName', $object, 'MethodName' );
    unsubscribe( $sender, 'SignalName', \&_function );

Removes a connection created by C<subscribe>.  Does nothing if there
is no matching connection.

C<undef> can be used in place of any argument as a wildcard, for example:

    # disconnects all receivers subscribed to this sender
    unsubscribe( $sender );

    # disconnects all receivers subscribed to a signal
    unsubscribe( $sender, 'SignalName' );

    # disconnects a receiver from all signals of a sender
    unsubscribe( $sender, undef, $receiver, undef );

Note:

   # disconnects all receivers
   unsubscribe( $sender, 'SignalName' );

   # disconnects receivers that are code references
   unsubscribe( $sender, 'SignalName', undef );

   # disconnects receivers that are method calls
   unsubscribe( $sender, 'SignalName', undef, undef );

=cut

sub _unsubscribe_sender_signal {
    my( $sender_addr, $signal, $dest ) = @_;

    return unless my $signals = $SENDERS{$sender_addr};
    return unless my $targets = $signals->{$signal};

    for( my $i = $#$targets; $i >= 0; --$i ) {
        next unless _same_destination( $targets->[$i], $dest );
        $targets->[$i][0] = undef;
    }

    _unbind_target( $sender_addr, $signal, refaddr( $dest->[0] ) );
}

sub _unsubscribe_wildcard {
    my( $_sender, $_signal, $dest ) = @_;

    # not the most efficient way, but should be adequate for most uses
    foreach my $sender_addr ( $_sender ? refaddr( $_sender ) : keys %SENDERS ) {
        next unless my $signals = $SENDERS{$sender_addr};

        foreach my $signal ( $_signal ? $_signal : keys %{$SENDERS{$sender_addr}} ) {
            next unless my $targets = $signals->{$signal};

            for( my $i = $#$targets; $i >= 0; --$i ) {
                next unless _same_destination_wildcard( $targets->[$i], $dest );
                _unbind_target( $sender_addr, $signal, refaddr( $targets->[$i][0] ) );

                $targets->[$i][0] = undef;
            }
        }
    }
}

sub unsubscribe {
    my( $sender, $signal, @dest ) = @_;
    my $dest = \@dest;

    # all arguments specified: disconnect a single connection
    return _unsubscribe_sender_signal( refaddr( $sender ), $signal, $dest )
      if $sender && $signal && ( !grep !$_, @dest );

    return _unsubscribe_wildcard( $sender, $signal, $dest );
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

=head1 SEE ALSO

L<Wx::Perl::PubSub::Events> for the list of supported events.

=head1 AUTHOR

Mattia Barbon <mbarbon@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

1;
#!/usr/bin/perl -w

use strict;
use Test::More tests => 11;
use t::lib::PubSub;

use Wx::Perl::PubSub qw(:local);
use Scalar::Util qw(refaddr);

my $button = test_button;
my $button_addr = refaddr( $button );
my $senders = \%Wx::Perl::PubSub::SENDERS;

# when the target is a plain Perl object, check that GC works
my $target = Target->new;

subscribe( $button, 'Clicked', $target, 'handle' );
simulate_click( $button );

undef $target;

is( @{$senders->{$button_addr}{Clicked}}, 1, 'connection still active' );
simulate_click( $button );
is( @{$senders->{$button_addr}{Clicked}}, 0, 'connection cleaned up after GC' );

# when the target is a wxWindow instance, destroying the window
# removes the connection
my $button2 = Wx::Button->new( test_frame, -1, 'A button' );
subscribe( $button, 'Clicked', $button2, 'dummy' );

is( $senders->{$button_addr}{Clicked}[0][0], $button2, 'found button target' );
undef $button2;
ok( $senders->{$button_addr}{Clicked}[0][0]->isa( 'Wx::Button' ),
    'wxWindow are not GCd' );
$button2 = $senders->{$button_addr}{Clicked}[0][0];
$button2->Destroy;
is( $senders->{$button_addr}{Clicked}[0][0], undef, 'connection cleaned up after Destroy' );

# check that destroying the source cleans up the signal structure, also test
# the Destroyed signal
my $target2 = Target->new;

subscribe( $button, 'Clicked', $target2, 'handle' );
subscribe( $button, 'Destroyed', $target2, 'handle1' );

clear_handled;
simulate_click( $button );
is_deeply( [ handled ], [] );

ok( scalar keys %$senders, 'found the sender reference' );
$button->Destroy;
ok( !scalar keys %$senders, 'sender cleaned up after destroy' );
is_deeply( [ handled ], [ 'handle1' ] );

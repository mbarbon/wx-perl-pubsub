#!/usr/bin/perl -w

use strict;
use Test::More tests => 7;
use t::lib::SignalSlots;

use Wx::Perl::SignalSlots qw(:default);

my $senders = \%Wx::Perl::SignalSlots::SENDERS;
my $targets = \%Wx::Perl::SignalSlots::TARGETS;

my $target1 = Target->new;
my $target2 = Target->new;

subscribe( test_button, 'Clicked', $target1, 'handle1' );
subscribe( test_button, 'Clicked', $target1, 'handle2' );
subscribe( test_button, 'Clicked', $target1, 'handle2' );
subscribe( test_button, 'Clicked', $target2, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1', 'handle2', 'handle2', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle1' );
unsubscribe( test_button, 'Clicked', $target2, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [] );

# check everything has been cleaned up correctly
my( $key ) = keys %$senders;

is_deeply( [ keys %$targets ], [] );
is_deeply( [ keys %$senders ], [ $key ] );
is_deeply( $senders->{$key}, { Clicked => [], Destroyed => [] } );

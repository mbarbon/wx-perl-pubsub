#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;
use t::lib::PubSub;

use Wx::Perl::PubSub qw(:local register_event emit_event);

my $senders = \%Wx::Perl::PubSub::SENDERS;
my $targets = \%Wx::Perl::PubSub::TARGETS;

my $target1 = Target->new;

# this is an abomination, but good enough for a test
register_event( 'FooBar', 'Wx::Frame', \&Wx::Event::EVT_BUTTON, undef,
                sub { emit_event( $_[0], $_[1], 'FooBar' ) } );

subscribe( test_frame, 'FooBar', $target1, 'handle1' );

clear_handled;
simulate_click( test_frame );
is_deeply( [ handled ], [ 'handle1' ] );

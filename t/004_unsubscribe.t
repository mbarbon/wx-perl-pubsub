#!/usr/bin/perl -w

use strict;
use Test::More tests => 7;
use t::lib::SignalSlots;

use Wx::Perl::SignalSlots qw(:default);

my @got;
{
    package Target;

    sub new { bless {}, shift }

    sub handle1 { push @got, 'handle1' }
    sub handle2 { push @got, 'handle2' }
}

my $senders = \%Wx::Perl::SignalSlots::SENDERS;
my $targets = \%Wx::Perl::SignalSlots::TARGETS;

my $target1 = Target->new;
my $target2 = Target->new;

subscribe( test_button, 'Clicked', $target1, 'handle1' );
subscribe( test_button, 'Clicked', $target1, 'handle2' );
subscribe( test_button, 'Clicked', $target1, 'handle2' );
subscribe( test_button, 'Clicked', $target2, 'handle2' );

@got = ();
simulate_click( test_button );
is_deeply( [ sort @got ], [ 'handle1', 'handle2', 'handle2', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle2' );

@got = ();
simulate_click( test_button );
is_deeply( [ sort @got ], [ 'handle1', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle2' );

@got = ();
simulate_click( test_button );
is_deeply( [ sort @got ], [ 'handle1', 'handle2' ] );

unsubscribe( test_button, 'Clicked', $target1, 'handle1' );
unsubscribe( test_button, 'Clicked', $target2, 'handle2' );

@got = ();
simulate_click( test_button );
is_deeply( [ sort @got ], [] );

# check everything has been cleaned up correctly
my( $key ) = keys %$senders;

is_deeply( [ keys %$targets ], [] );
is_deeply( [ keys %$senders ], [ $key ] );
is_deeply( $senders->{$key}, { Clicked => [] } );

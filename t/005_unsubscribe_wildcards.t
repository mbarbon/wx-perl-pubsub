#!/usr/bin/perl -w

use strict;
use Test::More tests => 6;
use t::lib::PubSub;

use Wx::Perl::PubSub qw(:default);

my $senders = \%Wx::Perl::PubSub::SENDERS;
my $targets = \%Wx::Perl::PubSub::TARGETS;

my $target1 = Target->new;
my $target2 = Target->new;

sub resubscribe {
    unsubscribe( undef );

    subscribe( test_button, 'Clicked', $target1, 'handle1' );
    subscribe( test_button, 'Clicked', $target1, 'handle2' );
    subscribe( test_button, 'Clicked', $target1, 'handle2' );
    subscribe( test_button, 'Clicked', $target2, 'handle2' );
}

resubscribe();
clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1', 'handle2', 'handle2', 'handle2' ] );

# test unsubscribing everything
unsubscribe( undef );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ ] );

resubscribe();
unsubscribe( test_button );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ ] );

# test unsubscringing a single object
resubscribe();
unsubscribe( undef, undef, $target1, undef );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle2' ] );

# test unsubscringing a single method
resubscribe();
unsubscribe( undef, undef, undef, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1' ] );

# test unsubscringing a single object/method
resubscribe();
unsubscribe( undef, undef, $target1, 'handle2' );

clear_handled;
simulate_click( test_button );
is_deeply( [ handled ], [ 'handle1', 'handle2' ] );

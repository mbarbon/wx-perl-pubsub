#!/usr/bin/perl -w

use strict;
use Test::More tests => 6;
use t::lib::PubSub;

use Wx::Perl::PubSub qw(:local sender wx_event);

subscribe( test_button, 'Clicked', \&_receiver );

sub _receiver {
    isa_ok( sender(), 'Wx::Button' );
    isa_ok( wx_event(), 'Wx::CommandEvent' );
}

is( sender(), undef );
is( wx_event(), undef );

simulate_click( test_button );

is( sender(), undef );
is( wx_event(), undef );

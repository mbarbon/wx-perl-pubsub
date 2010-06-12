#!/usr/bin/perl -w

use strict;
use Test::More tests => 2;

use Wx;
use Wx::Perl::SignalSlots qw(:default);

{
    package MyFrame;

    use base 'Wx::Frame';

    sub _Idle { main::ok( 1 ) }
}

my $app = Wx::SimpleApp->new;
my $frame = MyFrame->new( undef, -1, "Frame" );

subscribe( $frame, 'Idle', $frame, 'Destroy' );
subscribe( $frame, 'Idle', $frame, '_Idle' );
subscribe( $frame, 'Idle', sub { ok( 1 ) } );

$frame->Show;
$app->MainLoop;

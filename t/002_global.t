#!/usr/bin/perl -w

use strict;
use Test::More tests => 2;

use Wx;
use Wx::Perl::PubSub qw(:global);

{
    package MyFrame;

    use base 'Wx::Frame';

    sub _Idle { main::ok( 1, 'method' ) }
}

my $app = Wx::SimpleApp->new;
my $frame = MyFrame->new( undef, -1, "Frame" );

$frame->subscribe( 'Idle' => $frame, 'Destroy' );
$frame->subscribe( 'Idle' => $frame, '_Idle' );
$frame->subscribe( 'Idle' => sub { ok( 1, 'anonymous sub' ) } );

$frame->Show;
$app->MainLoop;

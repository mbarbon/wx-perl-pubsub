package t::lib::SignalSlots;

use strict;
use warnings;
use Exporter 'import';

use Wx;

our @EXPORT = qw(test_frame test_button simulate_click);

my( $frame, $button, $app ) = @_;

sub test_frame {
    $app ||= Wx::SimpleApp->new;
    $frame ||= Wx::Frame->new( undef, -1, 'Test frame' );
}

sub test_button {
    $button ||= Wx::Button->new( test_frame, -1, 'A button' );
}

sub simulate_click {
    my( $target ) = @_;
    my $event = Wx::CommandEvent->new( &Wx::wxEVT_COMMAND_BUTTON_CLICKED,
                                       $target->GetId() );

    $target->GetEventHandler->ProcessEvent( $event );
}

1;

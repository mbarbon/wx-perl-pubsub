package Wx::Perl::SignalSlots::Events;

use strict;
use warnings;

use Wx::Event qw();

*emit = \&Wx::Perl::SignalSlots::emit;

our %SIGNAL_MAP =
  (

### BEGIN EVENTS ###

    'Clicked' =>
        [
          'Wx::Button' =>
              [ 3, \&Wx::Event::EVT_BUTTON, \&_Wx_Button_Clicked ],
          ],
    'Idle' =>
        [
          'Wx::Window' =>
              [ 2, \&Wx::Event::EVT_IDLE, \&_Wx_Window_Idle ],
          ],
    'ItemSelected' =>
        [
          'Wx::ListBox' =>
              [ 3, \&Wx::Event::EVT_LISTBOX, \&_Wx_ListBox_ItemSelected ],
          ],
    'Timeout' =>
        [
          'Wx::Timer' =>
              [ 3, \&Wx::Event::EVT_TIMER, \&_Wx_Timer_Timeout ],
          ],

### END EVENTS ###

    );

### BEGIN FUNCTIONS ###

sub _Wx_Button_Clicked { emit( $_[0], 'Clicked' ) }
sub _Wx_ListBox_ItemSelected { emit( $_[0], 'ItemSelected', $_[1]->GetInt ) }
sub _Wx_Window_Idle { emit( $_[0], 'Idle' ) }
sub _Wx_Timer_Timeout { emit( $_[0], 'Timeout' ) }

### END FUNCTIONS ###

1;

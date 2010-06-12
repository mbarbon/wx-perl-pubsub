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
sub _Wx_Timer_Timeout { emit( $_[0], 'Timeout' ) }
sub _Wx_Window_Idle { emit( $_[0], 'Idle' ) }

### END FUNCTIONS ###

1;

__DATA__

=head1 NAME

Wx::Perl::SignalSlots::Events - lists the predefined event types

=head1 CLASSES

=head2 C<Wx::Button>

=head3 C<Clicked>

=for generator EVT_BUTTON

=head2 C<Wx::ListBox>

=head3 C<ItemSelected>

=for generator EVT_LISTBOX $_[1]->GetInt

=head2 C<Wx::Timer>

=head3 C<Timeout>

=for generator EVT_TIMER

=head2 C<Wx::Window>

=head3 C<Idle>

=for generator EVT_IDLE

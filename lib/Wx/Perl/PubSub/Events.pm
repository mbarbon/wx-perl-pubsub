package Wx::Perl::PubSub::Events;

use strict;
use warnings;

use Wx::Event qw();

*emit = \&Wx::Perl::PubSub::emit;

our %SIGNAL_MAP =
  (

### BEGIN EVENTS ###

    'Clicked' =>
        [
          'Wx::Button' =>
              [ 3, \&Wx::Event::EVT_BUTTON, \&_Wx_Button_Clicked ],
          ],
    'Destroyed' =>
        [
          'Wx::Window' =>
              [ 3, \&Wx::Event::EVT_DESTROY, \&_Wx_Window_Destroyed ],
          ],
    'Idle' =>
        [
          'Wx::Window' =>
              [ 2, \&Wx::Event::EVT_IDLE, \&_Wx_Window_Idle ],
          ],
    'ItemSelected' =>
        [
          'Wx::Choice' =>
              [ 3, \&Wx::Event::EVT_CHOICE, \&_Wx_Choice_ItemSelected ],
          'Wx::ComboBox' =>
              [ 3, \&Wx::Event::EVT_COMBOBOX, \&_Wx_ComboBox_ItemSelected ],
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
sub _Wx_Choice_ItemSelected { emit( $_[0], 'ItemSelected', $_[1]->GetInt ) }
sub _Wx_ComboBox_ItemSelected { emit( $_[0], 'ItemSelected', $_[1]->GetInt ) }
sub _Wx_ListBox_ItemSelected { emit( $_[0], 'ItemSelected', $_[1]->GetInt ) }
sub _Wx_Timer_Timeout { emit( $_[0], 'Timeout' ) }
sub _Wx_Window_Destroyed { emit( $_[0], 'Destroyed', $_[0] ) }
sub _Wx_Window_Idle { emit( $_[0], 'Idle' ) }

### END FUNCTIONS ###

1;

__DATA__

=head1 NAME

Wx::Perl::PubSub::Events - lists the predefined event types

=head1 CLASSES

=head2 C<Wx::Button>

=head3 C<Clicked()>

=for generator EVT_BUTTON

Emitted when a push button is clicked.

=head2 C<Wx::Choice>

=head3 C<ItemSelected( $index )>

=for generator EVT_CHOICE $_[1]->GetInt

Emitted when a choice item is selected; takes the item index as
parameter.

=head2 C<Wx::ComboBox>

=head3 C<ItemSelected( $index )>

=for generator EVT_COMBOBOX $_[1]->GetInt

Emitted when a combo box item is selected; takes the item index as
parameter.

=head2 C<Wx::ListBox>

=head3 C<ItemSelected( $index )>

=for generator EVT_LISTBOX $_[1]->GetInt

Emitted when a list box item is selected; takes the item index as
parameter.

=head2 C<Wx::Timer>

=head3 C<Timeout()>

=for generator EVT_TIMER

Emitted every time the timer timeout expires.

=head2 C<Wx::Window>

=head3 C<Destroyed( $object )>

=for generator EVT_DESTROY $_[0]

Emitted when a C<Wx::Window> derived class is destroyed.  Note that
the object passed to the signal might not be blessed in the correct
class, and no method must be called on it.

=head3 C<Idle()>

=for generator EVT_IDLE

Emitted every time the event loop stops because there are no more
events to process.

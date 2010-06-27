package Wx::Perl::PubSub::Events;

use strict;
use warnings;

use Wx qw(wxEVT_SCROLL_TOP wxEVT_SCROLL_BOTTOM wxEVT_SCROLL_LINEUP
          wxEVT_SCROLL_LINEDOWN wxEVT_SCROLL_PAGEUP wxEVT_SCROLL_PAGEDOWN
          wxEVT_SCROLL_THUMBTRACK wxEVT_SCROLL_THUMBRELEASE);
use Wx::Event qw();

*emit_event = \&Wx::Perl::PubSub::emit_event;

our %SIGNAL_MAP =
  (

### THIS SECTION IS GENERATED: TO CHANGE IT, CHANGE THE POD BELOW ###
### BEGIN EVENTS ###

    'ArrowDown' =>
        [
          'Wx::SpinButton' =>
              [ 3, \&Wx::Event::EVT_SPIN_DOWN, \&_Wx_SpinButton_ArrowDown ],
          ],
    'ArrowUp' =>
        [
          'Wx::SpinButton' =>
              [ 3, \&Wx::Event::EVT_SPIN_UP, \&_Wx_SpinButton_ArrowUp ],
          ],
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
    'EnterPressed' =>
        [
          'Wx::TextCtrl' =>
              [ 3, \&Wx::Event::EVT_TEXT_ENTER, \&_Wx_TextCtrl_EnterPressed ],
          ],
    'Idle' =>
        [
          'Wx::Window' =>
              [ 2, \&Wx::Event::EVT_IDLE, \&_Wx_Window_Idle ],
          ],
    'ItemDoubleClicked' =>
        [
          'Wx::ListBox' =>
              [ 3, \&Wx::Event::EVT_LISTBOX_DCLICK, \&_Wx_ListBox_ItemDoubleClicked ],
          ],
    'ItemSelected' =>
        [
          'Wx::Choice' =>
              [ 3, \&Wx::Event::EVT_CHOICE, \&_Wx_Choice_ItemSelected ],
          'Wx::ComboBox' =>
              [ 3, \&Wx::Event::EVT_COMBOBOX, \&_Wx_ComboBox_ItemSelected ],
          'Wx::ListBox' =>
              [ 3, \&Wx::Event::EVT_LISTBOX, \&_Wx_ListBox_ItemSelected ],
          'Wx::RadioBox' =>
              [ 3, \&Wx::Event::EVT_RADIOBOX, \&_Wx_RadioBox_ItemSelected ],
          ],
    'ItemToggled' =>
        [
          'Wx::CheckListBox' =>
              [ 3, \&Wx::Event::EVT_CHECKLISTBOX, \&_Wx_CheckListBox_ItemToggled ],
          ],
    'LengthExceeded' =>
        [
          'Wx::TextCtrl' =>
              [ 3, \&Wx::Event::EVT_TEXT_MAXLEN, \&_Wx_TextCtrl_LengthExceeded ],
          ],
    'PositionChanged' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::SpinButton' =>
              [ 3, \&Wx::Event::EVT_SPIN, \&_Wx_SpinButton_PositionChanged ],
          'Wx::SpinCtrl' =>
              [ 3, \&Wx::Event::EVT_SPINCTRL, \&_Wx_SpinCtrl_PositionChanged ],
          ],
    'ScrollBottom' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollLineDown' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollLineUp' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollPageDown' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollPageUp' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollThumbRelease' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollThumbTrack' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'ScrollTop' =>
        [
          'Wx::ScrollBar' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          'Wx::Slider' =>
              [ 2, \&Wx::Event::EVT_SCROLL, \&_Wx_ScrollBar_Scroll ],
          ],
    'StringSelected' =>
        [
          'Wx::Choice' =>
              [ 3, \&Wx::Event::EVT_CHOICE, \&_Wx_Choice_ItemSelected ],
          'Wx::ComboBox' =>
              [ 3, \&Wx::Event::EVT_COMBOBOX, \&_Wx_ComboBox_ItemSelected ],
          'Wx::ListBox' =>
              [ 3, \&Wx::Event::EVT_LISTBOX, \&_Wx_ListBox_ItemSelected ],
          ],
    'TextChanged' =>
        [
          'Wx::ComboBox' =>
              [ 3, \&Wx::Event::EVT_TEXT, \&_Wx_ComboBox_TextChanged ],
          'Wx::SpinCtrl' =>
              [ 3, \&Wx::Event::EVT_TEXT, \&_Wx_SpinCtrl_TextChanged ],
          'Wx::TextCtrl' =>
              [ 3, \&Wx::Event::EVT_TEXT, \&_Wx_TextCtrl_TextChanged ],
          ],
    'Timeout' =>
        [
          'Wx::Timer' =>
              [ 3, \&Wx::Event::EVT_TIMER, \&_Wx_Timer_Timeout ],
          ],
    'Toggled' =>
        [
          'Wx::CheckBox' =>
              [ 3, \&Wx::Event::EVT_CHECKBOX, \&_Wx_CheckBox_Toggled ],
          'Wx::RadioButton' =>
              [ 3, \&Wx::Event::EVT_RADIOBUTTON, \&_Wx_RadioButton_Toggled ],
          'Wx::ToggleButton' =>
              [ 3, \&Wx::Event::EVT_TOGGLEBUTTON, \&_Wx_ToggleButton_Toggled ],
          ],

### END EVENTS ###

    );

### THIS SECTION IS GENERATED: TO CHANGE IT, CHANGE THE POD BELOW ###
### BEGIN FUNCTIONS ###

sub _Wx_Button_Clicked { emit_event( $_[0], $_[1], 'Clicked' ); }
sub _Wx_CheckBox_Toggled { emit_event( $_[0], $_[1], 'Toggled', $_[1]->IsChecked ); }
sub _Wx_CheckListBox_ItemToggled { emit_event( $_[0], $_[1], 'ItemToggled', $_[1]->GetInt, $_[0]->IsChecked( $_[1]->GetInt ) ); }
sub _Wx_Choice_ItemSelected { emit_event( $_[0], $_[1], 'ItemSelected', $_[1]->GetSelection ); emit_event( $_[0], $_[1], 'StringSelected', $_[1]->GetString ); }
sub _Wx_ComboBox_ItemSelected { emit_event( $_[0], $_[1], 'ItemSelected', $_[1]->GetSelection ); emit_event( $_[0], $_[1], 'StringSelected', $_[0]->GetValue ); }
sub _Wx_ComboBox_TextChanged { emit_event( $_[0], $_[1], 'TextChanged', $_[1]->GetString ); }
sub _Wx_ListBox_ItemDoubleClicked { emit_event( $_[0], $_[1], 'ItemDoubleClicked', $_[1]->GetInt ); }
sub _Wx_ListBox_ItemSelected { emit_event( $_[0], $_[1], 'ItemSelected', $_[1]->GetSelection ); emit_event( $_[0], $_[1], 'StringSelected', $_[1]->GetString ); }
sub _Wx_RadioBox_ItemSelected { emit_event( $_[0], $_[1], 'ItemSelected', $_[1]->GetSelection ); }
sub _Wx_RadioButton_Toggled { emit_event( $_[0], $_[1], 'Toggled', $_[0]->GetValue ); }
sub _Wx_SpinButton_ArrowDown { emit_event( $_[0], $_[1], 'ArrowDown', $_[1]->GetPosition ); }
sub _Wx_SpinButton_ArrowUp { emit_event( $_[0], $_[1], 'ArrowUp', $_[1]->GetPosition ); }
sub _Wx_SpinButton_PositionChanged { emit_event( $_[0], $_[1], 'PositionChanged', $_[1]->GetPosition ); }
sub _Wx_SpinCtrl_PositionChanged { emit_event( $_[0], $_[1], 'PositionChanged', $_[1]->GetInt ); }
sub _Wx_SpinCtrl_TextChanged { emit_event( $_[0], $_[1], 'TextChanged', $_[1]->GetString ); }
sub _Wx_TextCtrl_EnterPressed { emit_event( $_[0], $_[1], 'EnterPressed' ); }
sub _Wx_TextCtrl_LengthExceeded { emit_event( $_[0], $_[1], 'LengthExceeded' ); }
sub _Wx_TextCtrl_TextChanged { emit_event( $_[0], $_[1], 'TextChanged', $_[1]->GetString ); }
sub _Wx_Timer_Timeout { emit_event( $_[0], $_[1], 'Timeout' ); }
sub _Wx_ToggleButton_Toggled { emit_event( $_[0], $_[1], 'Toggled', $_[1]->IsChecked ); }
sub _Wx_Window_Destroyed { emit_event( $_[0], $_[1], 'Destroyed', $_[0] ); }
sub _Wx_Window_Idle { emit_event( $_[0], $_[1], 'Idle' ); }

### END FUNCTIONS ###

sub _Wx_ScrollBar_Scroll {
    my( $pos, $type ) = ( $_[1]->GetPosition, $_[1]->GetEventType );

    emit_event( $_[0], $_[1], 'ScrollTop', $pos )
      if $type == Wx::wxEVT_SCROLL_TOP;
    emit_event( $_[0], $_[1], 'ScrollBottom', $pos )
      if $type == Wx::wxEVT_SCROLL_BOTTOM;
    emit_event( $_[0], $_[1], 'ScrollLineUp', $pos )
      if $type == Wx::wxEVT_SCROLL_LINEUP;
    emit_event( $_[0], $_[1], 'ScrollLineDown', $pos )
      if $type == Wx::wxEVT_SCROLL_LINEDOWN;
    emit_event( $_[0], $_[1], 'ScrollPageUp', $pos )
      if $type == Wx::wxEVT_SCROLL_PAGEUP;
    emit_event( $_[0], $_[1], 'ScrollPageDown', $pos )
      if $type == Wx::wxEVT_SCROLL_PAGEDOWN;
    emit_event( $_[0], $_[1], 'ScrollThumbTrack', $pos )
      if $type == Wx::wxEVT_SCROLL_THUMBTRACK;
    emit_event( $_[0], $_[1], 'ScrollThumbRelease', $pos )
      if $type == Wx::wxEVT_SCROLL_THUMBRELEASE;
    emit_event( $_[0], $_[1], 'PositionChanged', $pos );
}

1;

# TODO: classes/events that need to be added
# wxBitmapButton
# wxBitmapComboBox
# wxCalendarCtrl
# wxChoiceBook, wxListbook, wxNotebook, wxToolbook, wxTreebook
# wxCollapsiblePane
# wxColourPickerCtrl
# wxComboCtrl
# wxDataViewCtrl
# wxDatePickerCtrl
# wxDirPickerCtrl
# wxEditableListBox
# wxFileCtrl
# wxFilePickerCtrl
# wxFindReplaceDialog
# wxFontPickerCtrl
# wxGridCtrl
# wxHtmlListBox
# wxHtmlWindow
# wxHyperlinkCtrl
# wxListCtrl, wxListView
# wxProcess
# wxSashWindow
# wxSearchCtrl
# wxSocket
# wxSplitterWindow
# wxStyledTextCtrl
# wxToolBar, wxMenuBar
# wxTreeCtrl
# wxWindow: wxCloseEvent, wxContextMenuEvent, wxHelpEvent
# wxWizard

__DATA__

=head1 NAME

Wx::Perl::PubSub::Events - lists the predefined event types

=head1 CLASSES

=head2 C<Wx::Button>

=head3 C<Clicked()>

=for generator EVT_BUTTON

Emitted when a push button is clicked.

=head2 C<Wx::CheckBox>

=head3 C<Toggled( $state )>

=for generator EVT_CHECKBOX $_[1]->IsChecked

Emitted when the checkbox is ticked/unticked.

=head2 C<Wx::CheckListBox>

=head3 C<ItemToggled( $index, $state )>

=for generator EVT_CHECKLISTBOX $_[1]->GetInt, $_[0]->IsChecked( $_[1]->GetInt )

Emitted when an item is checked/unchecked.

=head2 C<Wx::Choice>

=head3 C<ItemSelected( $index )>

=for generator EVT_CHOICE $_[1]->GetSelection

Emitted when a choice item is selected; takes the item index as
parameter.

=head3 C<StringSelected( $text )>

=for generator EVT_CHOICE $_[1]->GetString

Emitted when a choice item is selected; takes the item string as
parameter.

=head2 C<Wx::ComboBox>

=head3 C<ItemSelected( $index )>

=for generator EVT_COMBOBOX $_[1]->GetSelection

Emitted when a combo box item is selected; takes the item index as
parameter.

=head3 C<StringSelected( $text )>

=for generator EVT_COMBOBOX $_[0]->GetValue

Emitted when a combo box item is selected; takes the item string as
parameter.

=head3 C<TextChanged( $text )>

=for generator EVT_TEXT $_[1]->GetString

Emitted when the combo box text is edited; takes the modified string
as parameter.

=head2 C<Wx::ListBox>

=head3 C<ItemDoubleClicked( $index )>

=for generator EVT_LISTBOX_DCLICK $_[1]->GetInt

Emitted when a list box item is double clicked; taked the item index
as parameter.

=head3 C<ItemSelected( $index )>

=for generator EVT_LISTBOX $_[1]->GetSelection

Emitted when a list box item is selected; takes the item index as
parameter.

=head3 C<StringSelected( $text )>

=for generator EVT_LISTBOX $_[1]->GetString

Emitted when a list box item is selected; takes the item string as
parameter.

=head2 C<Wx::RadioBox>

=head3 C<ItemSelected( $index )>

=for generator EVT_RADIOBOX $_[1]->GetSelection

Emitted when a radio box item is selected; takes the item index as
parameter.

=head2 C<Wx::RadioButton>

=head3 C<Toggled()>

=for generator EVT_RADIOBUTTON $_[0]->GetValue

Emitted when a radio button is toggled.

=head2 C<Wx::ScrollBar>

=head3 C<PositionChanged( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollLineUp( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollLineDown( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollTop( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollBottom( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollPageUp( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollPageDown( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollThumbTrack( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollThumbRelease( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head2 C<Wx::Slider>

=head3 C<PositionChanged( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollLineUp( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollLineDown( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollTop( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollBottom( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollPageUp( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollPageDown( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollThumbTrack( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head3 C<ScrollThumbRelease( $position )>

=for generator EVT_SCROLL bind _Wx_ScrollBar_Scroll

=head2 C<Wx::SpinButton>

=head3 C<PositionChanged( $position )>

=for generator EVT_SPIN $_[1]->GetPosition

=head3 C<ArrowUp( $position )>

=for generator EVT_SPIN_UP $_[1]->GetPosition

=head3 C<ArrowDown( $position )>

=for generator EVT_SPIN_DOWN $_[1]->GetPosition

=head2 C<Wx::SpinCtrl>

=head3 C<PositionChanged( $position )>

=for generator EVT_SPINCTRL $_[1]->GetInt

Emitted when the value is changed using the arrow buttons.

=head3 C<TextChanged( $text )>

=for generator EVT_TEXT $_[1]->GetString

Emitted when the text is edited or the position is changed using the
arrow buttons; takes the modified string as parameter.

=head2 C<Wx::TextCtrl>

=head3 C<EnterPressed()>

=for generator EVT_TEXT_ENTER

Emitted when the user presses enter on a control with the
C<wxTE_PROCESS_ENTER> style.

=head3 C<LengthExceeded()>

=for generator EVT_TEXT_MAXLEN

Emitted when the user tries to enter more characters than the maximum limit.

=head3 C<TextChanged( $text )>

=for generator EVT_TEXT $_[1]->GetString

Emitted when the text is edited; takes the modified string as
parameter.

=head2 C<Wx::Timer>

=head3 C<Timeout()>

=for generator EVT_TIMER

Emitted every time the timer timeout expires.

=head2 C<Wx::ToggleButton>

=head3 C<Toggled( $state )>

=for generator EVT_TOGGLEBUTTON $_[1]->IsChecked

Emitted when the button is toggled.

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

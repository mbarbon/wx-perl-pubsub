#!/usr/bin/perl -w

# an interactive test script to check that all events are bound correctly
# to the corresponding signals

use strict;
use Wx;
use lib 'lib';

package MyFrame;

use base 'Wx::Frame';

use Wx qw(:sizer :listbook :radiobutton :scrollbar :slider :textctrl);
use Wx::Perl::PubSub qw(:local);
use Scalar::Util;

sub new {
    my( $class ) = @_;
    my $self = $class->SUPER::new( undef, -1, "Wx::Perl::PubSub test" );

    $self->{list} = Wx::Listbook->new( $self, -1, [-1, -1], [-1, -1], wxLB_LEFT );
    $self->{log} = Wx::TextCtrl->new( $self, -1, "", [-1, -1], [-1, -1],
                                      wxTE_MULTILINE );

    my $top = Wx::BoxSizer->new( wxVERTICAL );

    $top->Add( $self->{list}, 4, wxGROW|wxTOP|wxLEFT|wxRIGHT, 10 );
    $top->Add( $self->{log}, 1, wxGROW|wxALL, 10 );

    $self->SetSizer( $top );

    $self->_create_controls;

    return $self;
}

sub _create_controls {
    my( $self ) = @_;
    my $list = $self->{list};

    my $checkbox = Wx::CheckBox->new( $list, -1, 'Click me' );
    $self->_add_control( 'wxCheckBox', $checkbox, 'Toggled' );

    my $checklistbox = Wx::CheckListBox->new( $list, -1, [-1, -1], [-1, -1],
                                              [ qw(One Two Three) ] );
    $self->_add_control( 'wxCheckListBox', $checklistbox,
                         'ItemSelected', 'StringSelected', 'ItemToggled' );

    my $choice = Wx::Choice->new( $list, -1, [-1, -1], [-1, -1],
                                  [ qw(One Two Three) ] );
    $self->_add_control( 'wxChoice', $choice,
                         'ItemSelected', 'StringSelected' );

    my $combobox = Wx::ComboBox->new( $list, -1, "Default", [-1, -1], [-1, -1],
                                      [ qw(One Two Three) ] );
    $self->_add_control( 'wxComboBox', $combobox,
                         'ItemSelected', 'StringSelected', 'TextChanged' );

    my $listbox = Wx::ListBox->new( $list, -1, [-1, -1], [-1, -1],
                                    [ qw(One Two Three) ] );
    $self->_add_control( 'wxListBox', $listbox,
                         'ItemSelected', 'StringSelected',
                         'ItemDoubleClicked' );

    my $radiobox = Wx::RadioBox->new( $list, -1, 'Click me', [-1, -1], [-1, -1],
                                      [ qw(One Two Three) ] );
    $self->_add_control( 'wxRadioBox', $radiobox, 'ItemSelected' );

    my $radiobuttonpanel = Wx::Panel->new( $list, -1 );
    my $radiobutton1 = Wx::RadioButton->new( $radiobuttonpanel, -1, 'Radio 1',
                                             [10, 10], [-1, -1], wxRB_GROUP );
    my $radiobutton2 = Wx::RadioButton->new( $radiobuttonpanel, -1, 'Radio 2',
                                             [10, 110], [-1, -1] );
    $self->_add_control( 'wxRadioButton', $radiobuttonpanel );
    $self->_bind_event( $radiobutton1, 'Toggled' );
    $self->_bind_event( $radiobutton2, 'Toggled' );

    my $scrollbar = Wx::ScrollBar->new( $list, -1, [-1, -1], [-1, -1],
                                        wxSB_HORIZONTAL );
    $scrollbar->SetScrollbar( 10, 4, 100, 20 );
    $self->_add_control( 'wxScrollBar', $scrollbar,
                         'PositionChanged', 'ScrollTop', 'ScrollBottom',
                         'ScrollLineUp', 'ScrollLineDown', 'ScrollPageUp',
                         'ScrollPageDown', 'ScrollThumbTrack',
                         'ScrollThumbRelease' );

    my $slider = Wx::Slider->new( $list, -1, [-1, -1], [-1, -1],
                                  wxSL_HORIZONTAL );
    $slider->SetRange( 0, 100 );
    $self->_add_control( 'wxSlider', $slider,
                         'PositionChanged', 'ScrollTop', 'ScrollBottom',
                         'ScrollLineUp', 'ScrollLineDown', 'ScrollPageUp',
                         'ScrollPageDown', 'ScrollThumbTrack',
                         'ScrollThumbRelease' );

    my $spinbutton = Wx::SpinButton->new( $list, -1 );
    $spinbutton->SetRange( 5, 20 );
    $self->_add_control( 'wxSpinButton', $spinbutton,
                         'PositionChanged', 'ArrowUp', 'ArrowDown' );

    my $spinctrl = Wx::SpinCtrl->new( $list, -1, "12" );
    $spinctrl->SetRange( 5, 20 );
    $self->_add_control( 'wxSpinCtrl', $spinctrl,
                         'PositionChanged', 'TextChanged' );

    my $textctrl = Wx::TextCtrl->new( $list, -1, 'Edit me', [-1, -1], [-1, -1],
                                      wxTE_PROCESS_ENTER );
    $textctrl->SetMaxLength( 20 );
    $self->_add_control( 'wxTextCtrl', $textctrl, 'LengthExceeded',
                         'TextChanged', 'EnterPressed' );

    my $togglebutton = Wx::ToggleButton->new( $list, -1, "Toggle me" );
    $self->_add_control( 'wxToggleButton', $togglebutton, 'Toggled' );
}

sub _add_control {
    my( $self, $name, $window, @signals ) = @_;

    $self->{list}->AddPage( $window, $name );
    foreach my $signal ( @signals ) {
        $self->_bind_event( $window, $signal );
    }
}

my @list;

sub _bind_event {
    my( $self, $window, $signal ) = @_;

    push @list, my $dump = sub {
        my( @args ) = @_;

        $self->_dump( $signal, @args );
    };

    subscribe( $window, $signal, $dump );
}

sub _pretty {
    my( $value ) = @_;

    return 'undef' unless defined $value;
    return $value if Scalar::Util::looks_like_number( $value );
    return "\"$value\"";
}

sub _dump {
    my( $self, $signal, @args ) = @_;
    my $sender = Wx::Perl::PubSub::sender();

    if( @args ) {
        $self->{log}->AppendText( sprintf "%s => %s => %s\n",
                                  ref( $sender ), $signal,
                                  join " ", map _pretty( $_ ), @args );
    } else {
        $self->{log}->AppendText( sprintf "%s => %s => <no argument>\n",
                                  ref( $sender ), $signal );
    }
}

package main;

my $app = Wx::SimpleApp->new;
my $frame = MyFrame->new;

$frame->SetSize( 700, 600 );
$frame->Show;
$app->MainLoop;

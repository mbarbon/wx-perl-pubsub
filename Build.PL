#!/usr/bin/perl -w

use strict;
use Module::Build;

my $class = Module::Build->subclass
  ( class       => 'My::Build',
    code        => <<'EOT',
sub ACTION_code {
    my( $self ) = @_;

    $self->SUPER::ACTION_code;
    $self->do_system( $^X, 'scripts/make_event_list.pl',
                           'lib/Wx/Perl/PubSub/Events.pm' );
}
EOT
    );

my $build = $class->new
  ( module_name => 'Wx::Perl::PubSub',
    license     => 'perl',
    requires    => { 'Wx'       => 0,
                     'Exporter' => '5.57',
                     },
    );
$build->create_build_script;

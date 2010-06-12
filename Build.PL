#!/usr/bin/perl -w

use strict;
use Module::Build;

my $build = Module::Build->new
  ( module_name => 'Wx::Perl::SignalSlots',
    license     => 'perl',
    requires    => { 'Wx'       => 0,
                     'Exporter' => '5.57',
                     },
    );
$build->create_build_script;

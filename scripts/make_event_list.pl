#!/usr/bin/perl -w

use strict;
use warnings;

use Wx;
use File::Slurp qw(read_file write_file);

my $file = $ARGV[0];
my( %map, $map, $functions );

foreach my $line ( <DATA> ) {
    chomp $line;

    my( $event, $class, $macro, $args ) = split /\s+/, $line, 4;
    ( my $function = "_${class}_${event}" ) =~ s/::/_/g;

    if( $args ) {
        $functions .= <<EOT
sub $function { emit( \$_[0], '$event', $args ) }
EOT
    } else {
        $functions .= <<EOT
sub $function { emit( \$_[0], '$event' ) }
EOT
    }

    my $macro_ref = do {
        no strict 'refs';
        \&{"Wx::Event::$macro"};
    };

    $map{$event}{$class} = [ length prototype $macro_ref, $macro, $function ];
}

foreach my $event ( sort keys %map ) {
    $map .= <<EOT;
    '$event' =>
        [
EOT

    foreach my $class ( sort keys %{$map{$event}} ) {
        my( $num, $macro, $function ) = @{$map{$event}{$class}};
        $map .= <<EOT;
          '$class' =>
              [ $num, \\&Wx::Event::$macro, \\&$function ],
EOT
    }

    $map .= <<EOT;
          ],
EOT
}

my $contents = read_file( $file );

$contents =~ s{(?<=### BEGIN EVENTS ###).*(?=### END EVENTS ###)}
              {\n\n$map\n}s;
$contents =~ s{(?<=### BEGIN FUNCTIONS ###).*(?=### END FUNCTIONS ###)}
              {\n\n$functions\n}s;

write_file( $file, $contents );

__END__
Clicked           Wx::Button         EVT_BUTTON
ItemSelected      Wx::ListBox        EVT_LISTBOX       $_[1]->GetInt
Idle              Wx::Window         EVT_IDLE
Timeout           Wx::Timer          EVT_TIMER

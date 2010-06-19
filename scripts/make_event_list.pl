#!/usr/bin/perl -w

use strict;
use warnings;

use Wx;
use File::Slurp qw(read_file write_file);

my $file = $ARGV[0];
my( %map, $map, $functions );

my $contents = my $original_contents = read_file( $file );

my( $event, $class, $macro, $args );

foreach my $line ( split /\n+/, $contents ) {
    if( $line =~ /^=head2 C<([a-zA-Z0-9_:]+)>/ ) {
        $class = $1;
        $event = undef;
        next;
    }

    if( $line =~ /^=head3 C<([a-zA-Z0-9_]+)\([^)]*\)>/ ) {
        $event = $1;
        next;
    }

    if( $line =~ /^=for generator (\w+)(?: (.*))?$/ ) {
        ( $macro, $args ) = ( $1, $2 );
        die "No class/event" unless $class && $event;
    } else {
        next;
    }

    ( my $function = "_${class}_${event}" ) =~ s/::/_/g;

    if( $args ) {
        $functions .= <<EOT
sub $function { emit_event( \$_[0], \$_[1], '$event', $args ) }
EOT
    } else {
        $functions .= <<EOT
sub $function { emit_event( \$_[0], \$_[1], '$event' ) }
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

$contents =~ s{(?<=### BEGIN EVENTS ###).*(?=### END EVENTS ###)}
              {\n\n$map\n}s;
$contents =~ s{(?<=### BEGIN FUNCTIONS ###).*(?=### END FUNCTIONS ###)}
              {\n\n$functions\n}s;

if( $original_contents ne $contents ) {
    print "Writing updated '$file'\n";
    write_file( $file, $contents );
}

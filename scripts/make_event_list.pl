#!/usr/bin/perl -w

use strict;
use warnings;

use Wx;
use File::Slurp qw(read_file write_file);

my $file = $ARGV[0];
my( %map, %emit_code, $map, $functions );

my $contents = my $original_contents = read_file( $file );

my( $event, $class, $macro, $args, $sub, $line_count );

foreach my $line ( split /\n/, $contents ) {
    ++$line_count;

    if( $line =~ /^=head2 C<([a-zA-Z0-9_:]+)>/ ) {
        $class = $1;
        $event = $macro = $sub = $args = undef;
        next;
    }

    if( $line =~ /^=head3 C<([a-zA-Z0-9_]+)\([^)]*\)>/ ) {
        $event = $1;
        next;
    }

    if( $line =~ /^=for generator (\w+)\s+bind\s+(\w+)$/ ) {
        ( $macro, $sub ) = ( $1, $2 );
        die "No class/event at line $line_count" unless $class && $event;
    } elsif( $line =~ /^=for generator (\w+)(?: (.*))?$/ ) {
        ( $macro, $args ) = ( $1, $2 );
        die "No class/event at line $line_count" unless $class && $event;
    } else {
        next;
    }

    my( $emit_code, $function ) = ( '', undef );
    if( $sub ) {
        $function = $sub;
    } else {
        ( $function = "_${class}_${event}" ) =~ s/::/_/g;

        if( $args ) {
            $emit_code = "emit_event( \$_[0], \$_[1], '$event', $args ); "
        } else {
            $emit_code = "emit_event( \$_[0], \$_[1], '$event' ); "
        }
    }

    my $macro_ref = do {
        no strict 'refs';
        \&{"Wx::Event::$macro"};
    };

    die "Unable to determine binder type for '$macro'"
      unless defined prototype $macro_ref;

    $emit_code{$macro} ||= [ $function, '' ];
    $emit_code{$macro}[1] .= $emit_code;
    $map{$event}{$class} = [ length prototype $macro_ref, $macro,
                             $emit_code{$macro}[0] ];
}

foreach my $f ( sort { $a->[0] cmp $b->[0] } values %emit_code ) {
    next unless $f->[1];
    $functions .= <<EOT;
sub $f->[0] { $f->[1]}
EOT
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

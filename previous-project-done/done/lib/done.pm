package done;

use warnings;
use strict;
use Class::Date ();
use YAML::Syck ();
use Path::Class ();
use File::HomeDir;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my $home = File::HomeDir->my_home;
    my $dir = Path::Class::dir( $home, '.done' );
    -d $dir or $dir->mkpath;
    $self->{'dir'} = $dir;
    return $self;
}

sub parse {
    my $self = shift;
    my $string = shift;

    # at
    my $at = Class::Date::now();
    my $thing = { at => "$at" };

    if ( $string =~ /;/ ){

        my ( $param, $what ) = split(/;/, $string, 2);
        my ( $during, $tag ) = split(/,/, $param);

        # start, due, spent
        my ( $start, $due ) = $self->parse_during( $during );
        my $spent = $self->sec2hms( $due - $start );

        # tags
        my @tags = map { lc } split(/:/, $tag ) if defined $tag;

        $thing->{'start'} = "$start";
        $thing->{'due'} = "$due";
        $thing->{'spent'} = $spent;
        $thing->{'tags'} = join(',', @tags);
        $thing->{'what'} = $what;

    }else{

        $thing->{'start'} = $thing->{'at'};
        $thing->{'due'} = $thing->{'at'};
        $thing->{'spent'} = 0;
        $thing->{'tags'} = '';
        $thing->{'what'} = $string;
    }

    return $thing;
}

sub save {
    my $self = shift;
    my $thing = shift;

    my $due = Class::Date::date( $thing->{'due'} );
    my $file = $self->dayfile( $due );

    my $things = $self->things_of_day( $due );
    push @$things, $thing;
    YAML::Syck::DumpFile( $file, $things);
}

sub things_of_day {
    my $self = shift;
    my $day = shift || Class::Date::now();
    my $file = $self->dayfile( $day );

    return [] unless -f $file;
    my $things = YAML::Syck::LoadFile( $file );
    return $things;
}

sub dayfile {
    my $self = shift;
    my $day = shift;
    my $ymd = $day->ymd;
    $ymd =~ s/\//-/g;
    return $self->{'dir'}->file( $ymd.".yaml" )->stringify;
}

sub parse_during {
    my $self = shift;
    my $string = shift;

    my @startdue = split(/-/, $string);
    my $start = $self->parse_date( shift @startdue );
    my $due = ( scalar @startdue ) ? $self->parse_date( shift @startdue ) : Class::Date::now();
    return undef if ref $start eq 'Class::Date::Rel' and ref $due eq 'Class::Date::Rel';

    if ( ref $start eq 'Class::Date::Rel' and ref $due eq 'Class::Date' ){
        $start = $due - $start;
    }elsif ( ref $start eq 'Class::Date' and ref $due eq 'Class::Date::Rel' ){
        $due = $start + $due;
    }

    return ( $start, $due );
}

sub parse_date {
    my $self = shift;
    my $string = shift;

    my $datenow = Class::Date::now();
    my $ymd = $datenow->ymd;
    $ymd =~ s/\//-/g;

    if ( $string =~ /^\d{4}$/ ){
        $string =~ s/^(\d\d)/$1:/;
        return Class::Date::date( sprintf "%s %s", $ymd, $string );
    }elsif ( $string =~ /[hms]/ ){
        $string =~ s/([hm])/$1 /g;
        if ( $string =~ /\d$/ ){
            if ( $string =~ /h/ and $string !~ /m/ ){
                $string .='m';
            }elsif( $string =~ /[hm]/ ){
                $string .='s'; 
            }
        }
        return new Class::Date::Rel $string;
    }else{
        return $datenow;
    }
}

sub sec2hms{
    my $self = shift;
    my $seconds = shift;
    my $hours = ( $seconds - $seconds % 3600 ) / 3600;
    $seconds -= $hours * 3600;
    my $minutes = ( $seconds - $seconds % 60 ) / 60;
    $seconds -= $minutes * 60;
    return join('',
        ( $hours ) ? $hours.'h' : '',
        ( $minutes ) ? $minutes.'m' : '',
        ( $seconds ) ? $seconds.'s' : ''
    );
}

=head1 NAME

done - The great new done!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use done;

    my $foo = done->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.


=head1 AUTHOR

chunzi@gmail.com, C<< <chunzi at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-done at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=done>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc done


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=done>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/done>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/done>

=item * Search CPAN

L<http://search.cpan.org/dist/done/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 chunzi@gmail.com, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of done

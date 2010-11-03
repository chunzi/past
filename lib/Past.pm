package Past;

use strict;
our $VERSION = '0.1';

use Past::DB::Thing;
use Class::Date qw/gmdate now/;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;    
}

sub thing {
    my $self = shift;
    my $content = shift;
    my $now = gmdate(time);
    my $thing = Past::DB::Thing->new( content => $content, created => $now->epoch );
    $thing->save;
}

sub get_thing {
    my $self = shift;
    my $id = shift;
    my $thing = Past::DB::Thing->new( id => $id )->load;
    return $thing;
}

sub things_for_days {
    my $self =  shift;
    my $things = Past::DB::Thing::Manager->get_things();
    return $things;
}
sub things_for_day {
    my $self =  shift;
    my $day = shift || 'today';

    my $date_begin;
    if ( $day eq 'today' ){
        my $now = gmdate(time);
        $date_begin = gmdate( join '-', $now->year, $now->month, $now->day );
    }else{
        $day =~ s/^(\d{4})(\d{2})(\d{2})$/\1-\2-\3/;
        $date_begin = gmdate( $day );
    }
    my $date_end = $date_begin + '1D';

 
    my $things = Past::DB::Thing::Manager->get_things(
      query => [
        created  => { gt => $date_begin->epoch },
        created  => { lt => $date_end->epoch },
      ],
      sort_by => 'created',
    );

    return {
        day => $date_begin,
        things => $things,
    };
}
1;

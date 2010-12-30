#!perl -T

use Test::More tests => 8;
use done;
my $done = new done;
my $thing;

use Class::Date qw( date now );

$thing = $done->parse('just what have done');
ok( $thing, 'got thing');
is( date($thing->{'at'}) - now(), 0, 'thing at now');
is( $thing->{'what'}, 'just what have done', 'what thing');

$thing = $done->parse('2h;something done');
is( $thing->{'spent'}, '2h', 'spent 2h');
is( date($thing->{'due'}) - now(), 0, 'till now');
is( $thing->{'what'}, 'something done');


$thing = $done->parse('30m,ironport:wsr;something done');
is( $thing->{'spent'}, '30m', 'spent 30m');
is( $thing->{'tags'}, 'ironport,wsr');


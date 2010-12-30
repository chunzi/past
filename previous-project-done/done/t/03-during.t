#!perl -T

use Test::More tests => 10;
use done;
my $done = new done;

use Class::Date qw(date now);
my $start; my $due; my $string;

# 2h20m: start 2 hours and 20 minutes ago, till now
$string = '2h20m';
( $start, $due ) = $done->parse_during($string);
is( date($due) - date($start), '8400', "spent seconds for $string");
is( date($due) - now, '0', 'should till now');

# 1345: start at 13:45, till now
$string = '1345';
( $start, $due ) = $done->parse_during($string);
like( date($start), qr/\b13:45:00\b/, "start for $string");
is( date($due) - now, '0', 'should till now');

# 1345-30m: start at 13:45, worked half an hour, till 14:15
$string = '1345-30m';
( $start, $due ) = $done->parse_during($string);
like( date($start), qr/\b13:45:00\b/, "start for $string");
like( date($due), qr/\b14:15:00\b/, "due for $string");

# 30m-1415: same as above; end at 14:15, worked half an hour
$string = '30m-1415';
( $start, $due ) = $done->parse_during($string);
like( date($start), qr/\b13:45:00\b/, "start for $string");
like( date($due), qr/\b14:15:00\b/, "due for $string");

# 1345-1415: same as above
$string = '1345-1415';
( $start, $due ) = $done->parse_during($string);
like( date($start), qr/\b13:45:00\b/, "start for $string");
like( date($due), qr/\b14:15:00\b/, "due for $string");


#!perl -T

use Test::More tests => 11;
use done;
my $done = new done;

# absolute date
like( $done->parse_date('1345'), qr/\b13:45:00\b/, 'four digits');

# reldate
is( $done->parse_date('35s'), '35', '35 seconds as seconds');
is( $done->parse_date('5m'), '300', '5m as seconds');
is( $done->parse_date('3h'), '10800', '3 hours as seconds');

is( $done->parse_date('2h10m'), '7800', '2 hours and 10 minutes as seconds');
is( $done->parse_date('2h10'), '7800', '2 hours and 10 minutes as seconds');
is( $done->parse_date('2h10s'), '7210', '2 hours and 10 seconds as seconds');

is( $done->parse_date('2h10m35s'), '7835', '2 hours and 10 minutes and 35 seconds as seconds');
is( $done->parse_date('2h10m35'), '7835', '2 hours and 10 minutes and 35 seconds as seconds');

is( $done->parse_date('10m35s'), '635', '10 minutes and 35 seconds as seconds');
is( $done->parse_date('10m35'), '635', '10 minutes and 35 seconds as seconds');

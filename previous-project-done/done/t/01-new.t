#!perl -T

use Test::More tests => 3;
use done;
my $done = new done;
ok( $done, 'new object');
my $dir = $done->{'dir'};
ok( $dir, 'dir defined');
ok( -d $dir, 'dir exists or created');


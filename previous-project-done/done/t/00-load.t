#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'done' );
}

diag( "Testing done $done::VERSION, Perl $], $^X" );

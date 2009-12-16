#!/usr/bin/perl
use lib './lib';
use Past::DB::Schema;
Past::DB::Schema->upgrade();

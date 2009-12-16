#!/usr/bin/env perl
use inc::Module::Install;

name 'Past';
all_from 'lib/Past.pm';

requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;

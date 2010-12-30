use inc::Module::Install;

name     'done';
all_from 'lib/done.pm';
author   'chunzi@gmail.com <chunzi@gmail.com>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;


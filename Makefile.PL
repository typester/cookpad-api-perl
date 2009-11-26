use inc::Module::Install;
name 'WebService-CookPad';
all_from 'lib/WebService/CookPad.pm';

requires 'Any::Moose';
requires 'LWP::UserAgent';
requires 'XML::Parser';
requires 'XML::Simple';
requires 'Try::Tiny';

test_requires 'Test::More';
use_test_base;
author_tests('xt');

auto_include;
auto_set_repository;

WriteAll;

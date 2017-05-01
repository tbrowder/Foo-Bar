use v6;
use Test;

#use Foo::Bar :ALL;
use Foo::Bar;

plan 1;

use-ok 'Foo::Bar';

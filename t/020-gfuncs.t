use v6;
use Test;

use GFUNCS :ALL;

plan 3;
 
my $v1 = Version.new(major => 1, minor => 2, patch => 3);
my $v2 = Version.new(major => 0, minor => 2, patch => 3);
my $v3 = Version.new(major => 1, minor => 1, patch => 3);
my $v4 = Version.new(major => 1, minor => 2, patch => 2);

cmp-ok $v2, '<', $v1;
cmp-ok $v3, '<', $v1;
cmp-ok $v3, '<', $v4;

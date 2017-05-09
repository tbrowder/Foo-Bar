use v6;
use Test;

use GFUNCS :ALL;

plan 6;
 
my $v1 = GFUNCS::Version.new(major => 1, minor => 2, patch => 3);
my $v2 = GFUNCS::Version.new(major => 0, minor => 2, patch => 3);
my $v3 = GFUNCS::Version.new(major => 1, minor => 1, patch => 3);
my $v4 = GFUNCS::Version.new(major => 1, minor => 2, patch => 2);

#say $v2 < $v1;

ok va-lt-vb $v2, $v1;
nok va-lt-vb $v1, $v2;

ok va-lt-vb $v3, $v1;
nok va-lt-vb $v1, $v3;

ok va-lt-vb $v3, $v4;
nok va-lt-vb $v4, $v3;

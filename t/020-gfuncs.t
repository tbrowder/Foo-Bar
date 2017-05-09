use v6;
use Test;

use GFUNCS :ALL;

plan 11;
 
my $v1 = MVersion.new(major => 1, minor => 2, patch => 3);
my $v2 = MVersion.new(major => 0, minor => 2, patch => 3);
my $v3 = MVersion.new(major => 1, minor => 1, patch => 3);
my $v4 = MVersion.new(major => 1, minor => 2, patch => 2);

#say $v2 < $v1;

ok va-lt-vb $v2, $v1;
nok va-lt-vb $v1, $v2;

ok va-lt-vb $v3, $v1;
nok va-lt-vb $v1, $v3;

ok va-lt-vb $v3, $v4;
nok va-lt-vb $v4, $v3;

my $s;
$s = $v1.Str;
is $s, "1.2.3";

$s = $v2.Str;
is $s, "0.2.3";

$s = $v3.Str;
is $s, "1.1.3";

$s = $v4.Str;
is $s, "1.2.2";

my @mv = [$v4, $v3, $v2, $v1];
my $mv = get-latest-mversion @mv;
$s = $mv.Str;
is $s, "1.2.3";

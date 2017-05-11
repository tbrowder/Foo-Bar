use v6;
use Test;

use GFUNCS :ALL;
use MVersion;

plan 17;
 
my $v1 = MVersion.new(1, 2, 3);
my $v2 = MVersion.new(0, 2, 3);
my $v3 = MVersion.new(1, 1, 3);
my $v4 = MVersion.new(1, 2, 2);

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

my @in = [
"1 2 3",
"4 5 6",
"2 3 4",
];
 
for @in {
    my @w = $_.words;
    my UInt $a = +@w[0];
    my UInt $b = +@w[1];
    my UInt $c = +@w[2];

    my Str $s0 = "$a.$b.$c";

    my $m1 = MVersion.new($a, $b, $c);
    my $m2 = MVersion.new($s0);

    $s = $m1.Str;
    is $s, $s0;

    $s = $m2.Str;
    is $s, $s0;
}

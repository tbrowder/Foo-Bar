use Test;

use Foo::Bar;
use File::Temp;

my $debug = 1;

# exercise loading the example in resources
my %rpaths = get-resources-hash;
if $debug {
    say "DEBUG: \%rpaths:";
    my @k = %rpaths.keys.sort;
    for @k -> $k {
        my $f = %rpaths{$k};
        say "  $f";
        my $s = get-content $f;
        say "    contents: ", $s;
    }
    say "DEBUG: early exit"; exit;
}

my $eg     = "zz-UseResources.t";
my $eg-path;
my $istr = "(no content)";
if %rpaths{$eg}:exists {
   $eg-path = %rpaths{$eg};
   $istr = get-content $eg-path;
}
else {
    #die "FATAL: \$eg-path is undefined";
    say "WARNING: \$eg-path is undefined";
}

lives-ok {
    for $istr.lines -> $line {
        say "line: $line"
    }
}, "contents of dir 'resources'";

# check downloading resource files
my $tdir;
if $debug {
    $tdir = './tmp';
    mkdir $tdir;
}
else {
    $tdir = tempdir;
}
chdir $tdir;

lives-ok {
    show-resources;
}

lives-ok {
    download-resources;
}

done-testing;

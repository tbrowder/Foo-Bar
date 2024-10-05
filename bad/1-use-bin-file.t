use Test;

use ExampleLib::UseResources;
use File::Temp;

my $debug = 1;

# exercise the bin file
my $f = "./bin/copy-resources-module";
is $f.IO.e, True;

done-testing;
=finish
my %rpaths = get-resources-hash;
my $eg = "99-resources.t";
my $eg-path;
if %rpaths{$eg}:exists {
   $eg-path = %rpaths{$eg}
}
else {
    die "FATAL: \$eg-path is undefined";
}

my $istr = get-content $eg-path;
lives-ok {
    for $istr.lines -> $line {
        say "line: $line"
    }
}, "contentents of dir 'resources'";

# check downloading resource files
my $tdir;
if $debug {
    $tdir = './tmp';
    mkdir $tdir;
    chdir $tdir;
}
else {
    $tdir = tempdir;
    chdir $tdir;
}

lives-ok {
    show-resources;
}

lives-ok {
    download-resources;
}

done-testing;

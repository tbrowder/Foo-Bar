use Test;

use Foo::Bar;

use File::Temp;

plan 5;

my $tdir = tempdir;
is $tdir.IO.d, True, "$tdir is a directory";


my $p;
lives-ok { 
    $p = run <bin/foo-bar s>, :out; #, :err; 
    is $p.exitcode, 0;
}, "show-resource-filess runs ok";

lives-ok { 
    $p = run <bin/foo-bar d=$tdir>, :out; #:err; 
    is $p.exitcode, 0;
}, "download-resources-files runs ok with $tdir";

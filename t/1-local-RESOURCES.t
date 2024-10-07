use Test;

use Foo::Bar;

plan 2;

lives-ok { 
    run <bin/foo-bar show-resources-files>; 
}, "show-resource-filess runs ok";

lives-ok { 
    run <bin/foo-bar d f >; 
}, "download-resources-files runs ok";

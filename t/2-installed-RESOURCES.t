use Test;

use Foo::Bar;

if defined %?RESOURCES {
    lives-ok { show-resources; }, "show-resources";
    lives-ok { download-resources; }, "download-resources";
}
else {
    is 1, 1, "ok, NOT an installed DISTRIBUTION";
}

done-testing;

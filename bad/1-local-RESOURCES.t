use Test;

use Foo::Bar;

if not defined %?RESOURCES {
    is 1, 1, "ok, NOT an installed DISTRIBUTION";
}
lives-ok { show-resources; }, "show-resources";
lives-ok { download-resources; }, "download-resources";

done-testing;

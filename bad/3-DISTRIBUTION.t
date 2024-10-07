use Test;

use Foo::Bar;

if not defined $?DISTRIBUTION {
    is 1, 1, "ok, NOT an installed DISTRIBUTION";
}
else {
    is 1, 1, "ok, this IS an installed DISTRIBUTION";
}

lives-ok {
    my $ver = version;
    say "Version: $ver";
}, "version is ok";

lives-ok {
    my $auth = author;
    say "Author: $auth";
}, "auth is ok";

lives-ok {
    my $api = api;
    say "API: $api";
}, "api is ok";

done-testing;

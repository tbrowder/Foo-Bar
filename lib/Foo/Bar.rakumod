unit class Foo::Bar;




#===================
# installed resource routines (per current docs)
sub show-resources(
    :$debug,
    ) is export {

    # get keys which are paths from /resources
    my @paths = %?RESOURCES.keys;
    if @paths.head == 0 {
        say "Sorry, this is not an installed DISTRIBUTION";
        return;
    }
    
    say "Resources that you can 'slurp':";
    say "  $_" for @paths;
}

sub download-resources(
    :$debug,
    ) is export {
    my @paths = %?RESOURCES.keys;
    if @paths.head == 0 {
        say "Sorry, this is not an installed DISTRIBUTION";
        return;
    }
    
    say "Downloading /resources files:";
    for @paths -> $path {
        # for the spurt
        my $basename = $path.IO.basename; # this may not work
           # may have to treat as a string and chop all at and before the
           # last "/"
        say "  $basename";
        my $s = $path.IO.slurp;
        spurt $basename, $s;
    }
}

#===================
# compile-time routines (i.e., local)
sub version(
    :$debug,
    ) is export {
    say $?DISTRIBUTION.meta<ver>;
}

our &author = &auth;
sub auth(
    :$debug,
    ) is export {
    say $?DISTRIBUTION.meta<auth>;
}

sub api(
    :$debug,
    ) is export {
    say $?DISTRIBUTION.meta<api>;
}

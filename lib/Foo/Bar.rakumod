unit class Foo::Bar;

#===================
# installed resource routines (per current docs)
sub get-meta-hash(:$debug --> Hash) is export {
   $?DISTRIBUTION.meta 
}

sub get-resources-hash(:$debug --> Hash) is export {
    my @list = get-resources-paths;
    # convert to a hash: key: file.basename => path
    my %h;
    for @list -> $path {
        my $f = $path.IO.basename;
        %h{$f} = $path;
    }
    %h
}

sub get-content($path, :$nlines = 0) is export {
    my $exists = resource-exists $path;
    unless $exists { return 0; }

    my $s = $?DISTRIBUTION.content($path).open.slurp;
    if $nlines {
        my @lines = $s.lines;
        my $nl = @lines.elems;
        if $nl >= $nlines {
            $s.lines[0..$nlines-1].join("\n");
        }
        else {
            $s;
        }
    }
    else {
        $s
    }
} # sub get-content($path, :$nlines = 0) is export {

sub show-resources(
    :$debug,
    ) is export {

    # sub get-resources-paths(:$debug --> List) {
    # get keys which are paths from /resources
    my @paths = get-resources-paths;
    if not @paths.elems {
        say "Sorry, no paths found (this MAY not be an installed DISTRIBUTION)";
        return;
    }
    
    say "Resources that you can 'slurp':";
    say "  $_" for @paths;
}

sub download-resources(
    :$debug,
    ) is export {
    my @paths = get-resources-paths;
    #my @paths = %?RESOURCES.keys;
    if not @paths.elems {
        say "Sorry, no paths found (this MAY not be an installed DISTRIBUTION)";
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
    $?DISTRIBUTION.meta<ver>;
}

our &author is export = &auth;
sub auth(
    :$debug,
    ) is export {
    $?DISTRIBUTION.meta<auth>;
}

sub api(
    :$debug,
    ) is export {
    $?DISTRIBUTION.meta<api>;
}

#===== non-exported routines
sub get-resources-paths(:$debug --> List) {
    my @list =
        $?DISTRIBUTION.meta<resources>.map({"resources/$_"});
    @list
}

sub resource-exists($path? --> Bool) {
    return False if not $path.defined;

    # "eats" both warnings and errors; fix coming to Zef
    # as of 2023-10-29
    # current working code courtesy of @ugexe
    try {
        so quietly $?DISTRIBUTION.content($path).open(:r).close; # may die
    } // False;
}

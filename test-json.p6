#!/usr/bin/env perl6

#use JSON::Fast;
use META6;

use Proc::More :run-command;
use Text::More :strip-comment;

use GFUNCS :ALL;

use lib <.>;
use META-VARS;

=begin pod
my $usage = "Usage: $*PROGRAM mode [options...]\nNOTE: The program MUST be executed at the top of the repo dir.";
say "$usage | -h" if !@*ARGS;
=end pod

my $suff    = 'template';
my $debug   = 0;
my $force   = 0;
my $exec    = 0;
my $mode    = ''; # p, r, or c
my $version = '';
my $gituser = %*ENV<GITHUB_USER>;
my $author  = $gituser;

my $jfil = './META6.json';
my $mfil = './.meta.in';
my $istr = slurp $jfil;

# NOTE: entries in the meta file must be recognized by the specs

# get the current meta
my $m = META6.new :file($jfil);
# mod an existing entry
$m<version> = '4.4.4';

# add a new value to an array
$m<tags>.append: "vars";

# change value of an array
$m<tags> = <vars>;

# change values of an array
$m<tags> = <vars functions>;

# add a new hash value
$m<provides><Bar::Foo> = "lib/Bar/Foo.pm6";

# add a new hash value
$m<support><bugtracker> = "https://github.com/tbrowder/Foo-Bar-Perl6/issues";


# write the modified meta out again
spurt $jfil, $m.to-json;


=begin pod
my @arr = from-json $istr;
say $ijs;
for @arr -> $o {
    say $o;
}
=end pod

exit;

=begin pod
for @*ARGS {
    when /:i ^<[-]>* h / {
	say "debug: arg is 'h' ('$_')" if $debug;
	help();
    }
    when /:i ^<[-]>* f / {
	say "debug: arg is '$_'" if $debug;
	$force = 1;
    }
    when /:i ^<[-]>* e / {
	say "debug: arg is '$_'" if $debug;
	$exec = 1;
    }
    when /:i ^<[-]>* [d | d <-[i]>+] $ / {
	say "debug: arg is '$_'" if $debug;
	$debug = 1;
    }

    when /:i ^ u '=' (.+) / {
	my $x    = ~$0;
	if !$x {
	    say "FATAL: Arg '$_' is incomplete.";
	    exit;
	}
	say "debug: arg is '$_'" if $debug;
	$gituser = $x;
    }
    when /:i ^ (<[prc]>) '=' (.+) / {
        my $mode = ~$0;
	my $x    = ~$1;
	if !$x {
	    say "FATAL: Arg '$_' is incomplete.";
	    exit;
	}
	if $x !~~ &version {
	    say "FATAL: Arg '$_' is not in 'n.n.n' format.";
	    exit;
	}
	say "debug: arg is '$_'; X = '$x'" if $debug;
	$version = $x;
    }
    default { die "FATAL: Unknown arg '$_'." if $debug; }
}

die "FATAL: No mode chosen."  if !$mode;
die "FATAL: No user defined." if !$gituser;

given $mode {
    when /^p/ { prepare-github-release $version, $author; }
    when /^r/ { create-github-release $version; }
    when /^c/ { check-github-release $version; }
}

#### SUBROUTINES ####
sub help {
    say qq:to/HERE/;
    $usage

    Provides functions for releasing and maintaining a public
    Perl 6 module hosted on github.

    Modes:

      p=X - check and prepare files for a valid release
      r=X - create the release
      c=X - check the release data on github

            X is a github release tag. X format is 'n.n.n'
	    where n.n.n is the release version number which should be higher
	    than the last. Creation is a dry run only unless the 'exec'
	    option is used.

    Options:

      u=Y    - Y is the Github user name. It also may be defined in environment
               variable GITHUB_USER.

      exec   - Execute a real command such as a github release.

      force  - Force overwriting existing files (otherwise the '.$suff' version
               is written).

      d      - Debug.
    HERE
    exit;
} # help
=end pod

sub read-meta-in(META6 $m) {
    # read the default data for a repo
    # must be in a repo dir
    die "FATAL: Must be in a repo dir with a .git sub-dir" if !".git".IO.d;

    if !$mfil.f {
        say "WARNING: No file '$mfil' exists in this repo.";
        return;
    }

    for $mfil.IO.lines -> $line is copy {
        $line = strip-comment $line;
        next if $line !~~ /\S/;
        my @w = $line.words;
        my $sect = shift @w;
        my $nw = +@w;
        if !$nw {
            say "WARNING: Section '$sect' is unknown." if !isa-meta-section($sect);
            say "WARNING: Section '$sect' has no value...skipping";
            next;
        }
        handle-section($sect, @w, $m);
    }

    # do we have the mandatory sections?
    die "fix this";
}

sub handle-section($section, @words, META6 $m) {
        given $section {
            when 'name' {
                # S22 mandatory
            }
            when 'description' {
                # S22 mandatory
            }
            when 'perl' {
                # S22 mandatory
            }
            when 'version' {
                # S22 mandatory
            }

            when 'name' {
                # mandatory
            }
            when 'name' {
                # mandatory
            }
            when 'name' {
                # mandatory
            }
            default { die "FATAL: Unhandled section '$section' in file '$mfil'."; }
        }
} # handle-section

#!/usr/bin/env perl6

#use JSON::Fast;
use META6;

use GFUNCS :ALL;

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
my $istr = slurp $jfil;

my $m = META6.new :file($jfil);

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

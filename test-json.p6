#!/usr/bin/env perl6 
use META6;

use Proc::More :run-command;
use Text::More :strip-comment;

use GFUNCS :ALL;

use lib <.>;
use META-VARS;

my $gituser = %*ENV<GITHUB_USER>;
my $author  = $gituser;

# NOTE: entries in the meta file must be recognized by the specs
my $jfil = './META6.json';
my $mfil = './.meta.in';

# get the current meta, if any
my $m = META6.new :file($jfil);

# if in mode init, read the .meta.in file
my $mode = 'init';
if $mode eq 'init' {
    #init-sections $m;
    read-meta-in $m;
    spurt $jfil, $m.to-json;
}

=begin pod
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
=end pod

#### SUBROUTINES ####
sub read-meta-in(META6 $m) {
    # read the default data for a repo
    # must be in a repo dir
    die "FATAL: Must be in a repo dir with a .git sub-dir" if !".git".IO.d;

    if !$mfil.IO.f {
        say "WARNING: No file '$mfil' exists in this repo.";
        return;
    }

    for $mfil.IO.lines -> $line is copy {
        $line = strip-comment $line;
        next if $line !~~ /\S/;
        my @w = $line.words;
        my $sect = shift @w;
        if !isa-meta-section($sect) {
            say "WARNING: Section '$sect' is unknown.";
            next;
        }
        handle-section($sect, @w, $m);
    }

    # do we have the mandatory sections?
    check-mandatory-sections;

} # read-meta-in

sub check-mandatory-sections {
    for %ms.kv -> $k, $v {
        say "Missing value for S22 mandatory section '$k'." if !$v;
    }
    for %us.kv -> $k, $v {
        say "Missing value for user mandatory section '$k'." if !$v;
    }
}

sub handle-section($section, @words is copy, META6 $m) {
    my $nw = +@words;

=begin pod
    if !$nw {
        say "WARNING: Section '$sect' is unknown." if !isa-meta-section($sect);
        say "WARNING: Section '$sect' has no value.";
        next if not %ms{$sect}:exists and not %ms{$sect}:exists;
    }
=end pod

    given $section {
        when 'name' {
            # S22 mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            my $word = shift @words;
            $m{$section}  = $word;
            %ms{$section} = $word;
        }
        when 'description' {
            # S22 mandatory
            die "FATAL: Too few words ($nw) for section '$section'." if $nw < 1;
            my $word = join ' ', @words;
            $m{$section}  = $word;
            %ms{$section} = $word;
        }
        when 'perl' {
            # S22 mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            my $word;
            if $nw {
                $word = shift @words;
            }
            else {
                $word = '6'; # default
            }
            $m{$section}  = $word;
            %ms{$section} = $word;
        }
        when 'version' {
            # S22 mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            my $word;
            if $nw {
                $word = shift @words;
            }
            else {
                $word = '0.0.0'; # default
            }
            $m{$section}  = $word;
            %ms{$section} = $word;
        }
        when 'license' {
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            my $word;
            if $nw {
                $word = shift @words;
            }
            else {
                $word = 'Artistic-2.0'; # default
            }
            $m{$section}  = $word;
            %ms{$section} = $word;
        }
        when 'gitrepo' {
            # mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            die "FATAL: Too few words ($nw) for section '$section'." if $nw < 1;
        }
        when 'gitauthor' {
            # mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            die "FATAL: Too few words ($nw) for section '$section'." if $nw < 1;
        }
        when 'authors' {
            # mandatory
            my $word = join ' ', @words;
            $m{$section}  = $word;
            %ms{$section}.append: $word;
        }
        when 'provides' {
        }
        when 'test-depends' {
            my $word;
            if $nw {
                $word = shift @words;
            }
            else {
                $word = 'Test::Meta'; # default
            }
            $m{$section}  = $word;
            %ms{$section}.append: $word;
        }
        when 'build-depends' {
        }
        when 'depends' {
        }
        when 'tags' {
        }
        when 'auth' {
        }


        default { die "FATAL: Unhandled section '$section' in file '$mfil'."; }
    }
} # handle-section

sub init-sections(META6 $m) {
    if not $<source-url> {
        $m<source-url> = '';
    }
    if not $<support><source> {
        $m<support><source> = '';
    }
    if not $<tags> {
        $m<tags> = [];
    }
}


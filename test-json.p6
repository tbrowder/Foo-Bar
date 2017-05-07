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
# and save pertinent values in the META6.json file
my $mode = 'init';
# if in mode prep=V, read the .meta.in file,
# save pertinent values in the META6.json file,
# and save the new version number in the
#!appropriate variables

my $mode = 'init';
#$mode = 'prep';
#my $Version = '1.0.0';

if $mode eq 'init' {
    #init-sections $m;
    read-meta-in $m;
    set-version-info $m;
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
sub set-version-info(META6 $m) {
    # use the current or default version to set:
    #   source-url
    #   support { source : source }
    #
}

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

	# mandatory sections
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

	# non-mandatory
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
            %os{$section} = $word;
        }
        when 'gitrepo' {
            # mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            die "FATAL: Too few words ($nw) for section '$section'." if $nw < 1;
            my $word = shift @words;
            #$m{$section}  = $word; # need to handle another way
            %us{$section} = $word;
        }
        when 'gitauthor' {
            # mandatory
            die "FATAL: Too many words ($nw) for section '$section'." if $nw > 1;
            die "FATAL: Too few words ($nw) for section '$section'." if $nw < 1;
            my $word = shift @words;
            #$m{$section}  = $word; # need to handle another way
            %us{$section} = $word;
        }
        when 'authors' {
            # need to ensure no dups
            # the first time this appears, zero out the list
            if not %os{$section} {
                $m{$section} = [];
            }
            my $word = join ' ', @words;
            $m{$section}.append: $word;
            %os{$section} = $word;
        }

        when 'provides' {
            if $nw != 2 {
                say "WARNING:  Need two words, not $nw, for section '$section'.";
                next;
            }
            my $obj = shift @words;
            my $src = shift @words;
            $m{$section}{$obj} = $src;
            %os{$section} = $obj;
        }

        when 'auth' {
            # if no value, check env var PERL6_META6_AUTH
            if !$nw {
                if %*ENV<PERL6_META6_AUTH>:exists {
                    my $word = %*ENV<PERL6_META6_AUTH>;
                    $m{$section} = $word;
                    %os{$section} = 1;
                }
                else {
                    say "WARNING:  Need one word for section '$section'.";
                }
            }
            elsif $nw != 1 {
                say "WARNING:  Need one word, not $nw, for section '$section'.";
            }
            else {
                my $word = shift @words;
                $m{$section} = $word;
                %os{$section} = 1;
            }
        }
        when 'supersedes' {
        }
        when 'superseded-by' {
        }

	when %sl{$section}:exists { 
            #say "section $section is a list";
            # need to ensure no dups
            # the first time this appears, zero out the list
            if not %os{$section} {
                $m{$section} = [];
            }

            if !$nw {
                if $section eq 'test-depends' {
                    my $word = 'Test::Meta'; # default
                    $m{$section}.append: $word;
                    %os{$section} = 1;
                }
                else {
                    say "WARNING:  Need one or more words for section '$section'.";
                }
                next;
            }

            $m{$section}.append($_) for @words;
            %os{$section} = 1;
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

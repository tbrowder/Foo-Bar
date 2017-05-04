unit module META-VARS;

# S22 mandatory sections
our %ms is export = [ 
           name => '', 
           description => '',
           perl => '',
           version => '',
         ];
# my mandatory sections
our %us is export = [ 
           gitrepo => '', 
           gitauthor => '', 
         ];
# support sections
our %ss is export = [ 
           email => '', 
           license => '', # URL 
           mailinglist => '', 
           bugtracker => '', 
           source => '', 
           irc => '', 
           phone => '', 
         ];
# other sections
our %os is export = [ 
           meta6 => '', 
           authors => '', 
           provides => '', 
           depends => '', 
           emulates => '', 
           supersedes => '', 
           superseded-by => '', 
           excludes => '', 
           build-depends => '', 
           test-depends => '', 
           resources => '', 
           support => '', # a hash of key pairs with defined keys 
           license => '', 
           tags => '', 
           production => '', 
         ];

sub isa-meta-section($sect --> Bool) is export {
    if %os{$sect}:exists or %ms{$sect}:exists or %ss{$sect}:exists or %us{$sect}:exists {
        return True;
    }
    else {
        return False;
    }
}

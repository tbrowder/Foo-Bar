unit module META-VARS;

# S22 mandatory attributes
our %ma is export = [ 
           name => '', 
           description => '',
           perl => '',
           version => '',
         ];
# my mandatory attributes
# support attributes
our %sa is export = [ 
           email => '', 
           license => '', # URL 
           mailinglist => '', 
           bugtracker => '', 
           source => '', 
           irc => '', 
           phone => '', 
         ];
# other attributes
our %oa is export = [ 
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

sub isa-meta-section($sect) is export {
    return %oa{$sect}:exists or %ma{$sect}:exists or %sa{$sect}:exists;
}

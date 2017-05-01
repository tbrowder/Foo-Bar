unit module Foo::Bar;

sub foo($word = 'bar') is export(:foo) {
    say $word;
    return $word;
}

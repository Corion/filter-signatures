#!perl -w
use strict;
use Test::More tests => 3;
use Data::Dumper;

use Filter::signatures;
use feature 'signatures';

# Anonymous
my $sub = sub ($name, $value) {
        return "'$name' is '$value'"
    };

SKIP: {
    is ref $sub, 'CODE', "we can compile a simple anonymous subroutine"
        or skip 1, $@;
    is $sub->("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works";
}

# Named
sub foo ($name, $value) {
        return "'$name' is '$value'"
};

SKIP: {
    is foo("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works (named)";
}

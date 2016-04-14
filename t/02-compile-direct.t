#!perl -w
use strict;
use Test::More tests => 2;
use Data::Dumper;

use Filter::signatures;
use feature 'signatures';
my $sub = sub ($name, $value) {
        return "'$name' is '$value'"
    };

SKIP: {
    is ref $sub, 'CODE', "we can compile a simple subroutine"
        or skip 1, $@;
    is $sub->("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works";
}

#!perl -w
use strict;
use Test::More tests => 8;
use Data::Dumper;

require Filter::signatures;

sub identical_to_native {
    my( $name, $expected,$decl ) = @_;
    local $_ = $decl;
    my $org;
    if( $^V >= 5.020 ) {
        $org = eval $_
            or die $@;
    };
    Filter::signatures::transform_arguments();
    my $l = eval $_;
    my $got = $l->('foo','bar');
    my $native = $org ? $org->('foo','bar') : $expected;
    is $got, $expected, $name
        or do { diag $decl; diag $_ };
    is $expected, $native, "Sanity check vs native code";
}

identical_to_native( "Anonymous subroutine", 5, <<'SUB' );
use feature 'signatures';
#line 1
sub (
$name
    , $value
    ) {
        return __LINE__
    };
SUB

identical_to_native( "Anonymous subroutine (traditional)", 2, <<'SUB' );
use feature 'signatures';
#line 1
sub ($name, $value) {
    return __LINE__
};
SUB

identical_to_native( "Named subroutine", 6, <<'SUB' );
use feature 'signatures';
#line 1
sub foo
(
  $name
, $value
) {
        return __LINE__
};
\&foo
SUB

identical_to_native( "Multiline default assignments", 6, <<'SUB' );
use feature 'signatures';
#line 1
sub (
$name
    , $value
='bar'
    ) {
        return __LINE__
    };
SUB

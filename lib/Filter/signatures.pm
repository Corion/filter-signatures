package Filter::signatures;
use strict;
use Filter::Simple;

use vars '$VERSION';
$VERSION = '0.01';

=head1 NAME

Filter::signatures - very simplicistic signatures for Perl < 5.20

=head1 SYNOPSIS

    use Filter::signatures;
    use feature 'signatures'; # this now works on <5.16 as well
    
    sub hello( $name ) {
        print "Hello $name\n";
    }
    
    hello("World");

=head1 CAVEATS

This implements a very simplicistic transform to allow for using very
simplicistic named formal arguments in subroutine declarations. This module
does not implement warning if more parameters than expected are passed in.

Note that this module inherits all the bugs of L<Filter::Simple> and potentially
adds some of its own. Most notable is that Filter::Simple sometimes will
misinterpret the division operator C<< / >> as a leading character to starting
a regex match:

    my $wait_time = $needed / $supply;

This will manifest itself through syntax errors appearing where everything
seems in order. The hotfix is to add a comment to the code that "closes"
the misinterpreted regular expression:

    my $wait_time = $needed / $supply; # / for Filter::Simple

A better hotfix is to upgrade to Perl 5.20 or higher and use the native
signatures support there. No other code change is needed, as this module will
disable its functionality when it is run on a Perl supporting signatures.

=cut

if( $] <= 5.020 ) {
FILTER_ONLY
    code => sub {
        # THis should also support
        # sub foo($x,$y,@) { ... }, throwing away additional arguments
        #s!\bsub\s*(\w+)\s*(\([^)]*?\))\s*{\s*$!my $r= "sub $1 { my $2=\@_;";print "[[$r]]\n";$r!mge;
        s!\bsub\s*(\w+)\s*(\([^)]*?\@?\))\s*{\s*$!sub $1 { my $2=\@_;!mg;
    },
    executable => sub {
            s!^(use\s+feature\s*(['"])signatures\2);!#$1!mg;
    },
    ;
}

1;

=head1 SEE ALSO

L<perlsub/Signatures>

L<signatures> - a module that doesn't use a source filter but optree
modification instead

L<Sub::Signatures>

=head1 REPOSITORY

The public repository of this module is 
L<http://github.com/Corion/filter-signatures>.

=head1 SUPPORT

The public support forum of this module is
L<https://perlmonks.org/>.

=head1 BUG TRACKER

Please report bugs in this module via the RT CPAN bug queue at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Filter-signatures>
or via mail to L<filter-signatures-Bugs@rt.cpan.org>.

=head1 AUTHOR

Max Maischein C<corion@cpan.org>

=head1 COPYRIGHT (c)

Copyright 2015-2016 by Max Maischein C<corion@cpan.org>.

=head1 LICENSE

This module is released under the same terms as Perl itself.

=cut

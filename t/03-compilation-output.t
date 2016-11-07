#!perl -w
use strict;
use Test::More tests => 3;
use Data::Dumper;

require Filter::signatures;

# Anonymous
$_ = <<'SUB';
sub ($name, $value) {
        return "'$name' is '$value'"
    };
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Anonymous subroutines get converted";
sub  { my ($name,$value)=@_;
        return "'$name' is '$value'"
    };
RESULT

$_ = <<'SUB';
sub foo5 () {
        return "We can call a sub without parameters"
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Parameterless subroutines don't get converted";
sub foo5 () {
        return "We can call a sub without parameters"
};
RESULT

# Function default parameters
$_ = <<'SUB';
sub mylog($msg, $when=time) {
    print "[$when] $msg\n";
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Function default parameters get converted";
sub mylog { my ($msg,$when)=@_;$when=time if @_ <= 1;
    print "[$when] $msg\n";
};
RESULT

done_testing;
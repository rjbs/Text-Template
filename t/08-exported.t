#!perl
#
# test apparatus for Text::Template module
# still incomplete.

use lib '../blib/lib';
use Text::Template 'fill_in_file', 'fill_in_string';

die "This is the test program for Text::Template version 1.23.
You are using version $Text::Template::VERSION instead.
That does not make sense.\n
Aborting"
  unless $Text::Template::VERSION == 1.23;

print "1..4\n";

$n=1;
$Q::n = $Q::n = 119; 

# (1) Test fill_in_string
$out = fill_in_string('The value of $n is {$n}.', PACKAGE => 'Q' );
print +($out eq 'The value of $n is 119.' ? '' : 'not '), "ok $n\n";
$n++;

# (2) Test fill_in_file
$TEMPFILE = "/tmp/tt$$";
open F, "> $TEMPFILE" or die "Couldn't open test file: $!; aborting";
print F 'The value of $n is {$n}.', "\n";
close F or die "Couldn't write test file: $!; aborting";
$R::n = $R::n = 8128; 

$out = fill_in_file($TEMPFILE, PACKAGE => 'R');
print +($out eq "The value of \$n is 8128.\n" ? '' : 'not '), "ok $n\n";
$n++;

# (3) Jonathan Roy reported this bug:
open F, "> $TEMPFILE" or die "Couldn't open test file: $!; aborting";
print F "With a message here? [% \$var %]\n";
close F  or die "Couldn't close test file: $!; aborting";
$out = fill_in_file($TEMPFILE, DELIMITERS => ['[%', '%]'],
		    HASH => { "var" => \"It is good!" });
print +($out eq "With a message here? It is good!\n" ? '' : 'not '), "ok $n\n";
$n++;

# (4) It probably occurs in fill_this_in also:
$out = 
  Text::Template->fill_this_in("With a message here? [% \$var %]\n",
                      DELIMITERS => ['[%', '%]'],
                      HASH => { "var" => \"It is good!" });
print +($out eq "With a message here? It is good!\n" ? '' : 'not '), "ok $n\n";
$n++;



END { $TEMPFILE && unlink $TEMPFILE }

exit;


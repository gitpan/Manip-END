use strict;

use Manip::END;

my $obj = Manip::END->get_ref();

print "1..3\n";

ok(@$obj == 1, 1, "correct size");

$obj->unshift(bless(\&end, "good"));
$obj->unshift(bless(\&bad_end, "bad"));

$obj->remove_isa("bad");

sub end
{
	ok(1, 2, "in my sub");
}

sub bad_end
{
	ok(0, 4, "in bad sub");
}

END {
	ok(1, 3, "in end");
}

sub ok
{
	my ($ok, $num, $msg) = @_;

	$msg ||= "";

	print $ok ? "" : "not ";
	print "ok $num - $msg\n"
}

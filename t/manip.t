use strict;

use Test::More tests => 1;

BEGIN { use_ok("Manip::END") };

Manip::END::clear_end_array();

END {
	fail("in end");
}

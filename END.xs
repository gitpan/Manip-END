#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "perlapi.h"

AV *get_end_array()
{
	if (!PL_endav)
	{
		PL_endav = newAV();
	}

	return PL_endav;
}

MODULE = Manip::END		PACKAGE = Manip::END

AV *
get_end_array()

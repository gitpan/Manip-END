#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "perlapi.h"

void clear_end_array()
{
	if (PL_endav)
	{
		av_clear(PL_endav);
	}
}

#if 0
/* causing segfaults... */
AV *get_end_array()
{
	if (!PL_endav)
	{
		PL_endav = newAv();
	}

	printf("pl = %p\n", PL_endav);
	return PL_endav;
}
#endif
MODULE = Manip::END		PACKAGE = Manip::END

void
clear_end_array()


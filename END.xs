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

char *get_pkg(int index)
{
	SV **elem;
	CV *code;
	svtype type;
	HV *stash;

	if (
		(index < 0) ||
		(index > av_len(PL_endav))
	)
	{
		croak("%d is not a valid index for END array", index);
	}

	elem = av_fetch(PL_endav, index, 0);

	code = (CV *) *elem;

	switch (SvTYPE(code))
	{
		case SVt_RV:
			code = (CV *) SvRV(code);
			break;
		case SVt_PVCV:
			code = (CV *) code;
			break;
		default:
			croak("I don't know how to handle type %d variables, index=%d", SvTYPE(code), index);
	}

	stash = CvSTASH(code);

	return HvNAME(stash);
}

MODULE = Manip::END		PACKAGE = Manip::END

AV *
get_end_array()

char *
get_pkg(index)
	int index

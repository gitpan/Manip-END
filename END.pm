use strict;
use warnings;

package Manip::END;

our $VERSION = '0.02';

require Exporter;
our @EXPORT_OK = qw(
	clear_end_array
	set_end_array
);

our @ISA = qw(Exporter);

require XSLoader;
XSLoader::load('Manip::END', $Manip::END::VERSION);

my $self = bless get_end_array(), __PACKAGE__;

sub set_end_array
{
	_check(@_);
	@$self = @_;
}

sub clear_end_array
{
	@$self = ();
}

sub ref
{
	return $self;
}

sub clear
{
	@$self = ();
}

sub push
{
	shift;
	_check(@_);
	push(@$self, @_);
} 

sub unshift
{
	shift;
	_check(@_);
	unshift(@$self, @_);
} 

sub _check
{
	if (grep {! UNIVERSAL::isa($_, "CODE") } @_)
	{
		die "END blocks must be CODE references";
	}
}

1;

__END__

=head1 NAME

Manip::END - Mess around with END blocks

=head1 SYNOPSIS

  use Manip::END qw( clear_end_array set_end_array );

  clear_end_array();

	set_end_array(sub {...}, sub {...});

=head1 DESCRIPTION

Perl keeps an array of subroutines that should be run just before your
program exits (see perlmod manpage for more details). This module allows you
to manipulte this array.

=head1 HOW TO USE IT

=head2 EXPORTED FUNCTIONS

C<clear_end_array()>

This will clear the array of END blocks.

C<set_end_array(@blocks)>

@blocks is an array of subroutine references. This will set the array of END
blocks.

=head2 CLASS METHODS

C<ref()>

This will return a blessed reference to the array of END blocks which you
can manipulate yourself. You can also invoke several methods on this array
reference.

B<NOTE!!!!>The array contains an C<undef> for each END blcok that has been
encountered, it's not really an undef though, it some sort of raw coderef
that's not wrapped in a scalar ref. This leads to fun error messages like

  Bizarre copy of CODE in sassign

when you try to assign one of these values to another variable. This makes
manipulating the array a littel delicate if you want to preserve these
values.

That said, you can erase them without any problem and you can add your own
coderefs without any problem too.

=head2 OBJECT METHODS

C<$obj-E<gt>unshift(@blocks)>

@blocks is an array of references to code blocks. This will add the blocks
to the start of the array. By adding to the start of the array, they will be
the first code blocks executed by Perl when it is exiting

C<$obj-E<gt>push(@blocks)>

@blocks is an array of references to code blocks. This will add the blocks
to the end of the array. By adding to the end of the array, they will be
the last code blocks executed by Perl when it is exiting

C<$obj-E<gt>clear()>

This clears the array.

=head1 AUTHOR

Written by Fergal Daly <fergal@esatclear.ie>. Suggested by Mark Jason
Dominus at his talk in Dublin.

=head1 LICENSE

Copyright 2003 by Fergal Daly E<lt>fergal@esatclear.ieE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://www.perl.com/perl/misc/Artistic.html>

=cut

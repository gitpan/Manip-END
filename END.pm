use strict;
use warnings;

package Manip::END;

our $VERSION = '0.03';

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

sub get_ref
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

sub filter_sub
{
	shift;
	my $sub = shift;

	my $max = $#$self;	

	for (my $i = 0; $i <= $max; $i++)
	{
		if (! &$sub($self->[$i]))
		{
			splice(@$self, $i, 1);
			$max--;
		}
	}
}

sub remove_class
{
	shift;

	my $class = shift;

	$self->filter_sub(sub { ref($_[0]) ne $class } );
}

sub remove_isa
{
	shift;

	my $class = shift;

	$self->filter_sub(sub { ! UNIVERSAL::isa($_[0], $class) } );
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

  $ar = Manip::END->get_ref;
  $ar->unshift(sub {...}, sub {...});

=head1 DESCRIPTION

Perl keeps an array of subroutines that should be run just before your
program exits (see perlmod manpage for more details). This module allows you
to manipulte this array.

=head1 WARNING

This module gives you access to one of Perl's internal arrays that you're
not supposed to see so there are a couple of funny things going on.

The array contains an C<undef> for each END blcok that has been encountered,
it's not really an C<undef> though, it's some sort of raw coderef that's not
wrapped in a scalar ref. This leads to fun error messages like

  Bizarre copy of CODE in sassign

when you try to assign one of these values to another variable. This can
make manipulating the array a little delicate if you want to preserve these
values.

That said, you can erase them without any problem and you can add your own
coderefs without any problem too. If you want to selectively remove items
from the array, that's where the fun begins. You cannot do

	@$ref = grep {...} @$ref

if any of the C<undef> coderefs will survive the grep as they will cause an
error such as the one above. It's probably best to use the provided filter
methods.

=head1 HOW TO USE IT

=head2 EXPORTED FUNCTIONS

C<clear_end_array()>

This will clear the array of END blocks.

C<set_end_array(@blocks)>

@blocks is an array of subroutine references. This will set the array of END
blocks.

=head2 CLASS METHODS

C<Manip::END-E<gt>get_ref()>

This will return a blessed reference to the array of END blocks which you
can manipulate yourself. You can also invoke several methods on this array
reference.

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

C<$obj-E<gt>filter_sub($code)>

$code is a reference to a subroutine. For each element of the array, this
will execute the subroutine in $code, passing in the element as the first
argument. If the subroutine returns a true value, the element will be kept.
If it returns false, the element will be removed from the array.

C<$obj-E<gt>remove_isa($class)>

$class is a string containing the name of a class. This removes all of the
elements which inherit from $class.

C<$obj-E<gt>remove_class($class)>

$class is a string containing the name of a class. This removes all of the
elements which are blessed into $class.

=head1 TODO

It would be nice if Perl didn't store those funny undef values but rather
stored real CODE refs.

=head1 AUTHOR

Written by Fergal Daly <fergal@esatclear.ie>. Suggested by Mark Jason
Dominus at his talk in Dublin.

=head1 LICENSE

Copyright 2003 by Fergal Daly E<lt>fergal@esatclear.ieE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://www.perl.com/perl/misc/Artistic.html>

=cut

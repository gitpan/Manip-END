use strict;
use warnings;

package Manip::END;

our $VERSION = '0.01';

require Exporter;
our @EXPORT_OK = qw(
	clear_end_array
);
  
our @ISA = qw(Exporter);

require XSLoader;
XSLoader::load('Manip::END', $Manip::END::VERSION);

1;

__END__

=head1 NAME

Manip::END - Mess around with END blocks

=head1 SYNOPSIS

  use Manip::END qw( clear_end_array );

  clear_end_array();

=head1 DESCRIPTION

Perl keeps an array of subroutines that should be run just before your
program exits (see perlmod manpage for more details). This module allows you
to clear that array.

=head1 HOW TO USE IT

This module can export 1 function, C<clear_end_array()>. When this is
called, the array containing the END blocks is cleared, so no END blocks
will be executed as your program exits.

=head1 AUTHOR

Written by Fergal Daly <fergal@esatclear.ie>. Suggested by Mark Jason
Dominus at his talk in Dublin.

=head1 LICENSE

Copyright 2003 by Fergal Daly E<lt>fergal@esatclear.ieE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://www.perl.com/perl/misc/Artistic.html>

=cut

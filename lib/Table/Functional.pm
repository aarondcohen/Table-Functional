package Table::Functional;

use 5.006;

use strict;

use List::Util ();
use Exporter qw{import};

=head1 NAME

Table::Functional - 2-dimensional arrays for functional programming

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Table::Functional ':all';

		my @calender_1012_04 = tablify {size => 7, dim => 'col', order => 'row'}, (1 .. 30);
		@calender_with_next_month_marked_by_xs = fill 'x', @calender_1012_04;

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=cut

our @EXPORT_OK  = qw{
	tablify
	cols
	rows
	copy
	fill
	transform
	transpose
};
our %EXPORT_TAGS = (all => [@EXPORT_OK]);

=head1 SUBROUTINES/METHODS

=head2 function1

=cut



sub tablify($@) {
	my %args = (
		size  => undef,
		dim   => '', #values: row | col
		order => '', #values: row | col
		%{(shift || {})}
	);

	my $list = \@_;
	my $size = int($args{size} || 0);

	return () unless @$list && $size > 0;

	my $full_dim = int(@$list / $size);
	my $part_dim = @$list % $size;

	my @table = $args{order} eq $args{dim}
		#Apply the best fit algorithm
		? do {
			map {
				my $start = $_ * $full_dim + List::Util::min($part_dim, $_);
				[ @{$list}[$start .. $start + $full_dim + ($_ < $part_dim) - 1] ]
			} (0 .. $size - 1)
		}
		#Apply the fixed dimension algorithm
		: do {
			map {
				my $start = $_ * $size;
				[ @{$list}[$start .. List::Util::min($start + $size, scalar @$list) - 1] ]
			} (0 .. $full_dim + !! $part_dim - 1)
		}
		;

	#Reorient for column order
	return $args{order} eq 'col' ? transpose(@table) : @table;
}

sub rows(@) { scalar @_ }
sub cols(@) { List::Util::max(0, map { scalar @$_ } @_) }

sub copy(@) { map { [@$_] } @_ }

=head2 fill($@)

Given a filler and a table, replace all undef

=cut

sub fill($@) {
	my $filler = shift;
	my $row=-1;
	my $col=-1;

	my @dummies;
	$#dummies = (cols @_) - 1;

	return map {
		++$row;
		$col = -1;
		[ map {
			++$col;
			defined $_ ? $_ :
			ref $filler eq "CODE" ? $filler->($row, $col) :
				$filler
		} (@$_, @dummies[0 .. @dummies - @$_ - 1])]
	} @_;
}

=head2 redact($@)


=cut

sub redact($@) {
	my $redacter = shift;
	my $row=-1;
	my $col=-1;

	my @dummies;
	$#dummies = (cols @_) - 1;

	return map {
		++$row;
		$col = -1;
		[ map {
			++$col;

			! defined $_ ? undef :
			ref $filler eq "CODE" ? $redacter->($row, $col, $_) :
			$redacter eq $_ ? undef :
				$_
		} (@$_, @dummies[0 .. @dummies - @$_ - 1])]
	} @_;
}

=head2 transform($$;@)

Given an array of row indices, an array of column indices, and a table, create a new table with a copy of the data in the specified cells.  If undef is supplied for either the rows or the columns, then all the entries in that dimension are selected.

Example usage:

  #Create a blank 3x4 table
	@three_by_four = transform [0 .. 2], [0 .. 3]

  #Reorder the cells
	@first_and_second_row_and_column_swapped = transform [1,0,1], [1,0,2,3], @other_table

  #Select the first row
	@first_row_only = transform [0], undef, @other_table

=cut

sub transform($$;@) {
	my $rows = shift;
	my $cols = shift;
	$rows ||= [0 .. (rows @_) - 1];
	$cols ||= [0 .. (cols @_) - 1];

	return () unless @$rows && @$cols;
	return map { [@{$_}[@$cols]] } @_[@$rows];
}

=head2 transpose(@)

Given a table, swap its rows and columns.

Example usage:

  @columns_of_rows = transpose @rows_of_columns

=cut

sub transpose(@) {
	my $rows = rows @_;
	my $cols = cols @_;
	map { my $c=$_;
			[map { my $r=$_;
				exists $_[$r][$c] ? $_[$r][$c] : ()
			} 0 .. $rows - 1]
	} 0 .. $cols - 1;
}

=head1 AUTHOR

Aaron Cohen, C<< <aarondcohen at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-table-util at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Table-Util>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Table::Functional


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Table-Util>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Table-Util>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Table-Util>

=item * Search CPAN

L<http://search.cpan.org/dist/Table-Util/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Aaron Cohen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Table::Functional

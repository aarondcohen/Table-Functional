#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Table::Functional' ) || print "Bail out!\n";
}

diag( "Testing Table::Functional $Table::Functional::VERSION, Perl $], $^X" );

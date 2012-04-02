use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Table::Functional',
    AUTHOR              => q{Aaron Cohen <aarondcohen@gmail.com>},
    VERSION_FROM        => 'lib/Table/Functional.pm',
    ABSTRACT_FROM       => 'lib/Table/Functional.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Table-Functional-*' },
);

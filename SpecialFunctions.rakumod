use v6;
use NativeCall;

unit module SpecialFunctions;

# Import functions from the GNU Scientific Library
my sub gsl_sf_gamma(num64 $x --> num64) is native("gsl") { * }
my sub gsl_sf_erf(num64 $x --> num64) is native("gsl") { * }
my sub gsl_sf_hyperg_2F1(num64 $a, num64 $b, num64 $c, num64 $x --> num64) is native("gsl") { * }

# Declare wrapper functions to coerce arguments to needed types
sub erf(Numeric:D $x --> Numeric:D) is export {
    return gsl_sf_erf($x.Num);
}

sub gamma(Numeric:D $x --> Numeric:D) is export {
    return gsl_sf_gamma($x.Num);
}

sub hypergeom_2F1(
    Numeric:D $a,
    Numeric:D $b,
    Numeric:D $c,
    Numeric:D $x --> Numeric:D
) is export
{
    return gsl_sf_hyperg_2F1($a.Num, $b.Num, $c.Num, $x.Num);
}

use v6;

unit module HypothesisTesting::ztest;

use DistributionFunctions::normal;


multi sub z-test(
    Int:D $x-count!,
    Int:D $x-obs!,
    Numeric:D :$mu!,
    Str:D :$alt = "two-sided",
    Bool:D :$do-print = False --> Positional:D) is export
{
    unless 0 <= $mu <= 1 {
        die "\$mu must be a value from 0 to 1, not $mu";
    }

    my Numeric $p = $x-count / $x-obs;
    my Numeric $z = sqrt($x-obs) * ($p - $mu) / sqrt($p * (1 - $p));
    my Numeric $p-value;

    given $alt {
        when "two-sided" { $p-value = 2 * norm-cdf -abs($z); }
        when "less"      { $p-value = norm-cdf -$z; }
        when "greater"   { $p-value = norm-cdf $z; }
        default {
            die "Argument \$alt must be one of: 'two-sided', 'less', 'greater',
not $alt";
        }
    }

    if $do-print {
        say sprintf(
            "One sample z-test\n
null hypothesis: p = %.4f
 alt hypothesis: $alt\n
      z = %9.6f
p-value = %9.6f",
            $mu,
            $z,
            $p-value
        );
    }

    return $z, $p-value;
}

multi sub z-test(
    Int:D $x-count!,
    Int:D $x-obs!,
    Int:D $y-count!,
    Int:D $y-obs!,
    Str:D :$alt = "two-sided",
    Bool:D :$do-print = False --> Positional:D) is export
{
    my Numeric $p-x = $x-count / $x-obs;
    my Numeric $p-y = $y-count / $y-obs;
    my Numeric $p = ($x-count + $y-count) / ($x-obs + $y-obs);
    my Numeric $variance = $p * (1 - $p);
    my Numeric $z = ($p-x - $p-y) / sqrt($variance * (1 / $x-obs + 1 / $y-obs));
    my Numeric $p-value;

    given $alt {
        when "two-sided" { $p-value = 2 * norm-cdf -abs($z); }
        when "less"      { $p-value = norm-cdf -$z; }
        when "greater"   { $p-value = norm-cdf $z; }
        default {
            die "Argument \$alt must be one of: 'two-sided', 'less', 'greater',
not '$alt'";
        }
    }

    if $do-print {
        say sprintf(
            "Two sample z-test\n
null hypothesis: %.4f = %.4f
 alt hypothesis: $alt\n
      z = %9.6f
p-value = %9.6f",
            $p-x,
            $p-y,
            $z,
            $p-value
        );
    }

    return $z, $p-value;
}

multi sub z-test(
    @x!,
    Numeric:D :$mu!,
    Str:D :$alt = "two-sided",
    Bool:D :$do-print = False --> Positional:D) is export
{
    unless all map { $_ == 0 || $_ == 1 }, @x {
        die "\@x must only contain zeroes and ones";
    }

    unless 0 <= $mu <= 1 {
        die "\$mu must be a value from 0 to 1, not $mu";
    }

    return z-test(
        sum(@x),
        @x.elems,
        :mu($mu),
        :alt($alt),
        :do-print($do-print)
    );
}

multi sub z-test(
    @x!,
    @y!,
    Str:D :$alt = "two-sided",
    Bool:D :$do-print = False --> Positional:D) is export
{
    unless all map { $_ == 0 || $_ == 1 }, @x {
        die "\@x must only contain zeroes and ones";
    }

    unless all map { $_ == 0 || $_ == 1 }, @x {
        die "\@y must only contain zeroes and ones";
    }

    return z-test(
        sum(@x),
        @x.elems,
        sum(@y),
        @y.elems,
        :alt($alt),
        :do-print($do-print)
    );
}

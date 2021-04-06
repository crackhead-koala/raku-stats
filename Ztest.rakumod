use v6;
use TestUtils;
use Normal;

unit module HypothesisTesting::ztest;


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
            die "Argument \$alt must be one of: 'two-sided', 'less', 'greater', not $alt";
        }
    }

    if $do-print {
        say format-test-results(
            "One sample z-test",
            sprintf("p = %.2f", $p),
            $alt,
            "z",
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
            die "Argument \$alt must be one of: 'two-sided', 'less', 'greater', not '$alt'";
        }
    }

    if $do-print {
        say format-test-results(
            "Two sample z-test",
            "p_x - p_y = 0",
            $alt,
            "z",
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

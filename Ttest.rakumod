use v6;
use TestUtils;
use BasicStatFunctions;
use T;

sub t-test(
    @x!,
    Numeric:D :$mu!,
    Str:D :$alt = "two-sided",
    Bool:D :$do-print = False --> Positional:D
) is export
{
    my Numeric $df = @x.elems - 1;
    my Numeric $mean = mean @x;
    my Numeric $sd = sd(@x) / sqrt($df + 1);

    my Numeric $t = ($mean - $mu) / $sd;
    my Numeric $p-value;

    given $alt {
        when "two-sided" { $p-value = 2 * t-cdf(-abs($t), $df); }
        when "less"      { $p-value = t-cdf(-$t, $df); }
        when "greater"   { $p-value = t-cdf($t, $df); }
        default {
            die "Argument \$alt must be one of: 'two-sided', 'less', 'greater', not $alt";
        }
    }

    if $do-print {
        print format-test-results(
            "One sample t-test",
            "mean of x = $mu",
            $alt,
            "t",
            $t,
            $p-value
        );
    }

    return $t, $p-value;
}

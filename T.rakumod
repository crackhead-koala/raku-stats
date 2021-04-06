use v6;
use SpecialFunctions;
use Normal;

sub t-pdf(Numeric:D $x!, Int:D $df! --> Numeric:D) is export {
    return norm-pdf($x) if $df > 30;
    if $df == 1 {
        return 1 / (pi * (1 + $x ** 2));
    } elsif $df == 2 {
        return (2 * sqrt(2) * (1 + 0.5 * $x ** 2)) ** (-3/2);
    } elsif $df == 3 {
        return 2 / (pi * sqrt(3) * (1 + ($x ** 2) / 3) ** 2);
    } elsif $df == 4 {
        return 3/8 * (1 + 0.25 * $x ** 2) ** (-5/2);
    } elsif $df == 5 {
        return 8 / (3 * pi * sqrt 5) * (1 + 0.2 * $x ** 2) ** (-3);
    }
    return (gamma 0.5 * ($df + 1)) / (sqrt($df * pi) * gamma 0.5 * $df)
         * (1 + $x * $x / $df) ** (-0.5 * ($df + 1));
}

sub t-cdf(Numeric:D $x!, Int:D $df! --> Numeric:D) is export {
    return norm-cdf($x) if $df > 30;
    if $df == 1 {
        return 0.5 + 1/pi * atan $x;
    } elsif $df == 2 {
        return 0.5 + $x / (2 * sqrt(2) * sqrt(1 + 0.5 * $x ** 2));
    } elsif $df == 3 {
        return 0.5 + 1/pi * (1/sqrt(3)
             * $x / (1 + ($x ** 2) / 3) + atan($x/sqrt(3)));
    } elsif $df == 4 {
        return 0.5 + 3/8 * $x / sqrt(1 + 0.25 * $x ** 2)
             * (1 - 1/12 * ($x ** 2) / (1 + 0.25 * $x ** 2));
    } elsif $df == 5 {
        return 0.5 + 1/pi * (($x / (1 + 0.2 * $x ** 2) / sqrt 5)
                          * (1 + 2/3 / (1 + 0.2 * $x ** 2)) + atan($x/sqrt 5));
    }
    return 0.5 + $x * gamma 0.5 * ($df + 1)
         * (hypergeom_2F1(0.5, 0.5 * ($df + 1), 1.5, -$x * $x / $df))
         / (sqrt($df * pi) * gamma 0.5 * $df);
}

sub t-quant(Numeric:D $x!, Int:D $df! --> Numeric:D) is export {
    die "This function has not been implemented yet... ಥ_ಥ";
}

sub t-rand(Int:D $n!, Int:D $df! --> Positional:D) is export {
    die "This function has not been implemented yet... ಥ_ಥ";
}

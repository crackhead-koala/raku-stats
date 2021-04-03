use v6;

unit module DistributionFunctions::Normal;


my sub factorial(Int:D $n --> Int:D) {
    return 1 if $n == 0;
    return [*] 1..$n;
}

my sub double-factorial(Int:D $n --> Int:D) {
    return 1 if $n == 0;
    if $n %% 2 {
        return [*] 2, 4 ... $n;
    } else {
        return [*] 1, 3 ... (ceiling($n) - 1);
    }
}


sub norm-pdf(Numeric:D $x, $mean=0, $sd=1 --> Numeric:D) is export {
    my Numeric $z = ($x - $mean) / $sd;
    return exp(-0.5 * $z**2) / ($sd * sqrt(2 * pi));
}


# [https://www.hindawi.com/journals/mpe/2012/124029/]
sub norm-cdf(
    Numeric:D $x,
    Numeric:D $mean = 0,
    Numeric:D $sd = 1 --> Numeric:D
) is export
{
    my Numeric $z = ($x - $mean) / $sd;
    return 0.5 * tanh(39/2 * $z / sqrt(2 * pi) - 111/2
               * atan(35/111 * $z / sqrt(2 * pi))) + 0.5;
}


# [Voutier, 2010]
sub norm-quant(
    Numeric:D $p,
    Numeric:D $mean = 0,
    Numeric:D $sd = 1 --> Numeric:D
) is export
{
    if 0 <= $p < 0.0465 {
        return $mean + $sd * tail($p);
    } elsif 0.0465 <= $p <= 0.9535 {
        return $mean + $sd * central($p);
    } elsif 0.9535 < $p <= 1 {
        return $mean - $sd * tail(1 - $p);
    }

    sub tail(Numeric:D $p --> Numeric:D) {
        my @c = (16.896201479841517652, -2.793522347562718412,
                 -8.731478129786263127, -1.000182518730158122);
        my @d = ( 7.173787663925508066,  8.759693508958633869);
        my Numeric $r = sqrt( log(1 / ($p ** 2)) );

        return (@c[3] * ($r ** 3)
              + @c[2] * ($r ** 2)
              + @c[1] * $r + @c[0])
              / ($r ** 2 + @d[1] * $r + @d[0]);
    }

    sub central(Numeric:D $p --> Numeric:D) {
        my @a = (0.389422403767615, -1.699385796345221, 1.246899760652504);
        my @b = (0.155331081623168, -0.839293158122257);
        my Numeric $q = $p - 0.5;
        my Numeric $r = $q ** 2;

        return $q * (@a[2] * ($r ** 2) + @a[1] * $r + @a[0])
                  / ($r ** 2 + @b[1] * $r + @b[0]);
    }
}

sub norm-rand(
    Int:D $n,
    Numeric:D $mean = 0,
    Numeric:D $sd = 1 --> Numeric:D
) is export
{
    pass;
}

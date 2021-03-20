use v6;

# Error function polynomial approximation
# (maximum error of 1.2e-7, which is pretty big... can do 6e-19 with [Cody, 1969])
sub erf($x) {
    return 0 if $x == 0;
    my $t = 1 / (1 + 0.5 * abs($x));
    my $theta = $t * exp( -$x ** 2 - 1.26551223             + 1.00002368 * $t
                                   + 0.37409196 * ($t ** 2) + 0.09678418 * ($t ** 3)
                                   - 0.18628806 * ($t ** 4) + 0.27886807 * ($t ** 5)
                                   - 1.13520398 * ($t ** 6) + 1.48851587 * ($t ** 7)
                                   - 0.82215223 * ($t ** 8) + 0.17087277 * ($t ** 9) );
    return $x > 0 ?? 1 - $theta !! $theta - 1;
}

sub factorial($n) { return [*] 1..$n; }

# [Chen, 2016]
sub gamma($x) {
    say $x.WHAT;
    return factorial($x - 1) if $x.isa(Int) && 0 < $x && $x < 100;
    my $a = sqrt(2 * pi * $x);
    my $b = exp($x, $x / e);
    my $c = (1 + 1 / (12 * $x ** 3 + 24/7 * $x -0.5)) ** ($x ** 2 + 53/210);
    return $a * $b * $c / $x;
}

sub pochhammer($x, $m) { return gamma($x + $m) / gamma($x); }

sub hyper2f1() {}

# Normal distribution
sub d-norm($x, $mean = 0, $sd = 1) {
    return 1 / ($sd * sqrt(2 * pi)) * exp(-0.5 * (($x - $mean) / $sd) ** 2);
}

# [Bowling et al., 2009]
sub p-norm($x, $mean = 0, $sd = 1) {
    return 1 / (1 + exp(-0.07056 * (($x - $mean) / $sd) ** 3 - 1.5976 * ($x - $mean) / $sd));
}

# [Voutier, 2010]
sub q-norm($p, $mean = 0, $sd = 1) {
    if 0 <= $p < 0.0465 {
        return $mean + $sd * tail($p);
    } elsif 0.0465 <= $p <= 0.9535 {
        return $mean + $sd * central($p);
    } elsif 0.9535 < $p <= 1 {
        return $mean - $sd * tail(1 - $p);
    }

    sub tail($p) {
        my @c = (16.896201479841517652, -2.793522347562718412,
                 -8.731478129786263127, -1.000182518730158122);
        my @d = ( 7.173787663925508066,  8.759693508958633869);
        my $r = sqrt( log(1 / ($p ** 2)) );

        return (@c[3] * ($r ** 3) + @c[2] * ($r ** 2) + @c[1] * $r + @c[0]) / ($r ** 2 + @d[1] * $r + @d[0]);
    }

    sub central($p) {
        my @a = (0.389422403767615, -1.699385796345221, 1.246899760652504);
        my @b = (0.155331081623168, -0.839293158122257);
        my $q = $p - 0.5;
        my $r = $q ** 2;

        return $q * (@a[2] * ($r ** 2) + @a[1] * $r + @a[0]) / ($r ** 2 + @b[1] * $r + @b[0]);
    }
}

sub r-norm($n, $mean = 0, $sd = 1) {
    return (q-norm(1.rand, $mean, $sd) for ^$n);
}

# Student's t distribution
sub d-t($x, $df) {
    return p-norm($x) if $df > 30;
    return gamma(0.5 * ($df + 1)) / (sqrt($df * pi) * gamma($df / 2)) * (1 + $x ** 2 / $df) ** (-0.5 * ($df + 1));
}

sub p-t($x, $df) {
    return p-norm($x) if $df > 100;

}

sub q-t($p, $df) {}

sub r-t($n, $df) {}
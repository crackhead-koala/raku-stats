use v6;

use Math::Matrix;
use Text::CSV;

sub ols(Str:D $formula, %data) {
    my @params = $formula.split("~");
    my $y = @params[0].trim;
    my @x = @params[1].split("&")>>.trim;

    my $n-obs  = %data{$y}.elems;
    my $n-vars = @x.elems;

    my $y-vec        = Math::Matrix.new( (%data{$y},) ).transposed;
    my $design-mat-t = Math::Matrix.new( (1 xx $n-obs, |(%data{@x})) );
    my $temp-mat     = $design-mat-t.dot-product( $design-mat-t.transposed ).inverted;
    my $coefs        = $temp-mat.dot-product( $design-mat-t.dot-product($y-vec) );

    my $fitted-vals-vec = $design-mat-t.transposed.dot-product($coefs);
    my $resids-vec      = $y-vec.add( $fitted-vals-vec.negated );
    my $y-mean          = sum(%data{$y}) / $n-obs;

    my $total-sum-sq = sum( (($_ - $y-mean) ** 2 for |(%data{$y})) );
    my $expl-sum-sq  = sum( (($_ - $y-mean) ** 2 for $fitted-vals-vec.list) );
    my $resid-sum-sq = sum( ($_ ** 2 for $resids-vec.list) );

    my $reg-err-sq = $resid-sum-sq / ($n-obs - $n-vars - 1);
    my $r-sq       = 1 - $resid-sum-sq / $total-sum-sq;
    my $r-sq-adj   = 1 - $resid-sum-sq / $total-sum-sq * ($n-obs - 1) / ($n-obs - $n-vars - 1);

    my $var-cov-mat = $reg-err-sq * $temp-mat;

    say "Regression model:\n[$y] = a0 + " ~ ("a$_*[@x[$_ - 1]]" for 1..^$n-vars).join(" + "), "\n";

    say "Estimated coefficients:\n" ~ ("a$_ = " ~ $coefs.list[$_].round(0.00001) ~ " (Std. = " ~ $var-cov-mat[$_;$_].sqrt.round(0.00001) ~ ")" for 0..$n-vars).join("\n"), "\n";

    say "Standard error of regression: $reg-err-sq.sqrt.round(0.0001)";
    say "R-squared: $r-sq.round(0.0001), Adj R-squared: $r-sq-adj.round(0.0001)";
}


# Load data and convert it to a hash
my @data = csv(in => "./mtcars.csv");
my %mtcars;

for ^(@data[0].elems) -> $col {
    unless @data[0;$col] eq 'model' {
        %mtcars.push: (@data[0;$col] => ( @data[$_;$col].Numeric for 1..^@data.elems ));
        next;
    }
    %mtcars.push: (@data[0;$col] => ( @data[$_;$col] for 1..^@data.elems ));
}


# TESTS
ols("mpg ~ cyl & disp & hp & wt", %mtcars);

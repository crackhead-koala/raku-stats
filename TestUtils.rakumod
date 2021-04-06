use v6;

unit module TestUtils;

my Str $signif-codes = "[signif. codes: 0 '***' 0.01 '**' 0.05 '*' 0.1 'x' 1]";

sub format-nums(
    Numeric:D $a!,
    Numeric:D $b!,
    Int:D $precision = 4 --> Positional:D) is export
{
    my Str $a-fmt = sprintf("% .{$precision}f", $a);
    my Str $b-fmt = sprintf("% .{$precision}f", $b);

    my Int $pad = abs($a-fmt.chars - $b-fmt.chars);

    if $a-fmt.chars <= $b-fmt.chars {
        $a-fmt = (" " x $pad) ~ $a-fmt;
    } else {
        $b-fmt = (" " x $pad) ~ $a-fmt;
    }

    return $a-fmt, $b-fmt;
}

sub format-test-results(
    Str:D $test-name!,
    Str:D $null-h!,
    Str:D $alt-h!,
    Str:D $statistic-name!,
    Numeric:D $statistic!,
    Numeric:D $p-value!,
    Int:D $precision = 4 --> Str:D) is export
{
    my Str @fmts = format-nums($statistic, $p-value, $precision);
    my Str $stat-fmt = @fmts[0];
    my Str $p-fmt = @fmts[1];

    my Int $pad-stat = 0;
    my Int $pad-p = 0;

    if $statistic-name.chars > 7 {  # 7 chars in "p-value"
        $pad-p = $statistic-name.chars - 7;
    } else {
        $pad-stat = 7 - $statistic-name.chars;
    }

    my Str $sig = "x";
    if $p-value <= 0.01 {
        $sig = "***";
    } elsif 0.01 < $p-value <= 0.05 {
        $sig = "**";
    } elsif 0.05 < $p-value <= 0.1 {
        $sig = "*";
    }

    return "$test-name\n\n"
         ~ "null hypothesis: $null-h\n"
         ~ " alt hypothesis: $alt-h\n\n"
         ~ (" " x $pad-stat) ~ "$statistic-name = $stat-fmt\n"
         ~ (" " x $pad-p) ~ "p-value = $p-fmt ($sig)\n\n"
         ~ $signif-codes;
}

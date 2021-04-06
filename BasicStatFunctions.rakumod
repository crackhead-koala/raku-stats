use v6;

unit module BasicStatFunctions;

sub mean(@x --> Numeric:D) is export {
    return [+] @x / @x.elems;
}

sub variance(@x --> Numeric:D) is export {
    my Numeric $mean = mean @x;
    return [+] (@x.list Z- $mean, *) / (@x.elems - 1);
}

sub variance-pop(@x --> Numeric:D) is export {
    my Numeric $mean = mean @x;
    return [+] (@x.list Z- $mean, *) / @x.elems;
}

sub sd(@x --> Numeric:D) is export {
    return sqrt(variance @x);
}

sub sd-pop(@x --> Numeric:D) is export {
    return sqrt(variance-pop @x);
}

use v6;

class MissingValue {
    method gist( --> Str) {
        return "NA";
    }
}

constant NA = MissingValue.new;


class DataFrame does Positional does Associative {
    has @!_data;
    has @!_col-names;
    has $.n-rows;
    has $.n-cols;

    submethod BUILD(:@data!) {
        @data = self!verify-col-lens(@data);
        $!n-rows = @data[0].value.elems;
        $!n-cols = @data.elems;

        for @data -> $pair {
            @!_col-names.push($pair.key);
            @!_data.push($pair.value);
        }
    }

    submethod !verify-col-lens(@data) {
        my @corrected-data;
        my @lens = ($_.value.elems for @data);
        unless [==] @lens {
            my $max-len = max @lens;
            for @data -> $p {
                if $p.value.elems < $max-len {
                    @corrected-data.push($p.key => (|$p.value, |(NA for ^($max-len - $p.value.elems))));
                } else {
                    @corrected-data.push($p);
                }
            }
        }
        return @corrected-data;
    }

    method gist {
        return @!_data;
    }

    method names {
        return @!_col-names;
    }

    method of {
        return Mu;
    }

    method elems {
        return @!_data.elems;
    }

    multi method AT-POS(@col-inds) {
        say "mewwwwww~~~";
        return @!_data[@col-inds];
    }

    multi method EXISTS-POS(@col-inds) {
        say "mewwwwww~~~";
        return so all (@!_data.EXISTS-POS[$_] for @col-inds);
    }

    multi method AT-POS(@row-inds, @col-inds) {
        say "mewwwwww~~~";
        return @!_data[@col-inds; @row-inds];
    }

    multi method EXISTS-POS(@row-ind, @col-ind) {
        say "mewwwwww~~~";
        return so all ( -> ($col, $row) { @!_data.EXISTS-POS[$col; $row] } for @col-ind X @row-ind );
    }

    # method data {
    #     return @!_data;
    # }
}


# TESTS
my @sleep = (
    extra => (0.7, -1.6, -0.2, -1.2, -0.1, 3.4, 3.7, 0.8, 0.0, 2.0,
              1.9,  0.8,  1.1,  0.1, -0.1, 4.4, 5.5, 1.6, 4.6, 3.4),
    group => (1, 1, 1, 1, 1, 1, 1, 1, 1,  1, 2, 2, 2, 2, 2, 2, 2, 2, 2,  2),
    id    => (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
);

my @test-data = (
    id  => (1, 2, 3, 4, 5),
    val => (9, 7, 9)
);

my $data = DataFrame.new(:data(@test-data));
# say "Rows: " ~ $data.n-rows;
# say "Cols: " ~ $data.n-cols;
# say $data.names;
say $data.AT-POS[0];

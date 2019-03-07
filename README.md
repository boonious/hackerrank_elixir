# HackerRank solutions [![Build Status](https://travis-ci.org/boonious/hackerrank_elixir.svg?branch=master)](https://travis-ci.org/boonious/hackerrank_elixir) 

This repository contains some of my solutions in Elixir for various HackerRank challenges, 
in particular for functional programming.

## Usage

To ses how the solutions work, check out their corresponding test cases that
include data input and output as suggested by HackerRank. You can also try out
the solutions (functions) 
using [interactive Elixir](https://elixir-lang.org/getting-started/introduction.html#interactive-mode)
(invoking `iex -S mix` from software home directory).

```elixir
    # evaluating e^5, with 9 additional terms in the series
    iex> FP.Intro.exp(5.0, 9)
```

Note: it is necessary to provide additional functional hooks
to integrate the input and output data on HackerRank
during code submission and evaluation, typically through
`IO` calls in a `Solution.main` function to
parse and cast multi-line data into appropriate input data types,
as well as output results to stdout.
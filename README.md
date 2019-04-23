# HackerRank solutions [![Build Status](https://travis-ci.org/boonious/hackerrank_elixir.svg?branch=master)](https://travis-ci.org/boonious/hackerrank_elixir) 

This repository contains some of my solutions in Elixir for various HackerRank challenges, 
in particular for functional programming, algorithms and data structures. The solutions are completedly
test-driven.

## Scope
Read the [documentation](doc/index.html).

## Usage
The solutions are meant to be used as a reference only for your own studies and practices.
Please try your approach first, before comparing it with the one here.

To see what solutions are available and how they work, read the [API documentation](doc/api-reference.html) and
the corresponding test cases that include data input and output where suggested by
HackerRank. Running `mix test` would execute the solution against all the test cases.

You can also try out the solutions (functions)
using [interactive Elixir](https://elixir-lang.org/getting-started/introduction.html#interactive-mode)
(invoking `iex -S mix` from software home directory).

```elixir
    # evaluating e^5, with 9 additional terms in the series
    iex> FP.Intro.exp(5.0, 9)
    ..

    # trying out Sierpinski fractal triangle
    iex> FP.Recursion.Advanced.draw_triangles 3
    ["_______________________________1_______________________________",
    "______________________________111______________________________",
    "_____________________________11111_____________________________",
    "____________________________1111111____________________________",
    "___________________________1_______1___________________________",
    "__________________________111_____111__________________________",
    "_________________________11111___11111_________________________",
    "________________________1111111_1111111________________________",
    "_______________________1_______________1_______________________",
    "______________________111_____________111______________________",
    "_____________________11111___________11111_____________________",
    "____________________1111111_________1111111____________________",
    "___________________1_______1_______1_______1___________________",
    "__________________111_____111_____111_____111__________________",
    "_________________11111___11111___11111___11111_________________",
    "________________1111111_1111111_1111111_1111111________________",
    "_______________1_______________________________1_______________",
    "______________111_____________________________111______________",
    "_____________11111___________________________11111_____________",
    "____________1111111_________________________1111111____________",
    "___________1_______1_______________________1_______1___________",
    "__________111_____111_____________________111_____111__________",
    "_________11111___11111___________________11111___11111_________",
    "________1111111_1111111_________________1111111_1111111________",
    "_______1_______________1_______________1_______________1_______",
    "______111_____________111_____________111_____________111______",
    "_____11111___________11111___________11111___________11111_____",
    "____1111111_________1111111_________1111111_________1111111____",
    "___1_______1_______1_______1_______1_______1_______1_______1___",
    "__111_____111_____111_____111_____111_____111_____111_____111__",
    "_11111___11111___11111___11111___11111___11111___11111___11111_",
    "1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111"]
```

Note: it is necessary to provide additional functional hooks
to integrate the input and output data on HackerRank
during code submission and evaluation, typically through
`IO` calls in a `Solution.main` function to
parse and cast multi-line data into appropriate input data types,
as well as output results to stdout.

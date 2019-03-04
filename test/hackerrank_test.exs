defmodule SolutionTest do
  use ExUnit.Case
  doctest Solution.FP

  # https://www.hackerrank.com/challenges/eval-ex/problem
  test "reverse - reverse a list" do
    input = [19, 22, 3, 28, 26, 17, 18, 4, 28, 0]
    results = []
    output = input |> Solution.FP.reverse(results)
    assert output == [0, 28, 4, 18, 17, 26, 28, 3, 22, 19]
  end

  # https://www.hackerrank.com/challenges/eval-ex/problem
  test "exp - Evaluating exponential, e^x" do
    test_cases = [20.0000, 5.0000, 0.5000, -0.5000]
    initial_results = 1 # initial a sum to be added to
    number_of_terms = 9

    test_results = test_cases |> Enum.map(&Solution.FP.exp(&1, number_of_terms, initial_results))

    assert test_results == [2423600.1887, 143.6895, 1.6487, 0.6065]
  end

end

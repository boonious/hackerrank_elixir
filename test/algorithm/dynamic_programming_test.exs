defmodule AlgoDPTest do
  use ExUnit.Case
  import Algo.DP

  doctest Algo.DP

  # https://www.hackerrank.com/challenges/maxsubarray/problem
  test "max_subarray_sums - Maximum subarray, identify the largest possible of sums of a subarray" do
    assert max_subarray_sums([1, 2, 3, 4], 4) == [10, 10]
    assert max_subarray_sums([2, -1, 2, 3, 4, -5], 6) == [10, 11]
    assert max_subarray_sums([-2, -3, -1, -4, -6], 5) == [-1, -1]
    assert max_subarray_sums([1, -1, -1, -1, -1, 5], 6) == [5, 6]
  end

  # https://www.hackerrank.com/challenges/maxsubarray/problem
  test "string_reduce - Reduce string and count unique character(s)" do
    assert string_reduce("cab") == 2
    assert string_reduce("bcab") == 1
    assert string_reduce("ccccc") == 5
  end

  # https://www.hackerrank.com/challenges/k-factorization/problem
  test "k_factor - Find lexicographically smallest series to reach N, given a list of plausible factors" do
    assert k_factor(12, [2, 3, 4]) == [1, 3, 12]
    assert k_factor(15, [2, 10, 6, 9, 11]) == [-1]
    assert k_factor(175_840_877, [4, 5, 6, 7, 8, 10, 12, 17, 18, 19]) == [-1]
  end
end

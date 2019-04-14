defmodule AlgoDPTest do
  use ExUnit.Case
  import Algo.DP

  doctest Algo.DP

  # https://www.hackerrank.com/challenges/maxsubarray/problem
  test "max_subarray - Maximum subarray, identify the largest possible of sums of a subarray" do
    assert max_subarray([1,2,3,4],4) == [10,10]
    assert max_subarray([2,-1,2,3,4,-5],6) == [10,11]
    assert max_subarray([-2,-3,-1,-4,-6],5) == [-1,-1]
    assert max_subarray([1,-1,-1,-1,-1,5],6) == [5,6]
  end

end
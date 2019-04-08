defmodule AlgoConstructiveTest do
  use ExUnit.Case
  import Algo.Constructive

  doctest Algo.Constructive

  describe "algorithm - constructive" do
    @describetag :constructive

    # https://www.hackerrank.com/challenges/new-year-chaos/problem
    test "minimum_bribes - New year chaos, check feasibility/calculate bribes required for a queue scenarios" do
      assert minimum_bribes([2,1,5,3,4]) == 3
      assert minimum_bribes([2,5,1,3,4]) == "Too chaotic"
      assert minimum_bribes([1,2,5,3,7,8,6,4]) == 7
    end

  end

end
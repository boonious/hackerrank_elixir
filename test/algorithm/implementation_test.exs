defmodule AlgoImpTest do
  use ExUnit.Case
  import Algo.Imp

  doctest Algo.Imp

  describe "algorithm - implementation" do
    @describetag :implementation

    # https://www.hackerrank.com/challenges/repeated-string/problem
    test "repeated_string - Repeated string" do
      assert repeated_string("aba", 10) == 7
      assert repeated_string("a", 1000000000000) == 1000000000000
    end

    # https://www.hackerrank.com/challenges/kangaroo/problem
    test "f - Kangaroo" do
      assert f([0, 3, 4, 2]) == true
      assert f([0, 2, 5, 3]) == false
      assert f([21, 6, 47, 3]) == false
      assert f([43, 2, 70, 2]) == false
    end

    # https://www.hackerrank.com/challenges/divisible-sum-pairs/problem
    test "divisible_sum_pairs" do
      assert divisible_sum_pairs([1,3,2,6,1,2],3) == 5
    end

  end

end
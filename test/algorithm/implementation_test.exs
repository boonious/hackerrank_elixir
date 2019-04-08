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

  end

end
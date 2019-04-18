defmodule FPMemoiDPTest do
  use ExUnit.Case
  import FP.MemoiDP

  doctest FP.MemoiDP
  
  describe "memoisation dp" do
    @describetag :memoi_dp
    
    #  https://www.hackerrank.com/challenges/pentagonal-numbers/problem
    test "p - Pentagonal numbers, compute number of dots for recursive overlapping pentagons" do
      assert p(1) == 1
      assert p(2) == 5
      assert p(3) == 12
      assert p(4) == 22
      assert p(5) == 35
    end

  end

end
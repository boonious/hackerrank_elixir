defmodule FPMemoiDPTest do
  use ExUnit.Case
  import FP.MemoiDP

  doctest FP.MemoiDP

  describe "memoisation dp" do
    @describetag :memoi_dp

    # https://www.hackerrank.com/challenges/pentagonal-numbers/problem
    test "p - Pentagonal numbers, compute number of dots for recursive overlapping pentagons" do
      assert p(1) == 1
      assert p(2) == 5
      assert p(3) == 12
      assert p(4) == 22
      assert p(5) == 35
    end

    test "p_cache - Pentagonal numbers, memoisation technique for computing sizes of recursive overlapping pentagons" do
      {p, cache} = p_cache(3)
      assert p == 12
      assert cache == %{1=>1, 2=>5, 3=>12}

      # compute a p value and return a new cache containing p(n-1) values
      assert p_cache(5) == {35, %{1 => 1, 2 => 5, 3 => 12, 4 => 22, 5 => 35}}

      # compute a series of p values
      # - cache being generated and looked up within the function
      assert p([1,2,3,4,5]) == [1, 5, 12, 22, 35]
    end

    # https://www.hackerrank.com/challenges/fibonacci-fp/problem
    test "fibonacci - compute large Fibonacci numbers" do
      assert fibonacci([0,1,5,10]) == [0, 1, 5, 55]
      assert fibonacci([100]) == [24278230]
    end

  end

end
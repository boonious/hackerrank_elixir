defmodule FPRecursionTest do
  use ExUnit.Case
  doctest FP.Recursion
  
  describe "recursion" do
    @describetag :recursion
    
    #https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---gcd/problem
    test "gcd - computing the greatest common divisor GCD using Euclidean Algorithm" do
      input = [1, 5]
      assert FP.Recursion.gcd(input) == 1

      input = [10, 100]
      assert FP.Recursion.gcd(input) == 10

      input = [1701, 3768]
      assert FP.Recursion.gcd(input) == 3
    
      input = [13, 13]
      assert FP.Recursion.gcd(input) == 13
    
      input = [144, 38]
      assert FP.Recursion.gcd(input) == 2
    end

    # https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---fibonacci-numbers/problem
    test "fibonacci - Fibonacci numbers" do
      n = 3
      assert FP.Recursion.fibonacci(n) == 1

      n = 4
      assert FP.Recursion.fibonacci(n) == 2

      n = 5
      assert FP.Recursion.fibonacci(n) == 3
    end

    #https://www.hackerrank.com/challenges/pascals-triangle/problem
    test "pascal_tri - Pascal's triangle numbers" do
      n = 4
      assert FP.Recursion.pascal_tri_row(n-1) == [1,3,3,1]
      assert FP.Recursion.pascal_tri(n) === [[1], [1,1], [1,2,1], [1,3,3,1]]
    end


    #https://www.hackerrank.com/challenges/string-o-permute/problem
    test "permute_string - String-o-permute" do
      assert FP.Recursion.permute_string("abcdpqrs") == "badcqpsr"
      assert FP.Recursion.permute_string("az") == "za"
    end

    #https://www.hackerrank.com/challenges/string-mingling/problem
    test "mingle_string - String mingling" do
      assert FP.Recursion.mingle_string(["abcde", "pqrst"]) == "apbqcrdset"
      assert FP.Recursion.mingle_string(["hacker", "ranker"]) == "hraacnkkeerr"
    end


  end

end

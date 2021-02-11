defmodule FPAdHocTest do
  use ExUnit.Case
  doctest FP.AdHoc

  describe "ad hoc" do
    @describetag :ad_hoc

    # https://www.hackerrank.com/challenges/remove-duplicates/problem
    test "dedup - Remove duplicates (char)" do
      assert FP.AdHoc.dedup("aabc") == "abc"
      assert FP.AdHoc.dedup("ccbabacc") == "cba"
      assert FP.AdHoc.dedup("sdfsdewrmmweswerpsdfpmssfaql") == "sdfewrmpaql"
    end

    # https://www.hackerrank.com/challenges/rotate-string/problem
    test "rotate - Rotate string" do
      assert FP.AdHoc.rotate("abc") == ["bca", "cab", "abc"]
      assert FP.AdHoc.rotate("abcde") == ["bcdea", "cdeab", "deabc", "eabcd", "abcde"]
      assert FP.AdHoc.rotate("abab") == ["baba", "abab", "baba", "abab"]
      assert FP.AdHoc.rotate("aaa") == ["aaa", "aaa", "aaa"]
      assert FP.AdHoc.rotate("z") == ["z"]
    end

    test "rotate - Rotate string binary matching" do
      assert FP.AdHoc.rotate_binary("abc") == ["bca", "cab", "abc"]
      assert FP.AdHoc.rotate_binary("abcde") == ["bcdea", "cdeab", "deabc", "eabcd", "abcde"]
      assert FP.AdHoc.rotate_binary("abab") == ["baba", "abab", "baba", "abab"]
      assert FP.AdHoc.rotate_binary("aaa") == ["aaa", "aaa", "aaa"]
      assert FP.AdHoc.rotate_binary("z") == ["z"]
    end

    # https://www.hackerrank.com/challenges/huge-gcd-fp/problem
    test "prime_factorise - Huge GCD numbers" do
      # 'prime_factorise' function is required to factorise number into primes
      # for computing GCD of huge numbers by prime decomposition
      assert FP.AdHoc.prime_factorise(170) == [2, 5, 17]
      assert FP.AdHoc.prime_factorise(6561) == [3, 3, 3, 3, 3, 3, 3, 3]
      assert FP.AdHoc.prime_factorise(255) == [3, 5, 17]
    end

    test "gcd - Huge GCD " do
      # for gcd(2x2x3x3x2x5, 8x1x6x170)
      x = [[2, 2, 3, 3, 25], [8, 1, 6, 170]]
      assert FP.AdHoc.gcd(x) == 60

      x = [[1, 2, 4, 8, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192], [1, 3, 9, 27, 81, 243, 729, 2187, 6561]]
      assert FP.AdHoc.gcd(x) == 1

      x = [[2, 3, 5], [4, 5]]
      assert FP.AdHoc.gcd(x) == 10

      x = [[55, 555, 5, 64, 23, 66, 23, 45, 33, 563], [2, 3, 4, 5, 7]]
      assert FP.AdHoc.gcd(x) == 120
    end
  end
end

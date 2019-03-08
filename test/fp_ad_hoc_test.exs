defmodule FPAdHocTest do
  use ExUnit.Case
  doctest FP.AdHoc
  
  describe "ad hoc" do
    @describetag :ad_hoc
    
    #https://www.hackerrank.com/challenges/remove-duplicates/problem
    test "dedup - Remove duplicates (char)" do
      assert FP.AdHoc.dedup("aabc") == "abc"
      assert FP.AdHoc.dedup("ccbabacc") == "cba"
      assert FP.AdHoc.dedup("sdfsdewrmmweswerpsdfpmssfaql") == "sdfewrmpaql"
    end

    #https://www.hackerrank.com/challenges/rotate-string/problem
    test "rotate - Rotate string" do
      assert FP.AdHoc.rotate("abc") == ["bca", "cab", "abc"]
      assert FP.AdHoc.rotate("abcde") == ["bcdea", "cdeab", "deabc", "eabcd", "abcde"]
      assert FP.AdHoc.rotate("abab") == ["baba", "abab", "baba", "abab"]
      assert FP.AdHoc.rotate("aaa") == ["aaa", "aaa", "aaa"]
      assert FP.AdHoc.rotate("z") == ["z"]
    end

  end

end
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

  end

end
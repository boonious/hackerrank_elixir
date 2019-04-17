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

    # https://www.hackerrank.com/challenges/the-grid-search/problem
    test "grid_search - Grid search, find a match for a 2D string array within a grid array" do
      g = ["7283455864","6731158619","8988242643","3830589324","2229505813","5633845374","6473530293","7053106601","0834282956","4607924137"]
      p = ["9505","3845","3530"]
      str_len = p |> hd |> String.length

      assert grid_search(g, p, str_len) == true

      g = ["400453592126560","114213133098692","474386082879648","522356951189169","887109450487496","252802633388782","502771484966748","075975207693780","511799789562806","404007454272504","549043809916080","962410809534811","445893523733475","768705303214174","650629270887160"]
      p = ["99","99"]
      assert grid_search(g, p, 2) == false

      # grid containing multiple possible matches
      # on the same and other rows
      g = [
        "1113411",
        "511156",
        "113634",
        "788888"] # overlapping patterns
      p = [
        "11",
        "36"]
      assert grid_search(g, p, 2) == true

      g = [
        "123412",
        "561256",
        "123634",
        "781288"] # candidate starts near bottom of grid
      p = [
        "12",
        "XX"]
      assert grid_search(g, p, 2) == false
    end

    test "grid_search/4 - Grid search, find match for a string within a string array" do
      g = ["7283455864","6731158619","8988242643","3830589324","2229505813","5633845374","6473530293","7053106601","0834282956","4607924137"]
      p = "9505"

      assert grid_search(g, p) == [{3, 5}]

      p = "blah"
      assert grid_search(g, p) == []
      
      # identify all substring matches
      p = "24"
      assert grid_search(g, p) ==  [{4, 3}, {8, 4}, {5, 10}]
      
      g = [
        "1113411",
        "511156",
        "113634",
        "788888"] # overlapping patterns
      p = "11"
      assert grid_search(g, p) == [{0, 1}, {1, 1}, {5, 1}, {1, 2}, {2, 2}, {0, 3}]
    end

  end

end
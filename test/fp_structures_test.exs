defmodule FPStructuresTest do
  use ExUnit.Case
  import FP.Structures

  doctest FP.Structures
  
  describe "structures" do
    @describetag :structures

  end

    test "n - binary tree node creation / addition" do
      assert n(1) ==  %{l: nil, r: nil, v: 1}
      assert n(1) |> add([2,3])
             == %{v: 1, l: %{l: nil, r: nil, v: 2}, r: %{l: nil, r: nil, v: 3}}
    test "build_tree - binary tree building" do
      assert build_tree([[2, 3]]) ==  %{l: nil, r: nil, v: 22}
      assert build_tree([[2, 3], [-1, -1], [-1, -1]])
      == %{
        v: 1,
        l: %{v: 2, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
        r: %{v: 3, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
      }
    end

    end

end
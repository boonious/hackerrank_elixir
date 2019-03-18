defmodule FPStructuresTest do
  use ExUnit.Case
  doctest FP.Structures
  
  describe "structures" do
    @describetag :structures

  end

    test "n - binary tree node creation / addition" do
      assert n(1) ==  %{l: nil, r: nil, v: 1}
      assert n(1) |> add(2, :left) |> add(3, :right)
             == %{v: 1, l: %{l: nil, r: nil, v: 2}, r: %{l: nil, r: nil, v: 3}}
    end

end
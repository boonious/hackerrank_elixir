defmodule FP.Structures do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: functional structures.
  """

  #==========================================================================
  @doc """
  Binary tree: swap and traverse nodes

  https://www.hackerrank.com/challenges/swap-nodes/problem
  """

  # define a binary tree node of value (v) with left (l), right (r) leaves
  def n(value), do: %{v: value, l: nil, r: nil}

  # methods for adding nodes
  def add(%{v: v, l: _l, r: r} = _n, value, :left), do: %{v: v, l: n(value), r: r}
  def add(%{v: v, l: l, r: _r} = _n, value, :right), do: %{v: v, l: l, r: n(value)}

end
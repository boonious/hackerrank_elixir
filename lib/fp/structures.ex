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

  # functions for adding left, right nodes when leaf is "nil" (empty)
  def add(%{v: v, l: l, r: r} = _n, {lv,rv}) when is_nil(l) and is_nil(r), do: %{v: v, l: n(lv), r: n(rv)}


end
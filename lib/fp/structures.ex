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

  # start building tree with a n[1] root, count of 1
  def build_tree(data), do: build_tree(data, n(1), 1)

  def build_tree([], tree, _count), do: tree
  def build_tree(data, tree, count) do
    nodes = data |> Enum.take(count)
    remaining_nodes = data |> Enum.drop(count)

    # add nodes to tree
    new_tree = build_tree(nodes, tree)

    # calculate the next batch of nodes in the next level
    new_count = nodes
    |> List.flatten
    |> Enum.filter(&(&1!=-1))
    |> length

    # build the next level tree nodes
    build_tree(remaining_nodes, new_tree, new_count)
  end

  # functions for adding nodes to tree
  def build_tree([], tree), do: tree
  def build_tree([n|nodes], tree), do: build_tree(nodes, tree |> add(n))

  # functions for adding left, right nodes alternately when leaf is "nil" (empty)
  def add(%{v: v, l: l, r: r} = _n, [lv,rv]) when is_nil(l) and is_nil(r), do: %{v: v, l: n(lv), r: n(rv)}
  def add(%{v: v, l: l, r: r} = _n, value) do
    cond do
      l.l == nil -> %{v: v, l: l |> add(value), r: r}
      r.l == nil -> %{v: v, l: l, r: r |> add(value)}
    end
  end

end
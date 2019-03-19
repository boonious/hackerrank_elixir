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

  # start building tree with a n[1] root, count of 1 at depth 1
  def build_tree(data) do
    root = n(1)
    node_count = 1
    depth = 1

    build_tree(data, root, node_count, depth)
  end

  def build_tree([], tree, _, _), do: tree
  def build_tree(data, tree, count, depth) do
    nodes = data |> Enum.take(count)
    remaining_nodes = data |> Enum.drop(count)

    # add nodes to tree
    new_tree = build_tree(nodes, tree, depth)

    # calculate the next batch of nodes in the next level
    new_count = nodes
    |> List.flatten
    |> Enum.filter(&(&1!=-1))
    |> length

    # build the remaining tree nodes on the next depth
    build_tree(remaining_nodes, new_tree, new_count, depth + 1)
  end

  # adding nodes to tree
  def build_tree([], tree, _), do: tree
  def build_tree([data|nodes], tree, depth), do: build_tree(nodes, tree |> add(data, depth), depth)

  # adding left, right nodes alternately when leaf in the current depth is "nil" (empty)
  def add(%{v: v, l: l, r: r} = _n, [lv,rv], _depth)
      when is_nil(l) and
      is_nil(r) and
      v != -1 do 

    %{v: v, l: n(lv), r: n(rv)}
  end

  def add(%{v: v, l: l, r: r} = _n, value, depth) do
    # depth info for checking nested node
    cond do
      nil_leaf?(l, depth) -> %{v: v, l: l |> add(value, depth - 1), r: r}
      nil_leaf?(l, depth, :right) -> %{v: v, l: l |> add(value, depth - 1), r: r}
      nil_leaf?(r, depth) -> %{v: v, l: l, r: r |> add(value, depth - 1)}
      nil_leaf?(r, depth, :right) -> %{v: v, l: l, r: r |> add(value, depth - 1)}
    end
  end

  defp nil_leaf?(leaf, depth, side \\ :left) do 
    p = List.duplicate(:l, depth - 1)
    path = if side == :left, do: p, else: p |> List.replace_at(0, :r)
    v_path =  path |> List.replace_at(-1, :v)

    x1 = get_in(leaf, path) == nil
    y1 = get_in(leaf, v_path) != -1
    z1 = get_in(leaf, v_path) != nil

    x2 = get_in(leaf, path |> List.replace_at(-2, :r)) == nil
    y2 = get_in(leaf, v_path |>  List.replace_at(-2, :r)) != -1
    z2 = get_in(leaf, v_path |> List.replace_at(-2, :r)) != nil

    if depth > 2 do
      cond do
        x1 and y1 and z1 -> true
        true -> x2 and y2 and z2
      end
    else
      x1 and y1
    end

  end

end
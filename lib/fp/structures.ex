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

  def swap(tree, current_depth, depth, _k) when current_depth == depth, do: tree
  def swap(%{l: nil, r: nil, v: -1}, _, _, _), do: %{l: nil, r: nil, v: -1}
  def swap(%{v: v, l: l, r: r} = _tree, current_depth, depth, k) do
  # swap left/right nodes only if depth corresponds to
  # the specified series of depth levels (k, 2k, 3k..)
    if Enum.member? k, current_depth do
      %{v: v, l: swap(r, current_depth + 1, depth, k), r: swap(l, current_depth + 1, depth, k)}
    else
      %{v: v, l: swap(l, current_depth + 1, depth, k), r: swap(r, current_depth + 1, depth, k)}
    end
  end

  def inorder_traverse(tree) do
    {stack, output} = {[], []}

    # :l left, :r right, :d down, :u up
    left = inorder(tree.l, stack, output, {:l,:d})
    right = inorder(tree.r, stack, output, {:r,:d})

    left ++ [1] ++ right
  end

  defp inorder(tree, stack, output, direction \\ {:l,:d})
  defp inorder(%{v: v, l: l, r: r} = _tree, s, out, {:l,:d}) do
    cond do
      l.v == -1 and r.v == -1 -> inorder(l, s, [v|out], {:l,:u})
      l.v == -1 and r.v != -1 -> inorder(r, s, [v|out], {:r,:d})
      l.v != -1 and r.v == -1 -> inorder(l, [{v,nil}|s], out)
      l.v != -1 and r.v != -1 -> inorder(l, [{v,r}|s], out)
    end
  end

  defp inorder(%{v: v, l: l, r: r} = _tree, s, out, {:r,:d}) do
    cond do
      l.v == -1 and r.v == -1 -> inorder(r, s, [v|out], {:r,:u})
      l.v == -1 and r.v != -1 -> inorder(r, s, [v|out], {:r,:d})
      l.v != -1 and r.v == -1 -> inorder(l, [{v,nil}|s], out)
      l.v != -1 and r.v != -1 -> inorder(l, [{v,r}|s], out)
    end
  end

  defp inorder(_, [], out, {_,:u}), do: out |> Enum.reverse
  defp inorder(_tree, s, out, {_,:u}) do
    {v,r_node} = s |> hd

    if r_node != nil do 
      inorder(r_node, s |> tl, [v|out], {:r,:d})
    else
      inorder(r_node, s |> tl, [v|out], {:l,:u})
    end 
  end

  # start building tree with a n[1] root, count of 1 at depth 1
  def build_tree(data) do
    root = n(1)
    node_count = 1
    depth = 1

    build_tree(data, root, node_count, depth)
  end

  def build_tree([], tree, _, depth), do: {depth, tree}
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

  # this recursively traverse tree, and find the next leaf node
  # to add the new node pair to
  def add(%{v: v, l: l, r: r} = _n, value, depth) do
    cond do
      nil_leaf?(l, depth) -> %{v: v, l: l |> add(value, depth - 1), r: r}
      nil_leaf?(l, depth, :right) -> %{v: v, l: l |> add(value, depth - 1), r: r}
      nil_leaf?(r, depth) -> %{v: v, l: l, r: r |> add(value, depth - 1)}
      nil_leaf?(r, depth, :right) -> %{v: v, l: l, r: r |> add(value, depth - 1)}
    end
  end

  defp nil_leaf?(leaf, depth, side \\ :left)
  defp nil_leaf?(leaf, depth, side) when depth <= 2 do
    p = List.duplicate(:l, depth - 1)
    path = if side == :left, do: p, else: p |> List.replace_at(0, :r)
    v_path =  path |> List.replace_at(-1, :v)

    x = get_in(leaf, path) == nil
    y = get_in(leaf, v_path) != -1
    x and y
  end

  # check all 4 leaf nodes per pair of nodes (as per HackerRank input), i.e. 2x left, right nodes
  # this finds the next valid leaf node (not terminated) for adding the next child node pair to
  defp nil_leaf?(leaf, depth, side) do
    p = List.duplicate(:l, depth - 1)

    lll_p = if side == :left, do: p, else: p |> List.replace_at(0, :r)
    llv_p =  lll_p |> List.replace_at(-1, :v)

    lrl_p = lll_p |> List.replace_at(-2, :r)
    lrv_p = llv_p |> List.replace_at(-2, :r)

    rll_p = lll_p |> List.replace_at(-3, :r)
    rlv_p = llv_p |> List.replace_at(-3, :r)
    
    rrl_p = lrl_p |> List.replace_at(-3, :r)
    rrv_p = lrv_p |> List.replace_at(-3, :r)

    cond do
      get_in(leaf, lll_p) == nil and get_in(leaf, llv_p) != -1 and get_in(leaf, llv_p) != nil -> true
      get_in(leaf, lrl_p) == nil and get_in(leaf, lrv_p) != -1 and get_in(leaf, lrv_p) != nil -> true
      get_in(leaf, rll_p) == nil and get_in(leaf, rlv_p) != -1 and get_in(leaf, rlv_p) != nil -> true
      get_in(leaf, rrl_p) == nil and get_in(leaf, rrv_p) != -1 and get_in(leaf, rrv_p) != nil -> true
      true -> false # this is not a valid leaf node (-1 terminated leaf)
    end

  end

end
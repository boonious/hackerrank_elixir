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

  def swap_nodes(data) do
    [[n] | x ] = data

    nodes_data = Enum.take(x, n)
    [_ | swap_data] = Enum.drop(x, n) |> List.flatten

    # build the binary tree
    {depth, info} = tree_data(nodes_data)
    children = []
    tree = build_tree(nodes_data, children, info)

    output = []
    swap_nodes(tree, swap_data, depth, output)
  end

  def swap_nodes(_, [], _, output), do: output |> Enum.reverse
  def swap_nodes(tree, swap_data, depth, output) when is_list(swap_data) do
    level = hd swap_data

    k = depth_series(level, 1, [level], depth) |> Enum.reverse
    x = swap(tree, 1, depth, k)
    y = x |> inorder_traverse

    swap_nodes(x, swap_data |> tl, depth, [y|output])
  end

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

  # implement the algorithm below for Elixir
  # https://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion
  def inorder_traverse(tree) do
    {stack, output} = {[], []}

    # :l left, :r right, :d down, :u up
    left = inorder(tree.l, stack, output, {:l,:d})
    right = inorder(tree.r, stack, output, {:r,:d})

    left ++ [1] ++ right
  end

  defp inorder(tree, stack, output, direction \\ {:l,:d})
  defp inorder(%{l: nil, r: nil, v: -1}, s, out, {:l,:d}), do: inorder(nil, s, out, {:l,:u})
  defp inorder(%{l: nil, r: nil, v: -1}, s, out, {:r,:d}), do: inorder(nil, s, out, {:r,:u})

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

  # recursively parse nodes data from top down, in a single pass
  # to determine the total depth and the actual number of
  # nodes per depth level
  def tree_data(nodes_data) do
    node_count = 1
    depth = 1
    info = [node_count]
    tree_data(nodes_data, info, node_count, depth)
  end

  def tree_data([], info, _, depth), do: {depth, info |> tl}
  def tree_data(nodes_data, info, count, depth) do
    nodes = nodes_data |> Enum.take(count)
    remaining_nodes = nodes_data |> Enum.drop(count)

    # count nodes, omitting any terminated nodes
    new_count = nodes
    |> List.flatten
    |> Enum.filter(&(&1!=-1))
    |> length

    tree_data(remaining_nodes, [new_count|info], new_count, depth + 1)
  end

  # new algorithm that builds tree from bottom up,
  # using a priori (from 'tree_data')
  # depth and num of nodes per level information
  #
  # this is much simpler and time-performant,
  # and passes the last two
  # HackerRank test cases for tree with > 1000 nodes
  # 
  # the previous algorithm builds tree from top down
  # and involves scanning the entire tree (from root down)
  # to find leaf nodes, per node addition and
  # therefore becomes incredibly unefficient for large trees
  def build_tree(_, [[l,r]], []), do: %{v: 1, l: l, r: r}
  def build_tree(data, children, [c|count]) do
    nodes = data |> Enum.take(0 - c)
    remaining_nodes = data |> Enum.drop(0 - c)

    parent = build_nodes(nodes, [])
    new_children = merge_tree(parent |> List.flatten, children, [])

    build_tree(remaining_nodes, new_children, count)
  end

  def build_nodes([], nodes), do: nodes |> Enum.reverse
  def build_nodes([[l,r]|y], nodes) do
    build_nodes(y, [[n(l), n(r)] | nodes])
  end

  def merge_tree([], _, tree), do: tree |> Enum.reverse |> Enum.chunk_every(2)
  def merge_tree([x|nodes], children, tree) when is_list(nodes) do
    {y, remaining_children} = merge_tree(x, children)
    merge_tree(nodes, remaining_children, [y|tree])
  end

  def merge_tree(%{l: nil, r: nil, v: -1} = node, children), do: {node, children}
  def merge_tree(%{l: nil, r: nil, v: v} = _, children) do
    [l, r] = children |> hd
    {%{l: l, r: r, v: v}, children |> tl}
  end

  # return levels in 1k,2k,3k.. for a given first swap 'k' level
  defp depth_series(k, nth, [l|levels], depth) when l < depth - 1 do
    x = [l|levels]
    depth_series(k, nth+1, [(nth+1)*k|x], depth)
  end
  defp depth_series(_k, _nth, levels, depth), do: levels |> Enum.reject(&(&1 > depth - 1))


  #==============================================================================================
  @doc """
  Matrix rotation

  https://www.hackerrank.com/challenges/matrix-rotation/problem
  """
  def deconstruct(matrix) do
    new_matrix = []
    dim = []
    deconstruct(matrix, new_matrix, dim)
  end

  def deconstruct([], new_matrix, dim), do: {new_matrix, dim}
  def deconstruct([top|y], new_matrix, dim) do
    {bottom, rest1} = List.pop_at(y, -1)
    [left | rest2] = if rest1 != [], do: rest1 |> List.zip, else: [{}|[]]
    {right, rest3} = if rest2 != [] , do: List.pop_at(rest2, -1), else: {{}, []}

    circular = [top| [(right|> Tuple.to_list)| [(bottom|> Enum.reverse)| (left|> Tuple.to_list|> Enum.reverse) ]]]
    |> List.flatten

    if rest3 != [] do
      rest = rest3 |> List.zip |> Enum.map(&Tuple.to_list(&1))
      m = 2 + (rest |> length) # num of rows - top, bottom (2) + remaining inner rows
      n = top |> length
      deconstruct(rest, [circular|new_matrix], [{m,n}|dim])
    else
      m = 2
      n = top |> length
      deconstruct([], [circular|new_matrix], [{m,n}|dim])
    end
  end

end
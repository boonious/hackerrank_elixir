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
  def rotate(matrix, times) do
    {deconstructed, dim} = deconstruct(matrix)

    shift(deconstructed, times)
    |> reconstruct([], dim)
  end

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

    m = 2 + (left|> Tuple.to_list |> length)
    n = top |> length
    if rest3 != [] do
      rest = rest3 |> List.zip |> Enum.map(&Tuple.to_list(&1))
      deconstruct(rest, [circular|new_matrix], [{m,n}|dim])
    else
      deconstruct([], [circular|new_matrix], [{m,n}|dim])
    end
  end

  def reconstruct([], new_matrix, _), do: new_matrix
  def reconstruct([r|matrix], new_matrix,[{m,n}|dim]) do
    top = r |> Enum.take(n)
    rest1 = r |> Enum.drop(n)

    left_m = m - 2 # omitting top and bottom rows
    left = rest1 |> Enum.take(0-left_m) |> Enum.reverse
    rest2 = rest1 |> Enum.drop(0-left_m)

    bottom = rest2 |> Enum.take(0-n) |> Enum.reverse
    right = rest2 |> Enum.drop(0-n)

    x = new_matrix |> List.zip |> Enum.map(&Tuple.to_list(&1))
    y = ([left] ++ x ++ [right]) |> List.zip |> Enum.map(&Tuple.to_list(&1))
    z = [top] ++ y ++ [bottom]

    reconstruct(matrix, z, dim)
  end

  def shift(matrix, times) do
    m = for row <- matrix do
      row_size = length row
      n = rem(times, row_size)

      x = row |> Enum.take(n)
      y = row |> Enum.drop(n)
      y ++ x
    end
    m
  end


  #==============================================================================================
  @doc """
  Substring searching by KMP algorithm

  https://www.hackerrank.com/challenges/kmp-fp/problem
  """
  # prelims: currently straight forward algorithm that
  # doesn't solve all HackerRank test cases for humongous strings
  # next: modify algorithm by implementing pre-search scan as per KMP algorithm
  def kmp_string_search(string, pattern) when is_binary(string) and is_binary(pattern) do
    string_search(string, pattern, pattern)
  end

  def kmp_string_search(string, pattern) when is_list(string) and is_list(pattern) do
    string_search(string, pattern, pattern)
  end

  def string_search(string, subpattern, pattern, match \\ false)
  def string_search(_, _, _, true), do: "YES"
  def string_search([], _, _, false), do: "NO"
  def string_search("", _, _, false), do: "NO"

  def string_search(s, sp, p, _match) do
    m = 0
    n = 0
    p_table = {sp, m, n} # partial match table

    {m, n, matched?} = _string_search(s, sp, p_table)

    case {matched?, is_list(s)} do
      {true, _} ->
        string_search(s, sp, p, true) # all chars matched
      {false, false} ->
        <<_::binary-size(m), r_s::binary>> = s
        <<_::binary-size(n), r_p::binary>> = sp

        x = if m == 1 and n == 0, do: p, else: r_p # full scan after a partial scan failed
        string_search(r_s, x, p, false) # keep scanning
      {false, true} ->
        r_s = Enum.drop(s, m) # drop already scanned chars
        r_p = Enum.drop(sp, n) # also drop partially matched substring

        x = if m == 1 and n == 0, do: p, else: r_p # full scan after a partial scan failed
        string_search(r_s, x, p, false)
    end
  end

  defp _string_search(string, pattern, p_table, matched? \\ nil)
  defp _string_search(_, _, {_, m, n}, false), do: {m, n, false}

  defp _string_search("", "", {_, m, n}, matched?), do: {m, n, matched?}
  defp _string_search("", _, {_, m, n}, _), do: {m, n, false}
  defp _string_search(_, "", {_, m, n}, matched?), do: {m, n, matched?}

  defp _string_search([], [], {_, m, n}, matched?), do: {m, n, matched?}
  defp _string_search([], _, {_, m, n}, _), do: {m, n, false}
  defp _string_search(_, [], {_, m, n}, matched?), do: {m, n, matched?}

  defp _string_search(<<x::utf8,y::binary>>, <<i::utf8, j::binary>>, {p,m,n}, _matched?) do
    a = :binary.at p, n
    _string_search(a, {x,y}, {i,j}, {p,m,n})
  end

  defp _string_search([x|y], [i|j], {p,m,n}, _matched?) do
    a = Enum.at(p,n)
    _string_search(a, {x,y}, {i,j}, {p,m,n})
  end

  defp _string_search(a, {x,y}, {i,j}, {p,m,n}) do
    cond do
      x == i and m == 0 ->
        _string_search(y, j, {p,m+1, n}, true)
      x == i and x != a ->
        _string_search(y, j, {p,m+1, n}, true)          
      x == i and x == a ->
        _string_search(y, j, {p,m+1, n+1}, true)
      x != i and x == a and m == 0 ->
        _string_search(y, j, {p,m+1, n+1}, false)
      x != i and x != a and m == 0 ->
        _string_search(y, j, {p,m+1, n}, false)
      x != i and x == a ->
        _string_search(y, j, {p,m, n}, false)
      x != i and x != a and n == 0 ->
        _string_search(y, j, {p,m+1, n}, false)
      true ->
        _string_search(y, j, {p,m, n}, false)
    end
  end

  #==============================================================================================
  @doc """
  John and fences

  https://www.hackerrank.com/challenges/john-and-fences/problem
  """
  # Algorithm:
  # find contiguous rectangles per height
  # the area is proportional to the number of fences (spanning the area)
  # max area (for a given height) = most number of spanning fences * height
  #
  # max rectangle for the entire fence = max of max areas of all unique heights
  #
  # the algorithm should be time-performant
  # cf. computing area for all feasible fence permutations (horizontally)

  # find max rectangular at a given height of a fence with irregular heights
  def max_rectangle(heights, height) do
    heights
    |> fence_spans(height)
    |> max_span
    |> Kernel.*(height)
  end

  # find the max contiguous span from a binary list of fence spans
  def max_span(spans, current \\ 0, max \\ 0)
  def max_span([], current, max), do: if current > max, do: current, else: max
  def max_span([x|y], current, max) do
    cond do
      x == 0 and current > max ->
        max_span(y, 0, current)
      x == 0 and current <= max ->
        max_span(y, 0, max)
      x == 1 -> max_span(y, current + 1, max)
    end
  end

  # find contiguous fence spans that achieve at least a given height
  def fence_spans(heights, height \\ 0, spans \\ [])
  def fence_spans([], _, spans), do: spans |> Enum.reverse
  def fence_spans([x|y], height, spans) when x >= height, do: fence_spans(y, height, [1|spans])
  def fence_spans([x|y], height, spans) when x < height, do: fence_spans(y, height, [0|spans])

end
defmodule FP.Structures do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: functional structures.
  """

  @doc false
  # define a binary tree node of value (v) with left (l), right (r) leaves
  def n(value), do: %{v: value, l: nil, r: nil}

  # ==========================================================================
  @doc """
  Binary tree: swap and traverse nodes

  https://www.hackerrank.com/challenges/swap-nodes/problem
  """
  @spec swap_nodes(list) :: list
  def swap_nodes(data) do
    [[n] | x] = data

    nodes_data = Enum.take(x, n)
    [_ | swap_data] = Enum.drop(x, n) |> List.flatten()

    # build the binary tree
    {depth, info} = tree_data(nodes_data)
    children = []
    tree = build_tree(nodes_data, children, info)

    output = []
    swap_nodes(tree, swap_data, depth, output)
  end

  @doc false
  def swap_nodes(_, [], _, output), do: output |> Enum.reverse()

  def swap_nodes(tree, swap_data, depth, output) when is_list(swap_data) do
    level = hd(swap_data)

    k = depth_series(level, 1, [level], depth) |> Enum.reverse()
    x = swap(tree, 1, depth, k)
    y = x |> inorder_traverse

    swap_nodes(x, swap_data |> tl, depth, [y | output])
  end

  @doc false
  def swap(tree, current_depth, depth, _k) when current_depth == depth, do: tree
  def swap(%{l: nil, r: nil, v: -1}, _, _, _), do: %{l: nil, r: nil, v: -1}

  def swap(%{v: v, l: l, r: r} = _tree, current_depth, depth, k) do
    # swap left/right nodes only if depth corresponds to
    # the specified series of depth levels (k, 2k, 3k..)
    if Enum.member?(k, current_depth) do
      %{v: v, l: swap(r, current_depth + 1, depth, k), r: swap(l, current_depth + 1, depth, k)}
    else
      %{v: v, l: swap(l, current_depth + 1, depth, k), r: swap(r, current_depth + 1, depth, k)}
    end
  end

  # implement the algorithm below for Elixir
  # https://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion
  @doc false
  @spec inorder_traverse(map) :: list
  def inorder_traverse(tree) do
    {stack, output} = {[], []}

    # :l left, :r right, :d down, :u up
    left = inorder(tree.l, stack, output, {:l, :d})
    right = inorder(tree.r, stack, output, {:r, :d})

    left ++ [1] ++ right
  end

  defp inorder(tree, stack, output, direction \\ {:l, :d})
  defp inorder(%{l: nil, r: nil, v: -1}, s, out, {:l, :d}), do: inorder(nil, s, out, {:l, :u})
  defp inorder(%{l: nil, r: nil, v: -1}, s, out, {:r, :d}), do: inorder(nil, s, out, {:r, :u})

  defp inorder(%{v: v, l: l, r: r} = _tree, s, out, {:l, :d}) do
    cond do
      l.v == -1 and r.v == -1 -> inorder(l, s, [v | out], {:l, :u})
      l.v == -1 and r.v != -1 -> inorder(r, s, [v | out], {:r, :d})
      l.v != -1 and r.v == -1 -> inorder(l, [{v, nil} | s], out)
      l.v != -1 and r.v != -1 -> inorder(l, [{v, r} | s], out)
    end
  end

  defp inorder(%{v: v, l: l, r: r} = _tree, s, out, {:r, :d}) do
    cond do
      l.v == -1 and r.v == -1 -> inorder(r, s, [v | out], {:r, :u})
      l.v == -1 and r.v != -1 -> inorder(r, s, [v | out], {:r, :d})
      l.v != -1 and r.v == -1 -> inorder(l, [{v, nil} | s], out)
      l.v != -1 and r.v != -1 -> inorder(l, [{v, r} | s], out)
    end
  end

  defp inorder(_, [], out, {_, :u}), do: out |> Enum.reverse()

  defp inorder(_tree, s, out, {_, :u}) do
    {v, r_node} = s |> hd

    if r_node != nil do
      inorder(r_node, s |> tl, [v | out], {:r, :d})
    else
      inorder(r_node, s |> tl, [v | out], {:l, :u})
    end
  end

  # recursively parse nodes data from top down, in a single pass
  # to determine the total depth and the actual number of
  # nodes per depth level
  @doc false
  @spec tree_data(list) :: {integer, list[integer]}
  def tree_data(nodes_data) do
    node_count = 1
    depth = 1
    info = [node_count]
    tree_data(nodes_data, info, node_count, depth)
  end

  @doc false
  def tree_data([], info, _, depth), do: {depth, info |> tl}

  def tree_data(nodes_data, info, count, depth) do
    nodes = nodes_data |> Enum.take(count)
    remaining_nodes = nodes_data |> Enum.drop(count)

    # count nodes, omitting any terminated nodes
    new_count =
      nodes
      |> List.flatten()
      |> Enum.filter(&(&1 != -1))
      |> length

    tree_data(remaining_nodes, [new_count | info], new_count, depth + 1)
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
  @doc false
  def build_tree(_, [[l, r]], []), do: %{v: 1, l: l, r: r}

  def build_tree(data, children, [c | count]) do
    nodes = data |> Enum.take(0 - c)
    remaining_nodes = data |> Enum.drop(0 - c)

    parent = build_nodes(nodes, [])
    new_children = merge_tree(parent |> List.flatten(), children, [])

    build_tree(remaining_nodes, new_children, count)
  end

  @doc false
  def build_nodes([], nodes), do: nodes |> Enum.reverse()

  def build_nodes([[l, r] | y], nodes) do
    build_nodes(y, [[n(l), n(r)] | nodes])
  end

  @doc false
  def merge_tree([], _, tree), do: tree |> Enum.reverse() |> Enum.chunk_every(2)

  def merge_tree([x | nodes], children, tree) when is_list(nodes) do
    {y, remaining_children} = merge_tree(x, children)
    merge_tree(nodes, remaining_children, [y | tree])
  end

  @doc false
  def merge_tree(%{l: nil, r: nil, v: -1} = node, children), do: {node, children}

  def merge_tree(%{l: nil, r: nil, v: v} = _, children) do
    [l, r] = children |> hd
    {%{l: l, r: r, v: v}, children |> tl}
  end

  # return levels in 1k,2k,3k.. for a given first swap 'k' level
  defp depth_series(k, nth, [l | levels], depth) when l < depth - 1 do
    x = [l | levels]
    depth_series(k, nth + 1, [(nth + 1) * k | x], depth)
  end

  defp depth_series(_k, _nth, levels, depth), do: levels |> Enum.reject(&(&1 > depth - 1))

  # ==============================================================================================
  @doc """
  Matrix rotation

  https://www.hackerrank.com/challenges/matrix-rotation/problem
  """
  @spec rotate(list, integer) :: list
  def rotate(matrix, times) do
    {deconstructed, dim} = deconstruct(matrix)

    shift(deconstructed, times)
    |> reconstruct([], dim)
  end

  @doc false
  def deconstruct(matrix) do
    new_matrix = []
    dim = []
    deconstruct(matrix, new_matrix, dim)
  end

  @doc false
  def deconstruct([], new_matrix, dim), do: {new_matrix, dim}

  def deconstruct([top | y], new_matrix, dim) do
    {bottom, rest1} = List.pop_at(y, -1)
    [left | rest2] = if rest1 != [], do: rest1 |> List.zip(), else: [{} | []]
    {right, rest3} = if rest2 != [], do: List.pop_at(rest2, -1), else: {{}, []}

    circular =
      [top | [right |> Tuple.to_list() | [bottom |> Enum.reverse() | left |> Tuple.to_list() |> Enum.reverse()]]]
      |> List.flatten()

    m = 2 + (left |> Tuple.to_list() |> length)
    n = top |> length

    if rest3 != [] do
      rest = rest3 |> List.zip() |> Enum.map(&Tuple.to_list(&1))
      deconstruct(rest, [circular | new_matrix], [{m, n} | dim])
    else
      deconstruct([], [circular | new_matrix], [{m, n} | dim])
    end
  end

  @doc false
  def reconstruct([], new_matrix, _), do: new_matrix

  def reconstruct([r | matrix], new_matrix, [{m, n} | dim]) do
    top = r |> Enum.take(n)
    rest1 = r |> Enum.drop(n)

    # omitting top and bottom rows
    left_m = m - 2
    left = rest1 |> Enum.take(0 - left_m) |> Enum.reverse()
    rest2 = rest1 |> Enum.drop(0 - left_m)

    bottom = rest2 |> Enum.take(0 - n) |> Enum.reverse()
    right = rest2 |> Enum.drop(0 - n)

    x = new_matrix |> List.zip() |> Enum.map(&Tuple.to_list(&1))
    y = ([left] ++ x ++ [right]) |> List.zip() |> Enum.map(&Tuple.to_list(&1))
    z = [top] ++ y ++ [bottom]

    reconstruct(matrix, z, dim)
  end

  @doc false
  def shift(matrix, times) do
    m =
      for row <- matrix do
        row_size = length(row)
        n = rem(times, row_size)

        x = row |> Enum.take(n)
        y = row |> Enum.drop(n)
        y ++ x
      end

    m
  end

  # ==============================================================================================
  @doc """
  Substring searching by KMP algorithm

  https://www.hackerrank.com/challenges/kmp-fp/problem
  """
  @spec kmp_string_search(binary, binary) :: binary
  def kmp_string_search(string, pattern) when is_binary(string) and is_binary(pattern) do
    string_search(string, pattern, pattern)
  end

  @spec kmp_string_search(list, list) :: binary
  def kmp_string_search(string, pattern) when is_list(string) and is_list(pattern) do
    string_search(string, pattern, pattern)
  end

  @doc false
  def string_search(string, subpattern, pattern, match \\ false)
  def string_search(_, _, _, true), do: "YES"
  def string_search([], _, _, false), do: "NO"
  def string_search("", _, _, false), do: "NO"

  def string_search(s, sp, p, _match) do
    m = 0
    n = 0
    # partial match table
    p_table = {sp, m, n}

    {m, n, matched?} = _string_search(s, sp, p_table)

    case {matched?, is_list(s)} do
      {true, _} ->
        # all chars matched
        string_search(s, sp, p, true)

      {false, false} ->
        <<_::binary-size(m), r_s::binary>> = s
        <<_::binary-size(n), r_p::binary>> = sp

        # full scan after a partial scan failed
        x = if m == 1 and n == 0, do: p, else: r_p
        # keep scanning
        string_search(r_s, x, p, false)

      {false, true} ->
        # drop already scanned chars
        r_s = Enum.drop(s, m)
        # also drop partially matched substring
        r_p = Enum.drop(sp, n)

        # full scan after a partial scan failed
        x = if m == 1 and n == 0, do: p, else: r_p
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

  defp _string_search(<<x::utf8, y::binary>>, <<i::utf8, j::binary>>, {p, m, n}, _matched?) do
    a = :binary.at(p, n)
    _string_search(a, {x, y}, {i, j}, {p, m, n})
  end

  defp _string_search([x | y], [i | j], {p, m, n}, _matched?) do
    a = Enum.at(p, n)
    _string_search(a, {x, y}, {i, j}, {p, m, n})
  end

  defp _string_search(a, {x, y}, {i, j}, {p, m, n}) do
    cond do
      x == i and m == 0 ->
        _string_search(y, j, {p, m + 1, n}, true)

      x == i and x != a ->
        _string_search(y, j, {p, m + 1, n}, true)

      x == i and x == a ->
        _string_search(y, j, {p, m + 1, n + 1}, true)

      x != i and x == a and m == 0 ->
        _string_search(y, j, {p, m + 1, n + 1}, false)

      x != i and x != a and m == 0 ->
        _string_search(y, j, {p, m + 1, n}, false)

      x != i and x == a ->
        _string_search(y, j, {p, m, n}, false)

      x != i and x != a and n == 0 ->
        _string_search(y, j, {p, m + 1, n}, false)

      true ->
        _string_search(y, j, {p, m, n}, false)
    end
  end

  # ==============================================================================================
  @doc """
  John and fences 1

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
  #
  # Note: this algorithim scans the entire fence (N) per height
  # and works for fence up to 50,000.
  # For the larger size fences (100,000), it takes 14s.
  # The latter HackerRank test cases requires a faster algorithm 
  # - see below

  @spec max_rect(list(integer)) :: integer
  def max_rect(heights) do
    # find the max of max rectangles for all heights
    Enum.uniq(heights)
    # |> Enum.map(&(max_rect(heights, &1))) # for smaller fences
    |> Enum.map(&_max_rect(heights, &1))
    |> Enum.max()
  end

  # find max rectangular at a given height of a fence with irregular heights
  @doc false
  def max_rect(heights, height) do
    heights
    |> fence_spans(height)
    |> max_span
    |> Kernel.*(height)
  end

  # find the max contiguous span from a binary list of fence spans
  @doc false
  def max_span(spans, current \\ 0, max \\ 0)
  def max_span([], current, max), do: if(current > max, do: current, else: max)

  def max_span([x | y], current, max) do
    cond do
      x == 0 and current > max ->
        max_span(y, 0, current)

      x == 0 and current <= max ->
        max_span(y, 0, max)

      x == 1 ->
        max_span(y, current + 1, max)
    end
  end

  # find contiguous fence spans that achieve at least a given height
  @doc false
  def fence_spans(heights, height \\ 0, spans \\ [])
  def fence_spans([], _, spans), do: spans |> Enum.reverse()
  def fence_spans([x | y], height, spans) when x >= height, do: fence_spans(y, height, [1 | spans])
  def fence_spans([x | y], height, spans) when x < height, do: fence_spans(y, height, [0 | spans])

  # time-performant / integrated function that combine fence_spans and max_span functions
  # fast enough for 50,000 size fence
  defp _max_rect(heights, height, current \\ 0, max \\ 0)
  defp _max_rect([], _height, current, max), do: if(current > max, do: current, else: max)

  defp _max_rect([x | y], height, current, max) when x >= height do
    area = height + current

    if area > max do
      _max_rect(y, height, area, area)
    else
      _max_rect(y, height, area, max)
    end
  end

  defp _max_rect([x | y], height, current, max) when x < height do
    if current > max do
      _max_rect(y, height, 0, current)
    else
      _max_rect(y, height, 0, max)
    end
  end

  # ==============================================================================================
  @doc """
  John and fences 2 - more time-performant

  https://www.hackerrank.com/challenges/john-and-fences/problem
  """

  # Compared to the previous algorithm, this still scans and finds
  # the max areas for all heights, from which a max can be determined.
  # However this does so by divide-and-conquer algorithm that
  # progressively divides N into smaller chunks, so the scans are not
  # always N in size and therefore much more time-performant.
  #
  # this algorithm finds the max rectangle of
  # the HackerRank 100,000 size test cases in seconds

  @spec max_rect_divide(list(integer), integer) :: integer
  def max_rect_divide(heights, n) do
    index = 1..n
    # create a tuple list containing index
    x = Enum.zip(heights, index)

    areas = []
    max_rect_divide(x, 1, n, areas) |> Enum.max()
  end

  # divide-conquer approach to compute all max areas
  # TODO: find and return the current max area in situ 
  # instead of accumulating all max areas 
  # for the single "Enum.max" op above
  @doc false
  def max_rect_divide(heights, x1, x2, areas) do
    {height, min_index} = Enum.min(heights)

    # calculate max area (for particular height) 
    # using the previously
    # developed max/fence span function (above)
    # "heights" N size is progressively smaller
    # because of divide-conquer algorithm
    area = max_rect(heights, height)

    # subdivide N into two halves
    {left, right} = Enum.split_with(heights, fn {_, i} -> i <= min_index end)

    # recursively find max area on the left
    area_left =
      if(min_index > x1) do
        max_rect_divide(left |> Enum.drop(-1), x1, min_index - 1, areas)
      end

    # recursively find max area on the right
    area_right =
      if min_index < x2 do
        max_rect_divide(right, min_index + 1, x2, areas)
      end

    [area_right | [area_left | [area | areas]]] |> List.flatten() |> Enum.reject(&is_nil/1)
  end

  # ==============================================================================================
  @doc """
  Order exercises (advanced) - find multiple maximum subarray sums given an array

  https://www.hackerrank.com/challenges/order-exercises/problem
  """
  # Find multiple maximum subarray sums using Kadane and divide-conquer algorithm
  @spec max_subarray_sums(list(integer), integer, integer) :: list(integer)
  def max_subarray_sums(a, n, k) do
    index = 0..(n - 1)

    # create a tuple sequence containing index
    Enum.zip(a, index)
    |> max_subarray_sums([])
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(k)
  end

  @doc false
  def max_subarray_sums(a, maxes) do
    {span, max} = kadane_max(a)

    # obtain the remaining arrays via partitioning
    # using the span information
    {x, y} = span
    {left, _} = Enum.split_with(a, fn {_, i} -> i < x end)
    {_, right} = Enum.split_with(a, fn {_, i} -> i <= y end)

    left_maxes = if left != [] and max != 0, do: max_subarray_sums(left, maxes)
    right_maxes = if right != [] and max != 0, do: max_subarray_sums(right, maxes)

    [right_maxes | [left_maxes | [max | maxes]]] |> List.flatten() |> Enum.reject(&(&1 == 0 or &1 == nil))
  end

  # Kadane's algorithm for finding the largest possible max subarray sum - 0(N)
  # using tail recursion. The array input now zipped with indexes
  # so that the index span of the subarray can be determined
  @doc false
  @spec kadane_max(list(tuple), {integer, integer}, integer, integer, integer) :: {tuple, integer}
  def kadane_max(array, span \\ {0, 0}, start \\ -1, current_max \\ 0, max \\ 0)

  def kadane_max([], span, _, _, max), do: {span, max}

  def kadane_max([head | tail], {i, j}, start, current_max, max) do
    {value, current_index} = head
    x = current_max + value

    # 'start1' logs the start of a negative / minima
    # y is the updated current max
    # z is the updated max
    # `span` corresponds to the indexes of max subarray
    {start1, y} = if x > 0, do: {start, x}, else: {current_index, 0}
    {span, z} = if y > max, do: {{start + 1, current_index}, y}, else: {{i, j}, max}

    kadane_max(tail, span, start1, y, z)
  end

  # ==============================================================================================
  @doc """
  Range minimum query - find multiple subarrays minimums

  https://www.hackerrank.com/challenges/range-minimum-query/problem
  """
  @spec min_query_tree(list(integer), integer, list(tuple)) :: list
  def min_query_tree(a, n, queries) do
    tree = segment_tree(a, n)

    for q <- queries do
      # n - 1 -> 0-based index
      query_tree(tree, {0, n - 1}, q)
    end
  end

  # construct a map-based segment tree for the array
  @doc false
  @spec segment_tree(list, integer, map, integer) :: map
  def segment_tree(a, n, tree \\ %{}, index \\ 0)

  def segment_tree(a, n, tree, i) do
    mid_point = round(n / 2)

    min = Enum.min(a)

    {l, r} = a |> Enum.split(mid_point)
    l_n = mid_point
    r_n = length(r)

    # use the following formulas for child indices
    # left child index = i * 2 + 1
    # right child index = i * 2 + 2
    x =
      cond do
        length(a) == 1 ->
          Map.put(tree, i, min)

        l_n != 0 and r_n != 0 ->
          l_map = segment_tree(l, l_n, tree, i * 2 + 1)
          r_map = segment_tree(r, r_n, tree, i * 2 + 2)
          Map.merge(l_map, r_map)

        l_n != 0 ->
          segment_tree(l, l_n, tree, i * 2 + 1)

        r_n != 0 ->
          segment_tree(r, r_n, tree, i * 2 + 2)
      end

    Map.put(tree, i, min) |> Map.merge(x)
  end

  # define custom guards for determining whether the
  # current segment tree node is within range
  # of the query or not
  @doc false
  defguard in_range(range, query)
           when elem(query, 0) <= elem(range, 0) and elem(query, 1) >= elem(range, 1)

  @doc false
  defguard not_in_range(range, query)
           when elem(query, 0) > elem(range, 1) or elem(query, 1) < elem(range, 0)

  @doc false
  def query_tree(tree, range \\ {0, 0}, query \\ {0, 0}, index \\ 0)
  def query_tree(tree, r, q, i) when in_range(r, q), do: tree[i]
  def query_tree(_, r, q, _) when not_in_range(r, q), do: :max

  def query_tree(tree, r, q, i) do
    mid_point = (elem(r, 0) + :math.floor((elem(r, 1) - elem(r, 0)) / 2)) |> round

    x = query_tree(tree, {elem(r, 0), mid_point}, q, i * 2 + 1)
    y = query_tree(tree, {mid_point + 1, elem(r, 1)}, q, i * 2 + 2)
    min(x, y)
  end

  # below is a basic or straight forward range minimum query algorithm
  # that won't pass all test cases
  @doc false
  @spec min_query(list(integer), list(tuple)) :: list
  def min_query(a, queries) do
    n = length(a)
    index = 0..(n - 1)

    # a tuple sequence list with indices
    Enum.zip(a, index)
    |> _min_query(queries, [])
  end

  # basic or straight forward range minimum query algorithm
  defp _min_query(a, queries, minimums)
  defp _min_query(_, [], minimums), do: minimums |> Enum.reverse()

  defp _min_query(a, [x | y], minimums) do
    min = _min_query(a, x)
    _min_query(a, y, [min | minimums])
  end

  defp _min_query(a, {i1, i2}) when is_list(a) do
    {_, right} = Enum.split_with(a, fn {_, i} -> i < i1 end)
    {left, _} = Enum.split_with(right, fn {_, i} -> i <= i2 end)

    left |> Enum.min() |> elem(0)
  end
end

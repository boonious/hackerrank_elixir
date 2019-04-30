defmodule FP.Recursion.Advanced do
  @moduledoc """
  Elixir solutions for advanced HackerRank functional programming challenges: recursions.
  """

  @doc """
  Functions and fractals: Sierpinski triangle

  https://www.hackerrank.com/challenges/functions-and-fractals-sierpinski-triangles/proble
  """
  @spec draw_triangles(integer) :: list
  def draw_triangles(iterations) do
    rows = 32
    cols = 63

    bound_left = fn y -> y end
    bound_right = fn y -> 2*rows - y end

    # draw first triangle
    canvas = for x <- 1..cols, y <- 1..rows, into: %{} do
      pt = {x, y}
      char = if x >= bound_left.(y) and x <= bound_right.(y), do: "1", else: "_"
      {pt, char}
    end

    vertex = [{32,32}]
    # fractalisation via recursion and update canvas
    canvas = fractal(vertex, iterations, rows, cols, canvas)
    output = for y <- rows..1, into: [] do
      line = for x <- 1..cols, into: "" do
        pt = {x, y}
        canvas[pt]
      end
      line
    end
    output
  end

  defp fractal(_vertices, 0, _rows, _cols, canvas), do: canvas
  defp fractal(vertices, iterations, rows, cols, canvas) do
    v = vertices |> Enum.map(&spawn_vertices(&1,rows))
    update_vertices = v |> Enum.map(&(&1 |> hd))
    updated_canvases = update_vertices |> Enum.map(&update(&1, round(rows/2), round(cols/2)-1, %{}))
    new_canvas = updated_canvases |> Enum.reduce(canvas, fn x, acc -> Map.merge(acc, x) end)

    fractal(v |> List.flatten, iterations - 1, rows / 2, cols / 2, new_canvas)
  end

  defp spawn_vertices(v, rows) do
    v1 = {round(elem(v,0) - rows/2), round(elem(v,1) - rows/2)}
    v2 = {round(elem(v,0) + rows/2), round(elem(v,1) - rows/2)}
    [v1,v2,v]
  end

  defp update({_x, _y}, 0, _cols, flipped_canvas), do: flipped_canvas
  defp update({x, y}, rows, cols, flipped_canvas) do
    flipped_line = for i <- 1..cols, into: %{} do
      pt = {x + i, y}
      {pt, "_"}
    end

    update({x+1, y-1}, rows-1, cols-2, Map.merge(flipped_canvas, flipped_line))
  end

  #==============================================================
  @doc """
  Functions and Fractals - Recursive Trees

  https://www.hackerrank.com/challenges/fractal-trees/problem
  """
  @spec draw_trees(integer) :: list
  def draw_trees(iterations) do
    rows = 63
    cols = 100

    # initiailise a Map canvas
    canvas = for x <- 1..cols, y <- 1..rows, into: %{} do
      pt = {x, y}
      {pt, "_"}
    end

    root = [{50,0}]
    height = 16

    # fractalisation via recursion and update canvas
    canvas = fractal_tree(root, iterations, height, canvas)

    output = for y <- rows..1, into: [] do
      line = for x <- 1..cols, into: "" do
        pt = {x, y}
        canvas[pt]
      end
      line
    end
    output
  end

  defp fractal_tree(_roots, 0, _height, canvas), do: canvas
  defp fractal_tree(roots, iterations, height, canvas) when is_list(roots) do
    trees = roots
    |> Enum.map(&fractal_tree(&1, height))
    |> Enum.reduce(fn x, acc -> Map.merge(acc, x) end)

    # get the tree top height of tree branches
    # use it to find the branch tips to use as
    # roots to grow tree in the next iteration
    new_height = trees |> Map.keys |> Enum.max_by(&(elem(&1,1))) |> elem(1) # tree top height
    new_roots = trees |> Map.keys |> Enum.filter(&( elem(&1,1) == new_height) ) # branch tips

    fractal_tree(new_roots, iterations - 1, round(height / 2), Map.merge(canvas, trees))
  end

  # drawing the tree from a root coordinate
  # (trunk, branches) and return tree canvas map data
  defp fractal_tree({x, y}, height) do
    # grow trunk
    trunk = for i <- 0..height, into: %{} do
      pt = {x, y + i}
      {pt, "1"}
    end
    trunk_tip = trunk |> Map.keys |> Enum.max_by(&(elem(&1,1)))

    # grow branches
    {a,b} = trunk_tip
    left_branch = for i <- 0..height, into: %{} do
      pt = {a - i, b + i}
      {pt, "1"}
    end
    right_branch = for i <- 0..height, into: %{} do
      pt = {a + i, b + i}
      {pt, "1"}
    end

    tree = Map.merge(trunk, left_branch) |> Map.merge(right_branch)
    tree
  end


  #==============================================================
  @doc """
  Convex hull

  https://www.hackerrank.com/challenges/convex-hull-fp/problem

  Find the perimeter of a convex hull from a series of coordinates,
  opted to implement Graham's scan algorithm.
  https://en.wikipedia.org/wiki/Graham_scan
  """
  @spec convex_hull_perimeter(list(tuple)) :: number
  def convex_hull_perimeter(points), do: graham_scan(points) |> perimeter

  #==============================================================
  @doc """
  Graham Scan - find points of a convex hull from a series of coordinates

  See https://en.wikipedia.org/wiki/Graham_scan

  For https://www.hackerrank.com/challenges/convex-hull-fp/problem
  """
  @spec graham_scan(list(tuple)) :: list(tuple)
  def graham_scan(points) do
    # find the lowest y
    {_, y0} = points |> Enum.min_by(fn {_x, y} -> y end)

    # use y0 to find the lowest leftmost point
    p0 = points |> Enum.filter(fn {_x,y} -> y == y0 end) |> Enum.min_by(fn {x,_y} -> x end)

    [p1 | x] = points
    |> List.delete(p0)
    |> Enum.group_by(fn{x,y} -> polar_angle({x,y}, p0) end)
    |> Enum.sort_by(fn {angle, _pts} ->  angle end)
    |> Enum.map(fn {_angle, pts} -> Enum.max_by(pts, fn pt -> _perimeter(p0,pt) end) end)

    convex_hull = graham_scan(x, [p1,p0])
    # prepending list for efficiency purpose
    [p0 | convex_hull] |> Enum.reverse
  end

  @doc false
  def graham_scan([], convex_hull), do: convex_hull
  def graham_scan([i|j], convex_hull) do
    [p1, p0] = convex_hull |> Enum.take(2)
    p2 = i

    # cross product measure which finds if 3 points
    # is forming left or right turn, or collinear (z=0)
    # the measure if then used to discard points not
    # on convex based Graham scan algorithm
    z = counter_clockwise?(p0,p1,p2)
    cond do
      z == 0 ->
        if which_further?(p0,p1,p2) == 1, do: graham_scan(j, [p1|convex_hull]), else: graham_scan(j, [p2|convex_hull])
      z > 0 ->
        graham_scan(j, [p2|convex_hull]) # ccw, add point to convex hull
      z < 0 ->
        # anti-clockwise, remove point and
        # redo checks of p2/i in the next interation,
        # i.e. reset/don't move ahead yet in sequence evaluation
        graham_scan([i|j], tl(convex_hull))
    end
  end

  # cross vector product to determine whether 3 points does a left turn
  # see:   https://en.wikipedia.org/wiki/Graham_scan
  @doc false
  def counter_clockwise?({x0,y0},{x1,y1},{x2,y2}), do: (x1-x0)*(y2-y0)-(y1-y0)*(x2-x0)

  # select further collinear point
  @doc false
  def which_further?({x0,y0},{x1,y1},{x2,y2}) do
    d1 = _perimeter({x0,y0}, {x1,y1})
    d2 = _perimeter({x0,y0}, {x2,y2})
    if d1 > d2, do: 1, else: 2
  end

  defp polar_angle({x,y},{x0,y0}), do: :math.atan2(y - y0,x - x0)

  # recursively compute perimeter, when "coordinates"
  # referred from previous polygon perimeter challenge
  @doc false
  def perimeter(coordinates), do: _perimeter(coordinates)

  defp _perimeter(coordinates, distance \\ 0.0)
  defp _perimeter(coordinates, distance) when length(coordinates) == 1, do: distance |> Float.round(1)
  defp _perimeter([p1 | coordinates], distance) do
    p2 = coordinates |> hd
    _perimeter(coordinates, distance + _perimeter(p1, p2))
  end

  defp _perimeter({x1,y1}, {x2,y2}), do: :math.sqrt(:math.pow(y2-y1, 2) + :math.pow(x2-x1, 2))


  #========================================================================================
  @doc """
  Crosswords-101

  https://www.hackerrank.com/challenges/crosswords-101/problem
  """
  @type sequences :: [tuple]
  @type solution :: [{char, tuple}]

  @spec cross_words(list, list) :: list
  def cross_words(grid, words) do
    sequences = parse(grid)
    %{down: fit(sequences.down, words), across: fit(sequences.across, words)}
    |> disambiguate
    |> render
  end

  # disambiguate plausible fits in a sequence by checking crossed char from the other words
  @doc false
  @spec disambiguate(%{across: [solution], down: [solution] }) :: [solution]
  def disambiguate(%{across: across, down: down} = _) do
    x = disambiguate(down, [], across |> Enum.reduce([], fn x, acc -> acc ++ x end))
    y = disambiguate(across, [], down |> Enum.reduce([], fn x, acc -> acc ++ x end))
    x ++ y
  end

  @doc false
  def disambiguate([], disambiguated, _), do: disambiguated
  def disambiguate([x|y], d, cross_ref) when length(x) == 1, do: disambiguate(y, [x|d], cross_ref) # unique fit not requiring disambiguation
  def disambiguate([x|y], d, cross_ref) do
    z = Enum.map(x, &(check(&1, cross_ref))) 
    |> Enum.max
    |> elem(1)

    disambiguate(y, [[z]|d], cross_ref)
  end

  # find the word that has char matches from words of the other orientation
  defp check(word, cross_ref, match_count \\ 0)
  defp check(word, [], count), do: {count, word}
  defp check(word, [y|cross_ref], count) do
    cross_char = MapSet.intersection(MapSet.new(word), MapSet.new(y))
    |> MapSet.to_list

    if cross_char != [], do: check(word, cross_ref, count + 1), else: check(word, cross_ref, count)
  end

  @doc false
  @spec fit([sequences], [binary], []) :: [solution]
  def fit(sequences, words, solution \\ [])
  def fit([], _, solution), do: solution
  def fit([x|sequences], words, solution) do
    # find words that fit into the cells by length
    fitting_words = _fit(x, words)

    # format solution in as a series of {char, {x,y}}
    # for cross checking and disambiguation
    words_w_coords = Enum.map(fitting_words, &(Enum.zip(&1, x)))
    fit(sequences, words, [words_w_coords|solution])
  end

  defp _fit(coords, words) do
    words |> Enum.filter(&(String.length(&1) == length(coords))) |> Enum.map(&(String.split(&1, "", trim: true)))
  end

  # parse list of "+", "-" string grid rows
  # into a raw coordinate system of fit-able cells ("-")
  @doc false
  @spec parse(list(binary)) :: list
  def parse(grid), do: %{across: parse(grid, :across)} |> Map.merge(%{down: parse(grid, :down)})

  @doc false
  def parse([x|y], :across) when is_bitstring(x) do
    [x|y]
    |> Enum.map(&String.split(&1,"", trim: true))
    |> _parse(:across)
  end

  def parse([x|y], :down) when is_bitstring(x) do
    [x|y]
    |> Enum.map(&String.split(&1,"", trim: true))
    |> List.zip |> Enum.map(&Tuple.to_list(&1))
    |> _parse(:down)
  end

  defp _parse(grid, direction) do
    grid
    |> _parse(1, [], direction)
    |> tokenise([])
    |> Enum.map(&(filter_sequences(&1)))
    |> Enum.reject(&(&1 == []))
    |> Enum.reduce([], fn x, acc -> acc ++ x end)
  end

  defp _parse([], _, grid, _), do: grid |> Enum.reverse
  defp _parse([row|rows], row_no, grid, direction) do
    coordinates = _parse(row, row_no, 1, [], direction)
    _parse(rows, row_no + 1, [coordinates|grid], direction)
  end

  defp _parse([], _, _, coordinates, _), do: coordinates |> Enum.reverse
  defp _parse(["-"|y], row_no, col_no, coordinates, :across), do: _parse(y, row_no, col_no + 1, [{col_no,row_no}|coordinates], :across)
  defp _parse(["-"|y], row_no, col_no, coordinates, :down), do: _parse(y, row_no, col_no + 1, [{row_no,col_no}|coordinates], :down)
  defp _parse(["+"|y], row_no, col_no, coordinates, direction), do: _parse(y, row_no, col_no + 1, coordinates, direction)

  defp filter_sequences(seqs), do: seqs |> Enum.filter(&(length(&1) > 1))

  defp is_sequence?({x1,y1},{x2,y2}) do
    if (x2 - x1 == 1) or (y2 - y1 == 1), do: true, else: false
  end

  defp tokenise([], grid_sequences), do: grid_sequences |> Enum.reverse
  defp tokenise([row|rows], grid_sequences) do
    row_seq = if row == [], do: [[]], else: tokenise(row, [row |> hd], [])
    tokenise(rows, [row_seq | grid_sequences])
  end

  # tokenise each row into cell sequences, some of the
  # spurious single-cell sequences due to the other word orientation (across vs. down)
  # can be filtered out subsequently, leaving out valid cell sequences for fitting later
  defp tokenise([], _, row_sequences), do: row_sequences
  defp tokenise([_|y], sequence, sequences) when y == [], do: [(sequence |> Enum.reverse) | sequences] |> Enum.reverse
  defp tokenise([x|y], sequence, sequences) do
    z = y |> hd
    if is_sequence?(x,z) do
      tokenise(y, [z|sequence], sequences)
    else
      tokenise(y, [z], [(sequence |> Enum.reverse) | sequences])
    end
  end

  @doc false
  def render(solution) do
    coord_char_map = solution |> List.flatten |> Enum.into(%{}, fn {x, {y,z}} -> {{y,z}, x} end)
    output = for y <- 1..10 do
      for x <- 1..10 do
       if coord_char_map[{x,y}], do: coord_char_map[{x,y}], else: "+"
      end
    end

    output |> Enum.map(&(Enum.join(&1)))
  end

  #========================================================================================
  @doc """
  Super digit

  https://www.hackerrank.com/challenges/super-digit/problem
  """
  # a scalable solution by duplicate the individual digit sums
  # then sum them up for another round of digit sum process
  # instead of concatenating huge numbers
  @spec super_digit(integer, integer) :: integer
  def super_digit(n, k) when is_number(n) do
    # break an extremely large number
    y = n
    |> Integer.to_string
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> digit_sum

    y
    |> List.duplicate(k)
    |> digit_sum
  end

  @doc false
  def digit_sum(n) when is_number(n) and n < 10, do: n
  def digit_sum(n) when is_number(n) do
    Integer.digits(n) |> digit_sum
  end

  def digit_sum(n) do
    digit_sum(Enum.sum(n))
  end


  #========================================================================================
  @doc """
  Super queens on a chessboard

  https://www.hackerrank.com/challenges/super-queens-on-a-chessboard/problem
  """
  # From the sample test case, the candidate placements are pairs in mirroring positions that
  # are not in the same or diagonal lines (need to check l-shape later). This makes sense as
  # such placement maximise non-conflicting area for more potential super-queen placement.
  #
  # Begin tackling the challenge by identifying such candidate placement pairs
  # algorithm:
  def super_queen(n) do
    super_queen_pairs(n)
  end

  # find opposing quuen pairs that are furthest part, mirroring,
  # not in the conflict with each others (on the same or diagonal lines)
  def super_queen_pairs(n) do
    pairs = for x <- 0..n-1, y <- 0..n-1, x < (n-1-x) do
      {x1, y1} = {n-1-x, n-1-y}

      cond do
        (y1 - y) == 0 or (x1 - x) == 0 -> nil # on the same lines
        (y1-y)/(x1-x) == 1 or (y1-y)/(x1-x) == -1 -> nil # on diagonal lines
        true -> [{x,y},{x1, y1}]
      end
    end

    pairs 
    |> Enum.filter(&(&1 != nil))
  end

  def super_queen_power_zone(q1, q2, n) do
    # p -> power positions, np -> non power / available positions
    {p1, np1} = super_queen_power_zone(q1, n)
    {p2, np2} = super_queen_power_zone(q2, n)

    p_set = MapSet.union(MapSet.new(p1), MapSet.new(p2))
    np_set = MapSet.union(MapSet.new(np1), MapSet.new(np2))
    |> MapSet.difference(p_set)

    p = p_set
    |> MapSet.to_list
    |> Enum.sort

    np = np_set
    |> MapSet.to_list
    |> Enum.sort

    {p, np}
  end

  def super_queen_power_zone({i,j}, n) do
    {c1, c2} = {j-i, j+i} # y-intercepts, diagonal lines crosss at x = 0

    p_zone = for x <- 0..n-1, y <- 0..n-1 do
      power = cond do
        x == i or y == j -> 1 # row, column zones
        y == (x+c1) or y == (-x+c2) -> 1 # diagonal zones
        plus_minus_n?(i,x,2) and plus_minus_n?(j,y,1) -> 1 # l-shape, horizontal
        plus_minus_n?(i,x,1) and plus_minus_n?(j,y,2) -> 1 # l-shape, vertical
        true -> 0 # non-power, available slot
      end

      { {x,y}, power }
    end

    # group into power, non-power zones
    {p, np} = p_zone
    |> Enum.split_with( fn{_pos, power} -> power == 1 end )

    # return only the coordinates in 2 ("power", "non-power/available") lists
    {p |> Enum.map(&elem(&1, 0)), np |> Enum.map(&elem(&1, 0))}
  end

  defp plus_minus_n?(x0, x1, n) do
    ((x0 - x1) |> abs) == n
  end

end
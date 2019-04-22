defmodule Algo.Imp do
  @moduledoc """
  Elixir solutions for HackerRank algorithm challenges: implementation.
  """

  #==========================================================================
  @doc """
  Repeated string

  https://www.hackerrank.com/challenges/repeated-string/problem
  """
  @spec repeated_string(binary, integer) :: integer
  def repeated_string(str, length) do
    len = String.length str
    times_repeated = div(length, len)

    len_remaining = rem(length, len)
    y = String.split(str, "", trim: true)
    |> Enum.take(len_remaining)
    |> Enum.join("")

    (Regex.scan(~r/a/, str) |> length)*times_repeated + (Regex.scan(~r/a/, y) |> length)
  end

  #==========================================================================
  @doc """
  Kangaroo 
  
  Determine if jump distance to be equal eventually from different starting points
  and hop velocity.

  https://www.hackerrank.com/challenges/repeated-string/problem
  """

  # jump distance = starting + no_of_jump * hop_distance
  # i.e. solving x1 + y*v1 = x2 + y*v2
  # y = (x1 - x2) / (v2 - v1)
  # y needs to be positive integer

  @spec f(list(integer)) :: boolean
  # guard for division over 0
  def f([x1, v1, x2, v2]) when v1 == v2, do: if x1 == x2, do: true, else: false
  def f([x1, v1, x2, v2]) do
    y = ((x1 - x2) / (v2 - v1))

    # get decimal points, jumps can't coincide "mid air"
    # i.e. y needs to integer, e.g 4.0, not 4.22
    [_, z] = y
    |> Float.to_string
    |> String.split(".")

    if y >= 0 and z == "0", do: true, else: false
  end

  #==========================================================================
  @doc """
  Divisible sum pairs

  https://www.hackerrank.com/challenges/divisible-sum-pairs/problem
  """
  @spec divisible_sum_pairs(list(integer), integer) :: integer
  def divisible_sum_pairs(a, k) do
    divisible_sum_pairs(a, a |> tl, k, 0)
  end

  @doc false
  def divisible_sum_pairs([], _, _, count), do: count
  def divisible_sum_pairs([x|y], b, k, count) do
    sums = for a <- b do
      a+x
    end
    c = sums |> Enum.filter(&(rem(&1, k) == 0)) |> length
    divisible_sum_pairs(y, b |> Enum.drop(1), k, count + c)
  end

  #==========================================================================
  @doc """
  The grid search - find 2D subarray within a grid array

  https://www.hackerrank.com/challenges/the-grid-search/problem
  """

  # Algorithm: first scan the grid, identify a match for first line of pattern (2D array)
  # return false (no match) if none found. Otherwise, scan the next
  # few lines using offset and row num data determined from the first scan
  # to identify a complete match for the remaining of 2D pattern array.
  #
  # Use binary string matching for performance.

  # main function
  @spec grid_search(list(binary), list(binary), integer) :: boolean
  def grid_search(g, p, str_len) when is_list(p) do
    p0 = p |> hd
    candidates = grid_search(g, p0) # a list of start positions of potential matches

    # send to a recursive function to determine match for all candidates
    if candidates == [], do: false, else:  _grid_search(candidates, g, p, str_len)
  end

  # recursively check all candidates
  defp _grid_search(candidates, grid, pattern, str_len, match \\ false)  
  defp _grid_search(_, _, _, _, true), do: true  
  defp _grid_search([], _, _, _, _), do: false # all candidates checked without a positive outcome

  defp _grid_search([{offset, row} | c], g, p, n, m) do
    g_rest = g |> Enum.drop(row)
    p_rest = p |> tl

    match? = _grid_search_rest(g_rest, p_rest, offset, n)

    # if a match found, abandon search, return true immediately
    if match? do
      _grid_search(c, g, p, n, true)
    else
      # check the next candidates
      _grid_search(c, g, p, n, m)
    end
  end

  # identify all matching substrings within an array of string, also
  # return offset (substring index) and row number
  @doc false
  @spec grid_search(list(binary), binary, integer, list) :: tuple
  def grid_search(grid, pattern, row \\ 1, candidates \\ [])
  def grid_search([], _, _, candidates), do: candidates

  def grid_search([g0 | g], p, r, c) do
    regex = Regex.compile!("(?=(#{p}))")
    match? = Regex.scan(regex, g0, return: :index, capture: :all_but_first) |> List.flatten

    if match? == [] do
      grid_search(g, p, r+1, c)
    else
      x = Enum.map(match?, fn {offset,_} -> {offset,r} end)
      grid_search(g, p, r+1, c ++ x)
    end
  end

  # determine whether the rest of pattern matches the next few lines in grid
  defp _grid_search_rest(grid, pattern, offset, len, matches \\ [])
  defp _grid_search_rest(_, [], _, _, matches), do: not(Enum.member?(matches, false))

  # grid ends (reached bottom) before a match can be checked thoroughly
  # return false
  defp _grid_search_rest([], _, offset, len, matches) do
    _grid_search_rest([], [], offset , len, [false|matches])
  end

  defp _grid_search_rest([g0|g], [p0|p], offset, len, matches) do
    regex = Regex.compile!("(?=(#{p0}))")
    match? = Regex.scan(regex, g0, return: :index, capture: :all_but_first) |> List.flatten

    cond do
      match? == [] ->
        _grid_search_rest(g, p, offset, len, [false|matches])
      Enum.member? match?, {offset, len} ->
        _grid_search_rest(g, p, offset, len, [true|matches])
      true ->
        _grid_search_rest(g, p, offset, len, [false|matches])
    end
  end

end
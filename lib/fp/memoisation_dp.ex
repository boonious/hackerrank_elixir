defmodule FP.MemoiDP do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: 
  memoisation, dynamic programming
  """

  @doc """
  Pentagonal numbers - compute number of dots for recursive and 
  overlapping pentagons of n size.

  https://www.hackerrank.com/challenges/pentagonal-numbers/problem
  """

  # Looking at the figure on HackerRank, the number can be modelled 
  # with this equation: P(n) = P(n-1) + (1 + (n-1) * 3)
  #
  # P(n-1) -> value of inner pentagons inc. the 2 overlapping sides
  # (1 + (n-1) * 3) -> value of the 3 non overlapping sides

  # first, try basic non-memoisation version
  @spec p(integer) :: integer
  def p(1), do: 1
  def p(n) when is_integer(n), do: p(n-1) + (1 + (n-1) * 3)

  # memoisation using cache for test cases 
  # with humongous number of pentogans, and of large sizes
  # 1 <= number of pentagons <= 10^5 
  # 1 <= n (size) <= 10^5
  #
  # Note: rather storing results in a list,
  # the solution on HackerRank involves Stream.map 
  # and outputting numbers directly to :stdio
  
  # recursively generate p values, using a cache
  # to speed the process
  @spec p(list, map, list) :: list
  def p(n, cache \\ %{1 => 1} , results \\ [])
  def p([], _, results), do: results |> Enum.reverse

  def p([n|n_rest], cache, results) do
      {p_value, c} = p_cache(n, cache)

      p(n_rest, c, [p_value|results])
  end

  def p_cache(n, cache \\ %{1 => 1})
  def p_cache(1, cache), do: {1, cache}

  def p_cache(n, c) do
    x = (1 + (n-1) * 3)

    # y = p(n-1)
    # lookup a cache for p(n - 1) or compute if one doesn't exist
    {y, c_new} = if c[n-1], do: {c[n-1], c}, else: p_cache((n-1), c)
    p = y + x

    {p, Map.merge(c_new, %{n => p})} # update cache with p entry
  end

end
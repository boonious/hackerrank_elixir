defmodule FP.MemoiDP do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: 
  memoisation, dynamic programming
  """

  #  https://www.hackerrank.com/challenges/pentagonal-numbers/problem
  # Looking at the figure on HackerRank, the number can be modelled 
  # with this equation: P(n) = P(n-1) + (1 + (n-1) * 3)
  #
  # P(n-1) -> value of inner pentagons inc. the 2 overlapping sides
  # (1 + (n-1) * 3) -> value of the 3 non overlapping sides

  # first, try basic non-memoisation version
  @doc false
  @spec p(integer) :: integer
  def p(1), do: 1
  def p(n) when is_integer(n), do: p(n - 1) + (1 + (n - 1) * 3)

  @doc """
  Pentagonal numbers - compute number of dots for recursive and
  overlapping pentagons of n size.

  https://www.hackerrank.com/challenges/pentagonal-numbers/problem
  """

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
  def p(n, cache \\ %{1 => 1}, results \\ [])
  def p([], _, results), do: results |> Enum.reverse()

  def p([n | n_rest], cache, results) do
    {p_value, c} = p_cache(n, cache)

    p(n_rest, c, [p_value | results])
  end

  @doc false
  def p_cache(n, cache \\ %{1 => 1})
  def p_cache(1, cache), do: {1, cache}

  def p_cache(n, c) do
    x = 1 + (n - 1) * 3

    # y = p(n-1)
    # lookup a cache for p(n - 1) or compute if one doesn't exist
    {y, c_new} = if c[n - 1], do: {c[n - 1], c}, else: p_cache(n - 1, c)
    p = y + x

    # update cache with p entry
    {p, Map.merge(c_new, %{n => p})}
  end

  @doc """
  Fibonacci - compute large Fibonacci numbers

  https://www.hackerrank.com/challenges/fibonacci-fp/problem
  """
  @spec fibonacci(list, map, list) :: list
  def fibonacci(numbers, cache \\ %{0 => 0, 1 => 1}, results \\ [])
  def fibonacci([], _, results), do: results |> Enum.reverse()

  def fibonacci([i | j], cache, results) do
    {n, c} = _fibonacci(i, cache)

    fibonacci(j, c, [n | results])
  end

  defp _fibonacci(n, cache) do
    if cache[n] do
      {cache[n], cache}
    else
      {n1, c1} = _fibonacci(n - 1, cache)
      {n2, c2} = _fibonacci(n - 2, c1)

      # compute number in modulo 10^8+7
      fibonnaci_n = rem(n1 + n2, 100_000_007)
      {fibonnaci_n, Map.merge(c2, %{n => fibonnaci_n})}
    end
  end

  # ==========================================================================
  @doc """
  Reverse factorisation - dynamic programming

  https://www.hackerrank.com/challenges/reverse-factorization/problem
  """

  # DP algorithm: find smallest series by recursive factorisation using the largest factor
  @spec reverse_factor(integer, list(integer)) :: list(integer)
  def reverse_factor(num, series) do
    # identify all factors related to the num
    factors =
      series
      |> Enum.filter(&(rem(num, &1) == 0))
      |> Enum.sort()
      # sort factors in desc order (largest first)
      |> Enum.reverse()

    results = [num]
    if factors == [], do: [-1], else: reverse_factor(num, factors, results)
  end

  # recursive factorisation by the largest factor
  def reverse_factor(1, _, results), do: results
  def reverse_factor(_, [], _), do: [-1]

  def reverse_factor(num, series, results) do
    # re-compute factors
    factors =
      series
      |> Enum.filter(&(rem(num, &1) == 0))

    if factors != [] do
      # new num by the largest factor division
      x = div(num, factors |> hd)
      # repeat factorisation
      reverse_factor(x, factors, [x | results])
    else
      # no factors found, i.e. unable to complete factorisation
      reverse_factor(num, [], results)
    end
  end
end

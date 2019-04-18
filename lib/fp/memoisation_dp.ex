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
  def p(n), do: p(n-1) + (1 + (n-1) * 3)

end
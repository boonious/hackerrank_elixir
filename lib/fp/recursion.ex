defmodule FP.Recursion do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: recursions.
  """

  @doc """
  Computing the greatest common divisor (GCD) with Euclidean Algorithm 
  https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---gcd/problem
  """
  @spec gcd(list(integer)) :: integer
  def gcd([x, y]) when x == y, do: x
  def gcd([x, y]) when x > y, do: gcd([x-y, y])
  def gcd([x, y]) do
    q = div(y, x)
    r = rem(y, x)
    gcd(x, y, q, r)
  end

  def gcd(x, _y, _q, 0), do: x
  def gcd(x, _y, _q, r), do: gcd(r, x, div(x, r), rem(x, r))

  @doc """
  Fibonocci numbers
  https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---fibonacci-numbers/problem
  """
  @spec fibonacci(integer) :: integer
  def fibonacci(0), do: 0
  def fibonacci(1), do: 0
  def fibonacci(2), do: 1
  def fibonacci(n) when n <= 40, do: fibonacci(n-1) + fibonacci(n-2)
  def fibonacci(_n), do: ""

end
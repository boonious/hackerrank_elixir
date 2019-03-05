defmodule Solution.FP do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges.
  """

  @doc """
  Reverse a list (without using Enum.reverse)
  https://www.hackerrank.com/challenges/fp-reverse-a-list/problem
  """
  @spec reverse(list, list) :: list(integer)
  def reverse([], results), do: results
  def reverse(numbers, results) when length(numbers) >= 1 and length(numbers) <= 100  do
     {last_number, remainder} = numbers |> List.pop_at(-1)
     if(last_number >= 0 and last_number <= 100) do
         reverse(remainder, results ++ [last_number])
     end
  end

  def reverse(_numbers, _results), do: [] 
     
  @doc """
  Evaluating e^x
  https://www.hackerrank.com/challenges/eval-ex/problem
  """
  @spec exp(float, integer, list) :: float 
  def exp(x, no_of_terms, results \\ 1)
  def exp(_x, 0, results), do: results |> Float.round(4)
  def exp(x, no_of_terms, results) do
      exp(x, no_of_terms-1, results + nth_term(x, no_of_terms))
  end

  defp nth_term(x, n), do: :math.pow(x,n) / factorial(n)
  defp factorial(0), do: 1
  defp factorial(n) when n > 0, do: Enum.reduce(1..n, 1, &*/2)

  @doc """
  Area and volume of a curve by definite integrals
  https://www.hackerrank.com/challenges/area-under-curves-and-volume-of-revolving-a-curv/problem
  """
  def area(c, p, l, r, dx) do
    y = fn x -> f(c, p, x) end
    n = ((r - l) / dx) |> trunc # total number of sub ntervals

    # according to formula provided via HackerRank
    # limit definition by definite integrals
    0..n
    |> Enum.map(&y.(l + &1 * dx)*dx)
    |> Enum.sum
    |> Float.round(1)
  end

  # according to volume formula in
  # https://www.wyzant.com/resources/lessons/math/calculus/integration/finding_volume
  def volume(c, p, l, r, dx) do
    y = fn x -> :math.pow(f(c, p, x), 2) end
    n = ((r - l) / dx) |> trunc # total number of sub ntervals

    0..n
    |> Enum.map(&y.(l + &1 * dx) * dx)
    |> Enum.sum
    |> :erlang.*(:math.pi)
    |> Float.round(1)
  end

  # construct algebraic series expression
  defp f(c, p, x) when is_list(c) and is_list(p) do
    Enum.zip(c, p)
    |> Enum.reduce(0, fn cp, acc -> acc + f(cp, x) end)
  end

  defp f({c, p}, x), do: c * :math.pow(x, p)

end


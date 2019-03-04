defmodule Solution.FP do
  @moduledoc """
  Elixir solutions for Hackerrank functional programming challenges.
  """

  @doc """
  Evaluating e^x - https://www.hackerrank.com/challenges/eval-ex/problem
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

end


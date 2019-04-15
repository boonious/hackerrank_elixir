defmodule Algo.DP do
  @moduledoc """
  Elixir solutions for HackerRank algorithm challenges: dynamic programming.
  """

  # reuse max subarray codes developed in functional programming challenges
  import FP.Structures, only: [kadane_max: 1]

  #==========================================================================
  @doc """
  The Maximum Subarray

  https://www.hackerrank.com/challenges/maxsubarray/problem
  """
  def max_subarray(a,n) do
    index = 0..n-1
    a_with_index = Enum.zip(a, index) # create a tuple sequence containing index

    {_span, max} = kadane_max(a_with_index)

    if max != 0 do
      non_negative_sequence = a |> Enum.reject(&(&1 < 0))
      [max, non_negative_sequence |> Enum.sum]
    else
      least_negative = a |> Enum.max
      [least_negative, least_negative]
    end

  end

end
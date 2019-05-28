defmodule Algo.DP do
  @moduledoc """
  Elixir solutions for HackerRank algorithm challenges: dynamic programming.
  """

  # reuse max subarray codes developed in functional programming challenges
  import FP.Structures, only: [kadane_max: 1]

  #==========================================================================
  @doc """
  The Maximum Subarray sums

  https://www.hackerrank.com/challenges/maxsubarray/problem
  """
  @spec max_subarray_sums(list(integer), integer) :: list(integer)
  def max_subarray_sums(a,n) do
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

  #==========================================================================
  @doc """
  String reduction by dynamic programming

  https://www.hackerrank.com/challenges/string-reduction/problem
  """

  # Dynamic programming algorithm based on even/odd properties of chars (a, b, c)
  # - string always reduced to 1 or 2 unique char(s)
  # - all same properties (odd or even) => 2
  # - different properties (some odd, some even) => 1
  #
  @spec string_reduce(binary) :: integer
  def string_reduce(str) do
    char_list = String.split str, "", trim: true

    if Enum.uniq(char_list) |> length == 1 do
      length(char_list)
    else
      a = Enum.count(char_list, &(&1=="a")) |> rem(2)
      b = Enum.count(char_list, &(&1=="b")) |> rem(2)
      c = Enum.count(char_list, &(&1=="c")) |> rem(2)

      if a == b and b == c, do: 2, else: 1
    end
  end

end
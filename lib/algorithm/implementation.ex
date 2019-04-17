defmodule Algo.Imp do
  @moduledoc """
  Elixir solutions for HackerRank algorithm challenges: implementation.
  """

  #==========================================================================
  @doc """
  Repeated string

  https://www.hackerrank.com/challenges/repeated-string/problem
  """
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
  Kangaroo, determine jump distance to be equal eventually from different starting points

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
  def divisible_sum_pairs(a, k) do
    divisible_sum_pairs(a, a |> tl, k, 0)
  end

  def divisible_sum_pairs([], _, _, count), do: count
  def divisible_sum_pairs([x|y], b, k, count) do
    sums = for a <- b do
      a+x
    end
    c = sums |> Enum.filter(&(rem(&1, k) == 0)) |> length
    divisible_sum_pairs(y, b |> Enum.drop(1), k, count + c)
  end

end
defmodule Algo.Constructive do
  @moduledoc """
  Elixir solutions for HackerRank algorithm challenges: constructive algorithm.
  """

  #==========================================================================
  @doc """
  New year chaos

  https://www.hackerrank.com/challenges/new-year-chaos/problem
  """
  @spec minimum_bribes(list(integer)) :: integer
  def minimum_bribes(queue) do
    bribes = 0
    sorted = []
    swaps = 0 
    minimum_bribes(queue, sorted, swaps, bribes)   
  end

  # use recursive bubble sort to sort queue hypothesis into an order queue
  # num of total swaps = num of bribes involved
  @doc false
  def minimum_bribes(queue, sorted, swaps, bribes) do
    pos = 1
    {sorted1, swaps1, bribes1} = bubble_sorted(queue, sorted, pos, swaps, bribes)

    cond do
      bribes == "Too chaotic" -> "Too chaotic"
      swaps1 != 0 -> minimum_bribes(sorted1, [], 0, bribes1)
      true -> bribes1
    end
  end

  defp bubble_sorted(_, sorted, _, swaps, "Too chaotic"), do: {sorted, swaps, "Too chaotic"}
  defp bubble_sorted([], sorted, _, swaps, bribes), do: {sorted |> Enum.reverse, swaps, bribes}

  defp bubble_sorted([x1, x2], sorted, pos, swaps, bribes) when x1 < x2 do    
    bubble_sorted([], [x2|[x1|sorted]], pos + 1, swaps, bribes)
  end

  defp bubble_sorted([x1, x2], sorted, pos, swaps, bribes) when x1 > x2 do
    bubble_sorted([], [x1|[x2|sorted]], pos + 1, swaps + 1, bribes + 1)
  end

  defp bubble_sorted(queue, sorted, pos, swaps, bribes) do
    [x1, x2] = Enum.take(queue, 2)
    y = Enum.drop(queue, 2)

    cond do
      (x1 - pos) > 2 -> bubble_sorted(y, sorted, pos + 1, swaps, "Too chaotic")
      x1 < x2 -> bubble_sorted([x2|y], [x1|sorted], pos + 1, swaps, bribes)
      x1 > x2 -> bubble_sorted([x1|y], [x2|sorted], pos + 1, swaps + 1, bribes + 1)
    end
  end

end
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

end
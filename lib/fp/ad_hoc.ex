defmodule FP.AdHoc do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: ad hoc.
  """

  @doc """
  Remove duplicates (char)
  https://www.hackerrank.com/challenges/remove-duplicates/problem
  """
  @spec dedup(binary) :: binary
  def dedup(str) do
    char_list = str |> String.split("", trim: true)
    {deduped, _dictionary} = _dedup(char_list)
    deduped
  end

  defp _dedup(chars, deduped \\ "", dict \\ MapSet.new)
  defp _dedup([], deduped, dict), do: {deduped, dict}
  defp _dedup([x|y], deduped, dict) do
    {a, b} = if MapSet.member?(dict, x) do 
      {deduped, dict} 
    else 
      {deduped <> x, MapSet.put(dict, x)}
    end
    _dedup(y, a, b)
  end

end
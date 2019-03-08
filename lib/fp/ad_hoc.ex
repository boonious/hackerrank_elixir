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


  @doc """
  Rotate string
  https://www.hackerrank.com/challenges/rotate-string/problem
  """
  @spec rotate(binary) :: list(binary)
  def rotate(str) when is_bitstring(str) do
    chars = String.split(str, "", trim: true)
    rotate(chars, length(chars))
  end

  def rotate(chars, iterations, results \\ [])
  def rotate(_chars, 0, results), do: results
  def rotate([x|y], iterations, results) do
    rotate(y ++ [x] , iterations - 1, results ++ [(y |> Enum.join("")) <> x])
  end


  # according to the easier method
  # https://www.youtube.com/watch?v=AHOvHb3Ej_I
  def prime_factorise(num, primes \\ @primes, factors \\ [])
  def prime_factorise(1, _primes, []), do: 1
  def prime_factorise(1, _primes, factors), do: factors
  def prime_factorise(num, [], factors), do: factors ++ [num]
  def prime_factorise(num, primes, factors) do
    prime = primes |> hd

    if(rem(num,prime) == 0) do
      prime_factorise(div(num, prime), primes, factors ++ [prime])
    else
      prime_factorise(num, primes |> tl, factors)
    end
  end

end
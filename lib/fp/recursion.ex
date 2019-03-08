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

  @doc """
  Pascal's triangle
  https://www.hackerrank.com/challenges/pascals-triangle/problem
  """
  def pascal_tri(k, m \\ 1, tri_data \\ [])
  def pascal_tri(k, m, tri_data) when m > k, do: tri_data
  def pascal_tri(k, m, tri_data) when k <= 10 do
    coefficients = pascal_tri_row(m-1)
    pascal_tri(k, m+1, tri_data ++ [coefficients])
  end
  def pascal_tri(_k, _m, _rows), do: nil

  def pascal_tri_row(n \\ 0, r \\ 0, values \\ [])
  def pascal_tri_row(n, r, values) when r == n + 1, do: values
  def pascal_tri_row(n, r, values) do
    coefficient = factorial(n)/(factorial(r)*factorial(n-r)) |> round
    pascal_tri_row(n, r+1, values ++ [coefficient])
  end

  defp factorial(0), do: 1
  defp factorial(n) when n > 0, do: Enum.reduce(1..n, 1, &*/2)

  @doc """
  String-o-Permute
  https://www.hackerrank.com/challenges/string-o-permute/problem
  """
  def permute_string(string) when is_bitstring(string) do
    string
    |> String.split("", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(&permute_string(&1))
    |> List.flatten
    |> Enum.join("")
  end

  def permute_string([a,b]), do: [b,a]

  @doc """
  String mingling
  https://www.hackerrank.com/challenges/string-mingling/problem
  """
  def mingle_string([a,b]) do
    string_list1 = a |> String.split("", trim: true)
    string_list2 = b |> String.split("", trim: true)

    mingle_string(string_list1, string_list2)
  end

  def mingle_string(string1, string2, new_string \\ "")
  def mingle_string([],[], new_string), do: new_string
  def mingle_string([c|d],[e|f], new_string), do: mingle_string(d,f,new_string <> c <> e)

end
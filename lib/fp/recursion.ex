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

  @doc false
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

  @doc false
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

  @doc false
  def mingle_string(string1, string2, new_string \\ "")
  def mingle_string([],[], new_string), do: new_string
  def mingle_string([c|d],[e|f], new_string), do: mingle_string(d,f,new_string <> c <> e)

  #==============================================================
  @doc """
  String compression

  https://www.hackerrank.com/challenges/string-compression/problem
  """
  def compress_string(str) when is_binary(str) do
    str
    |> String.split("", trim: true)
    |> compress_string
  end

  @doc false
  def compress_string(chars, results \\ "", count \\ 1)
  def compress_string([], results, _count), do: results
  def compress_string([x|y], results, count) do
    if y != [] and (x == y |> hd) do
      compress_string(y, results, count + 1)
    else
      char = if count == 1, do: x, else: x <> (count |> Integer.to_string)
      compress_string(y, results <> char, 1)
    end
  end

  #==============================================================
  @doc """
  Prefix compression

  https://www.hackerrank.com/challenges/prefix-compression/problem
  """
  @spec prefix_compress(list(binary)) :: list(tuple)
  def prefix_compress(data) do
    [str_token1, str_token2] = data |> Enum.map(&String.split(&1,"", trim: true))

    prefix = Enum.zip(str_token1, str_token2) |> prefix_compress("", 0)
    pos = elem(prefix, 0)

    substring1 = Enum.drop(str_token1, pos) |> Enum.join("")
    substring2 = Enum.drop(str_token2, pos) |> Enum.join("")
    [prefix, {String.length(substring1),substring1}, {String.length(substring2), substring2}]
  end

  @doc false
  def prefix_compress([], prefix, count), do: {count, prefix}
  def prefix_compress([{a,b}|c], prefix, count) do
    if a == b, do: prefix_compress(c, prefix <> a, count + 1), else: prefix_compress([], prefix, count)
  end

  #==============================================================
  @doc """
  String reductions

  https://www.hackerrank.com/challenges/string-reductions/problem
  """
  def string_reduce(str) do
    str
    |> String.split("")
    |> string_reduce([])
  end

  @doc false
  def string_reduce([], output), do: Enum.reverse(output) |> Enum.join("")
  def string_reduce([a|b], output) do
    if Enum.member?(output, a), do: string_reduce(b,output), else: string_reduce(b, [a|output])
  end

  #==============================================================
  @doc """
  The Sum of powers

  https://www.hackerrank.com/challenges/functional-programming-the-sums-of-powers/problem
  """
  def sum_of_powers([num, power]) do
    # find out the max number for evaluation
    # e.g. 100 -> 10, as 11^x exceeds 100, for x >= 2
    max_num = :math.pow(num, 1/power) |> round

    # check map series of nth power, starting from 1 to max num
    # this function return a list of "true" elements, indicating
    # the possible ways
    check_power(1..max_num |> Enum.to_list, num, power, max_num)
    |> length
  end

  @doc false
  # return true if series reduced to 0, i.e. a solution found
  def check_power(_num, sum, _pow, _max_num) when sum == 0, do: true

  # the sum > 0 guard, ensure recursion checking is proceeding
  def check_power(num, sum, pow, max_num) when is_list(num) and sum > 0 do
    Enum.map(num, &check_power(&1, sum, pow, max_num))
    |> List.flatten
    |> Enum.filter(&(&1 == true))
  end

  # recursively checking series based on a method using the remainder after
  # substraction for a nth power term,
  # the remainder subsequently becomes
  # 0 (solution) or negative (abort, not a solution)
  def check_power(num, sum, pow, max_num) when sum >= 0 and num <= max_num do
    remainder = sum - :math.pow(num, pow)
    check_power((num + 1..max_num |> Enum.to_list), remainder, pow, max_num)
  end

  # otherwise sum < 0, return false indicating the power sequence isn't solution
  def check_power(_num, _sum, _pow, _max_num), do: false


  #========================================================================================
  @doc """
  Filter elements

  https://www.hackerrank.com/challenges/filter-elements/problem
  """
  def filter_elements(k, nums) do
      dict = uniq_numbers(nums, [])

      x = Enum.reject(dict, &(count(&1, nums, 0) < k))
      if x == [], do: [-1], else: x
  end

  defp count(_n, [], freq), do: freq
  defp count(n, [x|y], freq) when n == x, do: count(n, y, freq + 1)
  defp count(n, [_x|y], freq), do: count(n, y, freq)

  defp uniq_numbers([], numbers), do: numbers |> Enum.reverse
  defp uniq_numbers([x|y], numbers) do
      if Enum.member?(numbers, x), do: uniq_numbers(y, numbers), else: uniq_numbers(y, [x|numbers])
  end

end
defmodule FP.AdHoc do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges: ad hoc.
  """

  @primes [
    2,
    3,
    5,
    7,
    11,
    13,
    17,
    19,
    23,
    29,
    31,
    37,
    41,
    43,
    47,
    53,
    59,
    61,
    67,
    71,
    73,
    79,
    83,
    89,
    97,
    101,
    103,
    107,
    109,
    113,
    127,
    131,
    137,
    139,
    149,
    151,
    157,
    163,
    167,
    173,
    179,
    181,
    191,
    193,
    197,
    199,
    211,
    223,
    227,
    229,
    233,
    239,
    241,
    251,
    257,
    263,
    269,
    271,
    277,
    281,
    283,
    293,
    307,
    311,
    313,
    317,
    331,
    337,
    347,
    349,
    353,
    359,
    367,
    373,
    379,
    383,
    389,
    397,
    401,
    409,
    419,
    421,
    431,
    433,
    439,
    443,
    449,
    457,
    461,
    463,
    467,
    479,
    487,
    491,
    499,
    503,
    509,
    521,
    523,
    541,
    547,
    557,
    563,
    569,
    571,
    577,
    587,
    593,
    599,
    601,
    607,
    613,
    617,
    619,
    631,
    641,
    643,
    647,
    653,
    659,
    661,
    673,
    677,
    683,
    691,
    701,
    709,
    719,
    727,
    733,
    739,
    743,
    751,
    757,
    761,
    769,
    773,
    787,
    797,
    809,
    811,
    821,
    823,
    827,
    829,
    839,
    853,
    857,
    859,
    863,
    877,
    881,
    883,
    887,
    907,
    911,
    919,
    929,
    937,
    941,
    947,
    953,
    967,
    971,
    977,
    983,
    991,
    997,
    1009,
    1013,
    1019,
    1021,
    1031,
    1033,
    1039,
    1049,
    1051,
    1061,
    1063,
    1069,
    1087,
    1091,
    1093,
    1097,
    1103,
    1109,
    1117,
    1123,
    1129,
    1151,
    1153,
    1163,
    1171,
    1181,
    1187,
    1193,
    1201,
    1213,
    1217,
    1223
  ]

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

  defp _dedup(chars, deduped \\ "", dict \\ MapSet.new())
  defp _dedup([], deduped, dict), do: {deduped, dict}

  defp _dedup([x | y], deduped, dict) do
    {a, b} =
      if MapSet.member?(dict, x) do
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

  @doc false
  def rotate(chars, iterations, results \\ [])
  def rotate(_chars, 0, results), do: results

  def rotate([x | y], iterations, results) do
    rotate(y ++ [x], iterations - 1, results ++ [(y |> Enum.join("")) <> x])
  end

  # use binary matching to solve the string rotation challenge (above)
  # this solution eliminates list creation and the use of ++
  #
  # benchmarking suggests this solution to be more performant - see below
  #
  # https://www.hackerrank.com/challenges/rotate-string/problem
  def rotate_binary(str) when is_bitstring(str), do: rotate_binary(str, String.length(str))

  def rotate_binary(str, iterations, results \\ [])
  def rotate_binary(_str, 0, results), do: results |> Enum.reverse()

  def rotate_binary(<<head::utf8, rest::binary>>, iterations, results) do
    rotate_binary(<<rest::binary, head>>, iterations - 1, [<<rest::binary, head>> | results])
  end

  #   from: mix run benchmark/string_rotation.exs
  #
  #   Operating System: macOS
  #   CPU Information: Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
  #   Number of Available Cores: 8
  #   Available memory: 16 GB
  #   Elixir 1.11.2
  #   Erlang 21.3.8.7
  #
  #   Benchmark suite executing with the following configuration:
  #   warmup: 2 s
  #   time: 10 s
  #   memory time: 2 s
  #   parallel: 1
  #   inputs: none specified
  #   Estimated total run time: 28 s
  #
  #   Benchmarking String rotation - binary matching...
  #   Benchmarking String rotation - list-based...
  #
  #   Name                                        ips        average  deviation         median         99th %
  #   String rotation - binary matching         43.77       22.85 ms     ±5.73%       23.08 ms       28.43 ms
  #   String rotation - list-based              14.26       70.15 ms     ±8.92%       68.09 ms       84.69 ms
  #
  #   Comparison:
  #   String rotation - binary matching         43.77
  #   String rotation - list-based              14.26 - 3.07x slower +47.30 ms
  #
  #   Memory usage statistics:
  #
  #   Name                                 Memory usage
  #   String rotation - binary matching         8.13 MB
  #   String rotation - list-based             40.27 MB - 4.95x memory usage +32.14 MB

  # ===============================================================================================
  @doc """
  Huge GCD

  Compute GCD for huge numbers via prime number decomposition.
  https://www.hackerrank.com/challenges/huge-gcd-fp/problem
  """
  @spec gcd(list) :: integer
  def gcd([a, b]) do
    prime_factors_a = a |> Enum.map(&prime_factorise(&1)) |> List.flatten()
    prime_factors_b = b |> Enum.map(&prime_factorise(&1)) |> List.flatten()
    prime_diff = prime_factors_b -- prime_factors_a

    (prime_factors_b -- prime_diff)
    |> Enum.reduce(&:erlang.*/2)
    # print results in modulo 1000000007
    |> rem(1_000_000_007)
  end

  # according to the easier method
  # https://www.youtube.com/watch?v=AHOvHb3Ej_I
  @doc false
  def prime_factorise(num, primes \\ @primes, factors \\ [])
  def prime_factorise(1, _primes, []), do: 1
  def prime_factorise(1, _primes, factors), do: factors
  def prime_factorise(num, [], factors), do: factors ++ [num]

  def prime_factorise(num, primes, factors) do
    prime = primes |> hd

    if(rem(num, prime) == 0) do
      prime_factorise(div(num, prime), primes, factors ++ [prime])
    else
      prime_factorise(num, primes |> tl, factors)
    end
  end
end

defmodule FP.Intro do
  @moduledoc """
  Elixir solutions for HackerRank functional programming challenges.
  """

  @doc """
  Reverse a list (without using Enum.reverse)
  https://www.hackerrank.com/challenges/fp-reverse-a-list/problem
  """
  @spec reverse(list, list) :: list(integer)
  def reverse([], results), do: results
  def reverse(numbers, results) when length(numbers) >= 1 and length(numbers) <= 100  do
    reverse(numbers |> tl, [(numbers |> hd)|results])
  end

  def reverse(_numbers, _results), do: [] 
     
  @doc """
  Evaluating e^x
  https://www.hackerrank.com/challenges/eval-ex/problem
  """
  @spec exp(float, integer, list) :: float 
  def exp(x, no_of_terms, results \\ 1)
  def exp(_x, 0, results), do: results |> Float.round(4)
  def exp(x, no_of_terms, results) do
      exp(x, no_of_terms-1, results + nth_term(x, no_of_terms))
  end

  defp nth_term(x, n), do: :math.pow(x,n) / factorial(n)
  defp factorial(0), do: 1
  defp factorial(n) when n > 0, do: Enum.reduce(1..n, 1, &*/2)

  @doc """
  Area and volume of a curve by definite integrals
  https://www.hackerrank.com/challenges/area-under-curves-and-volume-of-revolving-a-curv/problem
  """
  def area(c, p, l, r, dx) do
    y = fn x -> f(c, p, x) end
    n = ((r - l) / dx) |> trunc # total number of sub ntervals

    # according to the formula provided via HackerRank
    # limit definition by definite integrals
    0..n
    |> Enum.map(&y.(l + &1 * dx)*dx)
    |> Enum.sum
    |> Float.round(1)
  end

  # according to the volume formula in
  # https://www.wyzant.com/resources/lessons/math/calculus/integration/finding_volume
  def volume(c, p, l, r, dx) do
    y = fn x -> :math.pow(f(c, p, x), 2) end
    n = ((r - l) / dx) |> trunc # total number of sub ntervals

    0..n
    |> Enum.map(&y.(l + &1 * dx) * dx)
    |> Enum.sum
    |> :erlang.*(:math.pi)
    |> Float.round(1)
  end

  # construct algebraic series expression
  defp f(c, p, x) when is_list(c) and is_list(p) do
    Enum.zip(c, p)
    |> Enum.reduce(0, fn cp, acc -> acc + f(cp, x) end)
  end

  defp f({c, p}, x), do: c * :math.pow(x, p)

  @doc """
  Function or not - validating values x, y or x and f(x).
  Given a list of x, y values, this function determines
  (true, false) whether the values could be input/output
  for a valid function.
  https://www.hackerrank.com/challenges/functions-or-not/problem
  """
  @spec function?(list(tuple)) :: boolean
  def function?(xy) do
    xy
    |> Enum.group_by(&(elem(&1,0)), &(elem(&1,1))) # maps to x, y
    |> Enum.find(fn {_k,v} -> length(v) > 1 end) # find any x with multiple y values, i.e. invalid relation
    |> is_nil # should be nil if all x, y pairs have 1-1 unique mapping
  end

  @doc """
  Compute the Perimeter of a Polygon.
  https://www.hackerrank.com/challenges/lambda-march-compute-the-perimeter-of-a-polygon/problem

  """
  @spec perimeter(list(tuple)) :: float
  def perimeter(coordinates), do: _perimeter(coordinates ++ [coordinates |> hd])

  # recursively compute perimeter, when "coordinates"
  # contain only 1 pt (last pt), return results
  defp _perimeter(coordinates, distance \\ 0.0)
  defp _perimeter(coordinates, distance) when length(coordinates) == 1, do: distance |> Float.round(7)
  defp _perimeter([p1 | coordinates], distance) do
    p2 = coordinates |> hd
    _perimeter(coordinates, distance + _perimeter(p1, p2))
  end

  defp _perimeter({x1,y1}, {x2,y2}), do: :math.sqrt(:math.pow(y2-y1, 2) + :math.pow(x2-x1, 2))

  @doc """
  Compute the area of a Polygon.
  https://www.hackerrank.com/challenges/lambda-march-compute-the-area-of-a-polygon/problem
  """
  @spec area_polygon(list(tuple)) :: float
  def area_polygon(coordinates), do: _area_polygon(coordinates ++ [coordinates |> hd])

  # using irregular polygon formula in https://www.mathopenref.com/coordpolygonarea.html
  defp _area_polygon(coordinates, x \\ 0.0)
  defp _area_polygon(coordinates, x) when length(coordinates) == 1, do: abs(x / 2) |> Float.round(7)
  defp _area_polygon([p1 | coordinates], x) do
    p2 = coordinates |> hd
    _area_polygon(coordinates, x + _area_polygon(p1, p2))
  end

  defp _area_polygon({x1,y1}, {x2,y2}), do: (x1*y2 - y1*x2)

end


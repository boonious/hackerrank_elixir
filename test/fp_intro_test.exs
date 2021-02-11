defmodule FPIntroTest do
  use ExUnit.Case
  doctest FP.Intro

  # https://www.hackerrank.com/challenges/eval-ex/problem
  test "reverse - reverse a list" do
    input = [19, 22, 3, 28, 26, 17, 18, 4, 28, 0]
    results = []
    output = input |> FP.Intro.reverse(results)
    assert output == [0, 28, 4, 18, 17, 26, 28, 3, 22, 19]
  end

  # https://www.hackerrank.com/challenges/eval-ex/problem
  test "exp - Evaluating exponential, e^x" do
    test_cases = [20.0000, 5.0000, 0.5000, -0.5000]
    # initial a sum to be added to
    initial_results = 1
    number_of_terms = 9

    test_results = test_cases |> Enum.map(&FP.Intro.exp(&1, number_of_terms, initial_results))

    assert test_results == [2_423_600.1887, 143.6895, 1.6487, 0.6065]
  end

  # https://www.hackerrank.com/challenges/area-under-curves-and-volume-of-revolving-a-curv/problem
  test "area - Area under curve by Definite Integrals" do
    coefficients = [1, 2, 3, 4, 5]
    powers = [6, 7, 8, 9, 10]
    # x ranges and subinterval
    {left_x, right_x, subinterval} = {1, 4, 0.001}

    area = FP.Intro.area(coefficients, powers, left_x, right_x, subinterval)

    assert area == 2_435_300.3
  end

  # https://www.hackerrank.com/challenges/area-under-curves-and-volume-of-revolving-a-curv/problem
  test "volume - Volume of revolving curve by Definite Integrals" do
    coefficients = [1, 2, 3, 4, 5]
    powers = [6, 7, 8, 9, 10]
    # x ranges and subinterval
    {left_x, right_x, subinterval} = {1, 4, 0.001}

    volume = FP.Intro.volume(coefficients, powers, left_x, right_x, subinterval)

    assert volume == 26_172_951_168_940.8
  end

  # https://www.hackerrank.com/challenges/functions-or-not/problem
  test "function? - Function or not - validating x, y value pairs" do
    test_case = [{1, 1}, {2, 2}, {3, 3}]
    assert FP.Intro.function?(test_case) == true

    test_case = [{1, 2}, {2, 4}, {3, 6}, {4, 8}]
    assert FP.Intro.function?(test_case) == true

    test_case = [{1, 2}, {2, 4}, {2, 6}]
    assert FP.Intro.function?(test_case) == false

    test_case = [{1, 2}, {1, 4}, {1, 6}, {1, 8}]
    assert FP.Intro.function?(test_case) == false
  end

  # https://www.hackerrank.com/challenges/functions-or-not/problem
  test "perimeter - Compute the perimeter of a polygon" do
    coordinates = [{0, 0}, {0, 1}, {1, 1}, {1, 0}]
    assert FP.Intro.perimeter(coordinates) == 4.0

    coordinates = [{1043, 770}, {551, 990}, {681, 463}]
    assert FP.Intro.perimeter(coordinates) == 1556.3949033
  end

  # https://www.hackerrank.com/challenges/lambda-march-compute-the-area-of-a-polygon/problem
  test "area_polygon - Compute the area of a polygon" do
    coordinates = [{0, 0}, {0, 1}, {1, 1}, {1, 0}]
    assert FP.Intro.area_polygon(coordinates) == 1

    coordinates = [{1043, 770}, {551, 990}, {681, 463}]
    assert FP.Intro.area_polygon(coordinates) == 115_342.0
  end
end

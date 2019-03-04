defmodule SolutionTest do
  use ExUnit.Case
  doctest Solution.FP

  test "greets the world" do
    assert Solution.FP.hello() == :world
  end
end

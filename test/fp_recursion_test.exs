defmodule FPRecursionTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  doctest FP.Recursion

  describe "recursion" do
    @describetag :recursion
    
    #https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---gcd/problem
    test "gcd - computing the greatest common divisor GCD using Euclidean Algorithm" do
      input = [1, 5]
      assert FP.Recursion.gcd(input) == 1

      input = [10, 100]
      assert FP.Recursion.gcd(input) == 10

      input = [1701, 3768]
      assert FP.Recursion.gcd(input) == 3
    
      input = [13, 13]
      assert FP.Recursion.gcd(input) == 13
    
      input = [144, 38]
      assert FP.Recursion.gcd(input) == 2
    end

    #https://www.hackerrank.com/challenges/functional-programming-warmups-in-recursion---fibonacci-numbers/problem
    test "fibonacci - Fibonacci numbers" do
      n = 3
      assert FP.Recursion.fibonacci(n) == 1

      n = 4
      assert FP.Recursion.fibonacci(n) == 2

      n = 5
      assert FP.Recursion.fibonacci(n) == 3
    end

    #https://www.hackerrank.com/challenges/pascals-triangle/problem
    test "pascal_tri - Pascal's triangle numbers" do
      n = 4
      assert FP.Recursion.pascal_tri_row(n-1) == [1,3,3,1]
      assert FP.Recursion.pascal_tri(n) === [[1], [1,1], [1,2,1], [1,3,3,1]]
    end

    #https://www.hackerrank.com/challenges/functions-and-fractals-sierpinski-triangles/problem
    test "draw_triangles - Functions and fractals: Sierpinski triangle" do
      fractal = FP.Recursion.draw_triangles(2)
      assert capture_io(fn ->
        fractal |> Enum.each(&IO.puts(&1 <> "\n"))
      end)
      ==
      "_______________________________1_______________________________\n
______________________________111______________________________\n
_____________________________11111_____________________________\n
____________________________1111111____________________________\n
___________________________111111111___________________________\n
__________________________11111111111__________________________\n
_________________________1111111111111_________________________\n
________________________111111111111111________________________\n
_______________________1_______________1_______________________\n
______________________111_____________111______________________\n
_____________________11111___________11111_____________________\n
____________________1111111_________1111111____________________\n
___________________111111111_______111111111___________________\n
__________________11111111111_____11111111111__________________\n
_________________1111111111111___1111111111111_________________\n
________________111111111111111_111111111111111________________\n
_______________1_______________________________1_______________\n
______________111_____________________________111______________\n
_____________11111___________________________11111_____________\n
____________1111111_________________________1111111____________\n
___________111111111_______________________111111111___________\n
__________11111111111_____________________11111111111__________\n
_________1111111111111___________________1111111111111_________\n
________111111111111111_________________111111111111111________\n
_______1_______________1_______________1_______________1_______\n
______111_____________111_____________111_____________111______\n
_____11111___________11111___________11111___________11111_____\n
____1111111_________1111111_________1111111_________1111111____\n
___111111111_______111111111_______111111111_______111111111___\n
__11111111111_____11111111111_____11111111111_____11111111111__\n
_1111111111111___1111111111111___1111111111111___1111111111111_\n
111111111111111_111111111111111_111111111111111_111111111111111\n
"
    end

    #https://www.hackerrank.com/challenges/string-o-permute/problem
    test "permute_string - String-o-permute" do
      assert FP.Recursion.permute_string("abcdpqrs") == "badcqpsr"
      assert FP.Recursion.permute_string("az") == "za"
    end

    #https://www.hackerrank.com/challenges/string-mingling/problem
    test "mingle_string - String mingling" do
      assert FP.Recursion.mingle_string(["abcde", "pqrst"]) == "apbqcrdset"
      assert FP.Recursion.mingle_string(["hacker", "ranker"]) == "hraacnkkeerr"
    end

    #https://www.hackerrank.com/challenges/fractal-trees/problem
    test "draw_trees - Functions and fractals, recursive trees" do
      assert FP.Recursion.draw_trees(5)
      == ["____________________________________________________________________________________________________",
         "__________________1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1_1___________________",
         "___________________1___1___1___1___1___1___1___1___1___1___1___1___1___1___1___1____________________",
         "___________________1___1___1___1___1___1___1___1___1___1___1___1___1___1___1___1____________________",
         "____________________1_1_____1_1_____1_1_____1_1_____1_1_____1_1_____1_1_____1_1_____________________",
         "_____________________1_______1_______1_______1_______1_______1_______1_______1______________________",
         "_____________________1_______1_______1_______1_______1_______1_______1_______1______________________",
         "_____________________1_______1_______1_______1_______1_______1_______1_______1______________________",
         "______________________1_____1_________1_____1_________1_____1_________1_____1_______________________",
         "_______________________1___1___________1___1___________1___1___________1___1________________________",
         "________________________1_1_____________1_1_____________1_1_____________1_1_________________________",
         "_________________________1_______________1_______________1_______________1__________________________",
         "_________________________1_______________1_______________1_______________1__________________________",
         "_________________________1_______________1_______________1_______________1__________________________",
         "_________________________1_______________1_______________1_______________1__________________________",
         "_________________________1_______________1_______________1_______________1__________________________",
         "__________________________1_____________1_________________1_____________1___________________________",
         "___________________________1___________1___________________1___________1____________________________",
         "____________________________1_________1_____________________1_________1_____________________________",
         "_____________________________1_______1_______________________1_______1______________________________",
         "______________________________1_____1_________________________1_____1_______________________________",
         "_______________________________1___1___________________________1___1________________________________",
         "________________________________1_1_____________________________1_1_________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "_________________________________1_______________________________1__________________________________",
         "__________________________________1_____________________________1___________________________________",
         "___________________________________1___________________________1____________________________________",
         "____________________________________1_________________________1_____________________________________",
         "_____________________________________1_______________________1______________________________________",
         "______________________________________1_____________________1_______________________________________",
         "_______________________________________1___________________1________________________________________",
         "________________________________________1_________________1_________________________________________",
         "_________________________________________1_______________1__________________________________________",
         "__________________________________________1_____________1___________________________________________",
         "___________________________________________1___________1____________________________________________",
         "____________________________________________1_________1_____________________________________________",
         "_____________________________________________1_______1______________________________________________",
         "______________________________________________1_____1_______________________________________________",
         "_______________________________________________1___1________________________________________________",
         "________________________________________________1_1_________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________",
         "_________________________________________________1__________________________________________________"]
    end

    #https://www.hackerrank.com/challenges/string-compression/problem
    test "compress_string - String compression" do
      assert FP.Recursion.compress_string("aaabaaaaccaaaaba") == "a3ba4c2a4ba"
    end


  end

end

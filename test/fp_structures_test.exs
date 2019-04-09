defmodule FPStructuresTest do
  use ExUnit.Case
  import FP.Structures

  doctest FP.Structures

  describe "structures - binary trees" do
    @describetag :binary_tree

    # tests for binary tree / swapping nodes challenge
    # https://www.hackerrank.com/challenges/swap-nodes/problem
    test "n - binary tree node creation / addition" do
      assert n(1) ==  %{l: nil, r: nil, v: 1}
    end

    # supports new algorithm for constructing large (> 1000) binary tree
    test "tree_data - parse nodes data to gauge total depth and number of nodes per depth level" do
      nodes_data = [[2, 3], [-1, 4], [-1, 5], [-1, -1], [-1, -1]]
      assert tree_data(nodes_data) == {4, [2, 2, 1]}

      nodes_data = [[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, -1],[-1, -1],[-1, -1]]
      assert tree_data(nodes_data) == {5, [3, 2, 2, 1]}
    end

    test "build_tree - binary tree building" do
      children = []
      nodes_data = [[2, 3], [-1, -1], [-1, -1]]
      {_, info} = tree_data(nodes_data)
      assert build_tree(nodes_data, children, info)
      == %{
        v: 1,
        l: %{v: 2, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
        r: %{v: 3, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
      }

      nodes_data = [[2, 3], [-1, 4], [-1, 5], [-1, -1], [-1, -1]]
      {_, info} = tree_data(nodes_data)
      assert build_tree(nodes_data, children, info)
      == %{
        v: 1,
        l: %{
          v: 2,
          l: %{
            v: -1, l: nil, r: nil
          },
          r: %{
            v: 4, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}
          }
        },
        r: %{
          v: 3,
          l: %{
            v: -1, l: nil, r: nil
          },
          r: %{
            v: 5, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}
          }
        }
      }
    end

    test "build_tree - binary tree building: large and unbalanced" do
      children = []
      nodes_data = [[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      assert build_tree(nodes_data, children, info)
      == %{
        l: %{
          l: %{
            l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 6},
            r: %{l: nil, r: nil, v: -1},
            v: 4
          },
          r: %{l: nil, r: nil, v: -1},
          v: 2
        },
        r: %{
          l: %{
            l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 7},
            r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 8},
            v: 5
          },
          r: %{l: nil, r: nil, v: -1},
          v: 3
        },
        v: 1
      }

      nodes_data = [[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, 9],[-1, -1],[10, 11],[-1, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      assert build_tree(nodes_data, children, info)
      == %{
        l: %{
          l: %{
            l: %{
              l: %{l: nil, r: nil, v: -1},
              r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 9},
              v: 6
            },
            r: %{l: nil, r: nil, v: -1},
            v: 4
          },
          r: %{l: nil, r: nil, v: -1},
          v: 2
        },
        r: %{
          l: %{
            l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 7},
            r: %{
              l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 10},
              r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 11},
              v: 8
            },
            v: 5
          },
          r: %{l: nil, r: nil, v: -1},
          v: 3
        },
        v: 1
      }

      nodes_data = [[2, 3],[4, 5],[6, -1],[-1, 7],[8, 9],[10, 11],[12, 13],[-1, 14],[-1, -1],[15, -1],[16, 17],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      assert build_tree(nodes_data, children, info)
      == %{
        l: %{
          l: %{
            l: %{l: nil, r: nil, v: -1},
            r: %{
              l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 12},
              r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 13},
              v: 7
            },
            v: 4
          },
          r: %{
            l: %{
              l: %{l: nil, r: nil, v: -1},
              r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 14},
              v: 8
            },
            r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 9},
            v: 5
          },
          v: 2
        },
        r: %{
          l: %{
            l: %{
              l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 15},
              r: %{l: nil, r: nil, v: -1},
              v: 10
            },
            r: %{
              l: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 16},
              r: %{l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}, v: 17},
              v: 11
            },
            v: 6
          },
          r: %{l: nil, r: nil, v: -1},
          v: 3
        },
        v: 1
      }
    end

    test "swap - swap function which returns binary tree as Map" do
      children = []
      nodes_data = [[2, 3], [-1, -1], [-1, -1]]
      {depth, info} = tree_data(nodes_data)

      tree = build_tree(nodes_data, children, info)
      k = [1,2]
      current_depth = 1

      assert FP.Structures.swap(tree, current_depth, depth, k)
      == %{
        r: %{
          l: %{l: nil, r: nil, v: -1},
          r: %{l: nil, r: nil, v: -1},
          v: 2
        },
        l: %{
          l: %{l: nil, r: nil, v: -1},
          r: %{l: nil, r: nil, v: -1},
          v: 3
        },
        v: 1
      }

      nodes_data = [[2, 3], [-1, 4], [-1, 5], [-1, -1], [-1, -1]]
      {depth, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      k = [2]

      assert FP.Structures.swap(tree, current_depth, depth, k)
      == %{
        v: 1,
        l: %{
          v: 2,
          r: %{
            v: -1, l: nil, r: nil
          },
          l: %{
            v: 4, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}
          }
        },
        r: %{
          v: 3,
          r: %{
            v: -1, l: nil, r: nil
          },
          l: %{
            v: 5, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}
          }
        }
      }
    end

    test "inorder_traverse - binary tree traversal" do
      children = []
      nodes_data = [[2, 3], [-1, -1], [-1, -1]]
      {_, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      assert FP.Structures.inorder_traverse(tree) == [2,1,3]

      nodes_data = [[2, 3],[4, -1],[5, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      assert FP.Structures.inorder_traverse(tree) == [4,2,1,5,3]

      nodes_data = [[2, 3], [-1, 4], [-1, 5],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      assert FP.Structures.inorder_traverse(tree) == [2,4,1,3,5]

      nodes_data = [[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, 9],[-1, -1],[10, 11],[-1, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      assert FP.Structures.inorder_traverse(tree) == [6,9,4,2,1,7,5,10,8,11,3]

      nodes_data = [[2, 3],[4, 5],[6, -1],[-1, 7],[8, 9],[10, 11],[12, 13],[-1, 14],[-1, -1],[15, -1],[16, 17],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1]]
      {_, info} = tree_data(nodes_data)
      tree = build_tree(nodes_data, children, info)
      assert FP.Structures.inorder_traverse(tree) == [4,12,7,13,2,8,14,5,9,1,15,10,6,16,11,17,3]
    end

    test "swap_nodes - Swap nodes in binary tree" do
      nodes_data = [[3], [2, 3], [-1,-1], [-1,-1], [2], [1], [1]]
      assert FP.Structures.swap_nodes(nodes_data) == [[3,1,2],[2,1,3]]

      nodes_data = [[5], [2, 3], [-1,4], [-1,5], [-1,-1], [-1,-1],[1], [2]]
      assert FP.Structures.swap_nodes(nodes_data) == [[4,2,1,5,3]]

      nodes_data = [[5],[2, 3],[4,-1],[5,-1],[-1, -1],[-1, -1],[2],[2],[2]]
      assert FP.Structures.swap_nodes(nodes_data) == [[2,4,1,3,5],[4,2,1,5,3]]

      nodes_data = [[11],[2, 3],[4,-1],[5,-1],[6,-1],[7, 8],[-1, 9],[-1, -1],[10, 11],[-1, -1],[-1, -1],[-1, -1],[2],[2],[4]]
      assert FP.Structures.swap_nodes(nodes_data) == [[2,9,6,4,1,3,7,5,11,8,10],[2,6,9,4,1,3,7,5,10,8,11]]

      nodes_data = [[17],[2, 3],[4, 5],[6, -1],[-1, 7],[8, 9],[10, 11],[12, 13],[-1, 14],[-1, -1],[15, -1],[16, 17],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[2],[2],[3]]
      assert FP.Structures.swap_nodes(nodes_data) == [[14,8,5,9,2,4,13,7,12,1,3,10,15,6,17,11,16],[9,5,14,8,2,13,7,12,4,1,3,17,11,16,6,10,15]]

      nodes_data = [[100],[-1,2],[3,4],[5,6],[7,-1],[8,-1],[9,10],[11,12],[-1,13],[14,15],[-1,-1],[-1,16],[17,-1],[18,19],[20,21],[22,23],[-1,-1],[24,25],[26,-1],[27,28],[29,30],[31,-1],[32,33],[34,35],[36,37],[38,39],[-1,40],[-1,41],[-1,42],[-1,-1],[43,44],[-1,-1],[45,46],[47,48],[-1,-1],[-1,49],[-1,50],[51,52],[-1,53],[54,55],[-1,56],[57,-1],[-1,58],[59,-1],[60,61],[-1,62],[-1,63],[-1,-1],[-1,64],[65,-1],[66,-1],[-1,67],[-1,-1],[-1,68],[-1,69],[70,-1],[71,-1],[72,73],[74,75],[-1,-1],[76,-1],[77,-1],[-1,-1],[78,-1],[-1,-1],[79,80],[81,82],[-1,83],[84,-1],[85,-1],[86,-1],[-1,87],[-1,-1],[-1,-1],[-1,88],[-1,-1],[89,90],[-1,-1],[91,-1],[-1,92],[93,-1],[94,95],[-1,-1],[96,97],[98,-1],[-1,99],[100,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[-1,-1],[45],[8],[6],[2],[3],[5],[7],[7],[5],[7],[1],[5],[6],[2],[8],[4],[6],[8],[12],[10],[6],[12],[11],[12],[8],[1],[7],[9],[3],[8],[7],[2],[7],[8],[3],[8],[9],[7],[9],[9],[8],[11],[10],[4],[12],[4]]
      assert FP.Structures.swap_nodes(nodes_data)
      == [[1,8,40,71,87,56,26,18,13,72,57,73,41,27,19,42,74,88,58,75,28,5,3,29,20,89,76,90,60,44,77,61,30,59,43,14,31,21,9,46,91,78,63,32,45,62,22,48,64,33,47,15,34,23,79,92,65,93,80,49,35,6,10,2,11,16,7,94,81,95,66,82,50,36,24,52,37,51,67,96,83,97,17,53,98,84,68,38,25,100,86,70,55,39,54,85,99,69,12,4],[1,8,72,57,73,41,27,19,42,74,88,58,75,28,13,40,71,87,56,26,18,5,3,31,21,14,29,20,89,76,90,60,44,77,61,30,59,43,9,34,23,79,92,65,93,80,49,35,15,46,91,78,63,32,45,62,22,48,64,33,47,6,10,2,11,16,7,53,98,84,68,38,25,100,86,70,55,39,54,85,99,69,17,94,81,95,66,82,50,36,24,52,37,51,67,96,83,97,12,4],[1,36,82,66,94,81,95,50,24,51,96,83,97,67,37,52,17,38,53,68,98,84,25,54,69,85,99,39,70,100,86,55,12,7,11,16,4,2,5,8,26,40,56,71,87,18,13,27,73,57,72,41,19,28,42,75,58,74,88,3,10,6,29,20,59,43,30,60,89,76,90,44,61,77,14,31,21,9,45,62,32,46,63,91,78,22,47,33,48,64,15,34,23,35,93,80,65,79,92,49],[1,4,38,68,98,84,53,25,69,85,99,54,39,55,70,100,86,17,36,50,82,66,94,81,95,24,96,83,97,67,51,37,52,12,7,11,16,2,10,6,31,21,14,29,20,43,59,30,61,77,44,60,89,76,90,9,34,23,35,49,93,80,65,79,92,15,62,45,32,63,91,78,46,22,47,33,64,48,3,5,8,27,41,73,57,72,19,28,75,58,74,88,42,13,26,56,71,87,40,18],[1,4,12,38,98,84,68,53,25,85,99,69,54,39,55,100,86,70,17,36,50,94,81,95,66,82,24,67,96,83,97,51,37,52,7,16,11,2,10,6,34,23,35,49,79,92,65,93,80,15,62,45,32,91,78,63,46,22,47,33,64,48,9,31,21,14,29,20,43,59,30,77,61,44,89,76,90,60,3,5,27,41,72,57,73,19,28,74,88,58,75,42,13,26,71,87,56,40,18,8],[1,4,12,85,99,69,54,39,55,100,86,70,25,38,98,84,68,53,17,67,96,83,97,51,37,52,24,36,50,94,81,95,66,82,7,16,11,2,10,6,35,49,79,92,65,93,80,23,34,15,47,33,64,48,22,62,45,32,91,78,63,46,9,21,31,14,43,59,30,77,61,44,89,76,90,60,20,29,3,5,28,74,88,58,75,42,19,27,41,72,57,73,13,18,26,71,87,56,40,8],[1,4,12,38,98,84,68,53,25,85,99,69,54,39,55,100,86,70,17,36,50,94,81,95,66,82,24,67,96,83,97,51,37,52,7,16,11,2,10,6,34,23,35,49,79,92,65,93,80,15,62,45,32,91,78,63,46,22,47,33,64,48,9,31,21,14,29,20,43,59,30,77,61,44,89,76,90,60,3,5,27,41,72,57,73,19,28,74,88,58,75,42,13,26,71,87,56,40,18,8],[1,4,38,68,98,84,53,25,69,85,99,54,39,55,70,100,86,17,36,50,82,66,94,81,95,24,96,83,97,67,51,37,52,12,7,11,16,2,10,6,31,21,14,29,20,43,59,30,61,77,44,60,89,76,90,9,34,23,35,49,93,80,65,79,92,15,62,45,32,63,91,78,46,22,47,33,64,48,3,5,8,27,41,73,57,72,19,28,75,58,74,88,42,13,26,56,71,87,40,18],[1,4,69,85,99,54,39,55,70,100,86,25,38,68,98,84,53,17,96,83,97,67,51,37,52,24,36,50,82,66,94,81,95,12,7,11,16,2,10,6,21,31,14,43,59,30,61,77,44,60,89,76,90,20,29,9,35,49,93,80,65,79,92,23,34,15,47,33,64,48,22,62,45,32,63,91,78,46,3,5,8,28,75,58,74,88,42,19,27,41,73,57,72,13,18,26,56,71,87,40],[40,87,71,56,26,18,13,72,57,73,41,27,19,42,88,74,58,75,28,8,5,3,46,78,91,63,32,45,62,22,48,64,33,47,15,34,23,92,79,65,80,93,49,35,9,29,20,90,76,89,60,44,77,61,30,59,43,14,31,21,6,10,2,16,11,7,12,95,81,94,66,82,50,36,24,52,37,51,67,97,83,96,17,53,84,98,68,38,25,86,100,70,55,39,54,99,85,69,4,1],[8,40,56,87,71,26,18,13,73,57,72,41,27,19,42,75,58,88,74,28,5,3,29,20,60,90,76,89,44,61,77,30,59,43,14,31,21,9,46,63,78,91,32,45,62,22,48,64,33,47,15,34,23,80,93,65,92,79,49,35,6,10,2,11,16,7,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,17,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,12,4,1],[8,73,57,72,41,27,19,42,75,58,88,74,28,13,40,56,87,71,26,18,5,3,31,21,14,29,20,60,90,76,89,44,61,77,30,59,43,9,34,23,80,93,65,92,79,49,35,15,46,63,78,91,32,45,62,22,48,64,33,47,6,10,2,11,16,7,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,17,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,12,4,1],[36,95,81,94,66,82,50,24,51,67,97,83,96,37,52,17,38,53,84,98,68,25,54,99,85,69,39,86,100,70,55,12,7,11,16,4,2,5,8,26,40,87,71,56,18,13,27,72,57,73,41,19,28,42,88,74,58,75,3,10,6,29,20,59,43,30,90,76,89,60,44,77,61,14,31,21,9,45,62,32,46,78,91,63,22,47,33,48,64,15,34,23,35,92,79,65,80,93,49,1],[95,81,94,66,82,50,36,24,52,37,51,67,97,83,96,17,53,84,98,68,38,25,86,100,70,55,39,54,99,85,69,12,7,11,16,4,2,5,8,40,87,71,56,26,18,13,72,57,73,41,27,19,42,88,74,58,75,28,3,10,6,29,20,90,76,89,60,44,77,61,30,59,43,14,31,21,9,46,78,91,63,32,45,62,22,48,64,33,47,15,34,23,92,79,65,80,93,49,35,1],[11,16,7,36,95,81,94,66,82,50,24,51,67,97,83,96,37,52,17,38,53,84,98,68,25,54,99,85,69,39,86,100,70,55,12,4,2,8,26,40,87,71,56,18,13,27,72,57,73,41,19,28,42,88,74,58,75,5,3,29,20,59,43,30,90,76,89,60,44,77,61,14,31,21,9,45,62,32,46,78,91,63,22,47,33,48,64,15,34,23,35,92,79,65,80,93,49,6,10,1],[11,16,7,38,53,84,98,68,25,54,99,85,69,39,86,100,70,55,17,36,95,81,94,66,82,50,24,51,67,97,83,96,37,52,12,4,2,8,27,72,57,73,41,19,28,42,88,74,58,75,13,26,40,87,71,56,18,5,3,31,21,14,29,20,59,43,30,90,76,89,60,44,77,61,9,34,23,35,92,79,65,80,93,49,15,45,62,32,46,78,91,63,22,47,33,48,64,6,10,1],[11,16,7,53,84,98,68,38,25,86,100,70,55,39,54,99,85,69,17,95,81,94,66,82,50,36,24,52,37,51,67,97,83,96,12,4,2,8,72,57,73,41,27,19,42,88,74,58,75,28,13,40,87,71,56,26,18,5,3,31,21,14,29,20,90,76,89,60,44,77,61,30,59,43,9,34,23,92,79,65,80,93,49,35,15,46,78,91,63,32,45,62,22,48,64,33,47,6,10,1],[11,16,7,53,84,98,68,38,25,86,100,70,55,39,54,99,85,69,17,95,81,94,66,82,50,36,24,52,37,51,67,97,83,96,12,4,2,8,72,57,73,41,27,19,42,88,74,58,75,28,13,40,87,71,56,26,18,5,3,31,21,14,29,20,90,76,89,60,44,77,61,30,59,43,9,34,23,92,79,65,80,93,49,35,15,46,78,91,63,32,45,62,22,48,64,33,47,6,10,1],[11,16,7,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,17,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,12,4,2,8,73,57,72,41,27,19,42,75,58,88,74,28,13,40,56,87,71,26,18,5,3,31,21,14,29,20,60,90,76,89,44,61,77,30,59,43,9,34,23,80,93,65,92,79,49,35,15,46,63,78,91,32,45,62,22,48,64,33,47,6,10,1],[11,16,7,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,17,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,12,4,2,8,40,56,87,71,26,18,13,73,57,72,41,27,19,42,75,58,88,74,28,5,3,29,20,60,90,76,89,44,61,77,30,59,43,14,31,21,9,46,63,78,91,32,45,62,22,48,64,33,47,15,34,23,80,93,65,92,79,49,35,6,10,1],[11,16,7,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,17,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,12,4,2,8,40,56,87,71,26,18,13,73,57,72,41,27,19,42,75,58,88,74,28,5,3,29,20,60,90,76,89,44,61,77,30,59,43,14,31,21,9,46,63,78,91,32,45,62,22,48,64,33,47,15,34,23,80,93,65,92,79,49,35,6,10,1],[11,16,7,82,66,94,81,95,50,36,24,52,37,51,96,83,97,67,17,53,68,98,84,38,25,70,100,86,55,39,54,69,85,99,12,4,2,8,40,56,71,87,26,18,13,73,57,72,41,27,19,42,75,58,74,88,28,5,3,29,20,60,89,76,90,44,61,77,30,59,43,14,31,21,9,46,63,91,78,32,45,62,22,48,64,33,47,15,34,23,93,80,65,79,92,49,35,6,10,1],[11,16,7,82,66,94,81,95,50,36,24,52,37,51,96,83,97,67,17,53,68,98,84,38,25,70,100,86,55,39,54,69,85,99,12,4,2,8,40,56,71,87,26,18,13,73,57,72,41,27,19,42,75,58,74,88,28,5,3,29,20,60,89,76,90,44,61,77,30,59,43,14,31,21,9,46,63,91,78,32,45,62,22,48,64,33,47,15,34,23,93,80,65,79,92,49,35,6,10,1],[11,16,7,36,82,66,94,81,95,50,24,51,96,83,97,67,37,52,17,38,53,68,98,84,25,54,69,85,99,39,70,100,86,55,12,4,2,8,26,40,56,71,87,18,13,27,73,57,72,41,19,28,42,75,58,74,88,5,3,29,20,59,43,30,60,89,76,90,44,61,77,14,31,21,9,45,62,32,46,63,91,78,22,47,33,48,64,15,34,23,35,93,80,65,79,92,49,6,10,1],[1,10,6,49,92,79,65,80,93,35,23,34,15,64,48,33,47,22,78,91,63,46,32,62,45,9,21,31,14,77,61,44,90,76,89,60,30,43,59,20,29,3,5,88,74,58,75,42,28,19,41,72,57,73,27,13,18,87,71,56,40,26,8,2,4,12,55,86,100,70,39,99,85,69,54,25,84,98,68,53,38,17,52,37,67,97,83,96,51,24,50,95,81,94,66,82,36,7,16,11],[1,10,6,34,23,49,92,79,65,80,93,35,15,78,91,63,46,32,62,45,22,64,48,33,47,9,31,21,14,29,20,77,61,44,90,76,89,60,30,43,59,3,5,41,72,57,73,27,19,88,74,58,75,42,28,13,87,71,56,40,26,18,8,2,4,12,84,98,68,53,38,25,55,86,100,70,39,99,85,69,54,17,50,95,81,94,66,82,36,24,52,37,67,97,83,96,51,7,16,11],[1,10,6,34,23,92,79,65,80,93,49,35,15,46,78,91,63,32,45,62,22,48,64,33,47,9,31,21,14,29,20,90,76,89,60,44,77,61,30,59,43,3,5,72,57,73,41,27,19,42,88,74,58,75,28,13,40,87,71,56,26,18,8,2,4,12,53,84,98,68,38,25,86,100,70,55,39,54,99,85,69,17,95,81,94,66,82,50,36,24,52,37,51,67,97,83,96,7,16,11],[1,5,87,71,56,40,26,18,13,41,72,57,73,27,19,88,74,58,75,42,28,8,3,10,6,78,91,63,46,32,62,45,22,64,48,33,47,15,34,23,49,92,79,65,80,93,35,9,29,20,77,61,44,90,76,89,60,30,43,59,14,31,21,2,12,50,95,81,94,66,82,36,24,52,37,67,97,83,96,51,17,84,98,68,53,38,25,55,86,100,70,39,99,85,69,54,7,16,11,4],[1,5,26,87,71,56,40,18,13,27,41,72,57,73,19,28,88,74,58,75,42,8,3,10,6,62,45,32,78,91,63,46,22,47,33,64,48,15,34,23,35,49,92,79,65,80,93,9,29,20,43,59,30,77,61,44,90,76,89,60,14,31,21,2,12,36,50,95,81,94,66,82,24,67,97,83,96,51,37,52,17,38,84,98,68,53,25,99,85,69,54,39,55,86,100,70,7,16,11,4],[1,5,18,26,87,71,56,40,13,28,88,74,58,75,42,19,27,41,72,57,73,8,3,10,6,47,33,64,48,22,62,45,32,78,91,63,46,15,35,49,92,79,65,80,93,23,34,9,43,59,30,77,61,44,90,76,89,60,20,29,14,21,31,2,12,67,97,83,96,51,37,52,24,36,50,95,81,94,66,82,17,99,85,69,54,39,55,86,100,70,25,38,84,98,68,53,7,16,11,4],[1,16,11,7,12,55,70,86,100,39,69,99,85,54,25,68,84,98,53,38,17,52,37,97,83,96,67,51,24,50,82,66,95,81,94,36,4,2,75,58,88,74,42,28,19,41,73,57,72,27,13,18,56,87,71,40,26,8,5,3,49,80,93,65,92,79,35,23,34,15,64,48,33,47,22,63,78,91,46,32,62,45,9,21,31,14,61,77,44,60,90,76,89,30,43,59,20,29,6,10],[1,16,11,7,12,68,84,98,53,38,25,55,70,86,100,39,69,99,85,54,17,50,82,66,95,81,94,36,24,52,37,97,83,96,67,51,4,2,41,73,57,72,27,19,75,58,88,74,42,28,13,56,87,71,40,26,18,8,5,3,34,23,49,80,93,65,92,79,35,15,63,78,91,46,32,62,45,22,64,48,33,47,9,31,21,14,29,20,61,77,44,60,90,76,89,30,43,59,6,10],[1,16,11,7,12,38,68,84,98,53,25,69,99,85,54,39,55,70,86,100,17,36,50,82,66,95,81,94,24,97,83,96,67,51,37,52,4,2,27,41,73,57,72,19,28,75,58,88,74,42,13,26,56,87,71,40,18,8,5,3,34,23,35,49,80,93,65,92,79,15,62,45,32,63,78,91,46,22,47,33,64,48,9,31,21,14,29,20,43,59,30,61,77,44,60,90,76,89,6,10],[1,4,16,11,7,12,36,82,66,95,81,94,50,24,51,97,83,96,67,37,52,17,38,53,68,84,98,25,54,69,99,85,39,70,86,100,55,2,45,62,32,46,63,78,91,22,47,33,48,64,15,34,23,35,80,93,65,92,79,49,9,29,20,59,43,30,60,90,76,89,44,61,77,14,31,21,6,10,3,26,40,56,87,71,18,13,27,73,57,72,41,19,28,42,75,58,88,74,8,5],[1,4,16,11,7,12,82,66,95,81,94,50,36,24,52,37,51,97,83,96,67,17,53,68,84,98,38,25,70,86,100,55,39,54,69,99,85,2,46,63,78,91,32,45,62,22,48,64,33,47,15,34,23,80,93,65,92,79,49,35,9,29,20,60,90,76,89,44,61,77,30,59,43,14,31,21,6,10,3,40,56,87,71,26,18,13,73,57,72,41,27,19,42,75,58,88,74,28,8,5],[1,4,16,11,7,12,50,82,66,95,81,94,36,24,52,37,97,83,96,67,51,17,68,84,98,53,38,25,55,70,86,100,39,69,99,85,54,2,63,78,91,46,32,62,45,22,64,48,33,47,15,34,23,49,80,93,65,92,79,35,9,29,20,61,77,44,60,90,76,89,30,43,59,14,31,21,6,10,3,56,87,71,40,26,18,13,41,73,57,72,27,19,75,58,88,74,42,28,8,5],[1,4,16,11,7,12,52,37,97,83,96,67,51,24,50,82,66,95,81,94,36,17,55,70,86,100,39,69,99,85,54,25,68,84,98,53,38,2,64,48,33,47,22,63,78,91,46,32,62,45,15,49,80,93,65,92,79,35,23,34,9,61,77,44,60,90,76,89,30,43,59,20,29,14,21,31,6,10,3,18,56,87,71,40,26,13,75,58,88,74,42,28,19,41,73,57,72,27,8,5],[1,4,16,11,7,12,52,37,51,97,83,96,67,24,82,66,95,81,94,50,36,17,70,86,100,55,39,54,69,99,85,25,53,68,84,98,38,2,48,64,33,47,22,46,63,78,91,32,45,62,15,80,93,65,92,79,49,35,23,34,9,60,90,76,89,44,61,77,30,59,43,20,29,14,21,31,6,10,3,18,40,56,87,71,26,13,42,75,58,88,74,28,19,73,57,72,41,27,8,5],[1,4,16,11,7,12,52,37,97,83,96,67,51,24,50,82,66,95,81,94,36,17,55,70,86,100,39,69,99,85,54,25,68,84,98,53,38,2,64,48,33,47,22,63,78,91,46,32,62,45,15,49,80,93,65,92,79,35,23,34,9,61,77,44,60,90,76,89,30,43,59,20,29,14,21,31,6,10,3,18,56,87,71,40,26,13,75,58,88,74,42,28,19,41,73,57,72,27,8,5],[1,4,16,11,7,12,97,83,96,67,51,37,52,24,36,50,82,66,95,81,94,17,69,99,85,54,39,55,70,86,100,25,38,68,84,98,53,2,47,33,64,48,22,62,45,32,63,78,91,46,15,35,49,80,93,65,92,79,23,34,9,43,59,30,61,77,44,60,90,76,89,20,29,14,21,31,6,10,3,18,26,56,87,71,40,13,28,75,58,88,74,42,19,27,41,73,57,72,8,5],[1,4,16,11,7,12,96,83,97,67,51,37,52,24,36,50,82,66,94,81,95,17,69,85,99,54,39,55,70,100,86,25,38,68,98,84,53,2,47,33,64,48,22,62,45,32,63,91,78,46,15,35,49,93,80,65,79,92,23,34,9,43,59,30,61,77,44,60,89,76,90,20,29,14,21,31,6,10,3,18,26,56,71,87,40,13,28,75,58,74,88,42,19,27,41,73,57,72,8,5],[1,4,16,11,7,12,67,96,83,97,51,37,52,24,36,50,94,81,95,66,82,17,85,99,69,54,39,55,100,86,70,25,38,98,84,68,53,2,47,33,64,48,22,62,45,32,91,78,63,46,15,35,49,79,92,65,93,80,23,34,9,43,59,30,77,61,44,89,76,90,60,20,29,14,21,31,6,10,3,18,26,71,87,56,40,13,28,74,88,58,75,42,19,27,41,72,57,73,8,5],[1,4,12,52,37,67,96,83,97,51,24,50,94,81,95,66,82,36,17,55,100,86,70,39,85,99,69,54,25,98,84,68,53,38,7,16,11,2,10,6,64,48,33,47,22,91,78,63,46,32,62,45,15,49,79,92,65,93,80,35,23,34,9,77,61,44,89,76,90,60,30,43,59,20,29,14,21,31,3,5,18,71,87,56,40,26,13,74,88,58,75,42,28,19,41,72,57,73,27,8],[1,4,12,52,37,67,96,83,97,51,24,50,94,81,95,66,82,36,17,55,100,86,70,39,85,99,69,54,25,98,84,68,53,38,7,16,11,2,10,6,64,48,33,47,22,91,78,63,46,32,62,45,15,49,79,92,65,93,80,35,23,34,9,77,61,44,89,76,90,60,30,43,59,20,29,14,21,31,3,5,18,71,87,56,40,26,13,74,88,58,75,42,28,19,41,72,57,73,27,8],[1,4,16,11,7,12,67,96,83,97,51,37,52,24,36,50,94,81,95,66,82,17,85,99,69,54,39,55,100,86,70,25,38,98,84,68,53,2,47,33,64,48,22,62,45,32,91,78,63,46,15,35,49,79,92,65,93,80,23,34,9,43,59,30,77,61,44,89,76,90,60,20,29,14,21,31,6,10,3,18,26,71,87,56,40,13,28,74,88,58,75,42,19,27,41,72,57,73,8,5]]
    end

  end

  describe "structures - matrix" do
    @describetag :matrix

    # tests for matrix rotation challenge
    # https://www.hackerrank.com/challenges/matrix-rotation/problem
    test "deconstruct - Matrix rotation, 'unfold' matrix into a format appropriate for 1D manipulation" do
      matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
      assert deconstruct(matrix)
      == {[[6, 7, 11, 10], [1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5]], [{2, 2}, {4, 4}]}

      matrix = [[1,2,3,4],[7,8,9,10],[13,14,15,16],[19,20,21,22],[25,26,27,28]]
      assert deconstruct(matrix)
      == {[[8, 9, 15, 21, 20, 14],[1, 2, 3, 4, 10, 16, 22, 28, 27, 26, 25, 19, 13, 7]], [{3, 2}, {5, 4}]}
      
      matrix = [[1,1],[1,1]]
      assert deconstruct(matrix)
      == {[[1, 1, 1, 1]], [{2, 2}]}
    end

    test "reconstruct - Matrix rotation, reconstruct rotated matrix data back into its original dimension" do
      {matrix, dim} = {[[6, 7, 11, 10], [1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5]],[{2, 2}, {4, 4}]}
      reconstructed = []

      assert reconstruct(matrix, reconstructed, dim)
      == [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]

      {matrix, dim} = {[[8, 9, 15, 21, 20, 14],[1, 2, 3, 4, 10, 16, 22, 28, 27, 26, 25, 19, 13, 7]], [{3, 2}, {5, 4}]}
      assert reconstruct(matrix, reconstructed, dim)
      == [[1,2,3,4],[7,8,9,10],[13,14,15,16],[19,20,21,22],[25,26,27,28]]
      
      {matrix, dim} = {[[1, 1, 1, 1]], [{2, 2}]}
      assert reconstruct(matrix, reconstructed, dim)
      == [[1, 1], [1, 1]]
    end

    test "shift - Matrix rotation, shift deconstructed matrix to imitate rotation" do
      {matrix, _dim} = {[[6, 7, 11, 10], [1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5]],[{2, 2}, {4, 4}]}

      assert shift(matrix, 2)
      == [[11, 10, 6, 7], [3, 4, 8, 12, 16, 15, 14, 13, 9, 5, 1, 2]]
    end

    test "rotate - Matrix rotation, main function puts everything together" do
      matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
      times = 2

      assert rotate(matrix, times)
      == [[3, 4, 8, 12], [2, 11, 10, 16], [1, 7, 6, 15], [5, 9, 13, 14]]

      matrix = [[1,2,3,4],[7,8,9,10],[13,14,15,16],[19,20,21,22],[25,26,27,28]]
      times = 7

      assert rotate(matrix, times)
      == [[28,27,26,25],[22,9,15,19],[16,8,21,13],[10,14,20,7],[4,3,2,1]]
    end
  end

  describe "structures - misc" do
    @describetag :misc

    #https://www.hackerrank.com/challenges/kmp-fp/problem
    test "kmp_string_search - Substring search, basic algorithm " do
      assert kmp_string_search("abcdef", "def") == "YES"
      assert kmp_string_search("computer", "muter") == "NO"
      assert kmp_string_search("stringmatchingmat", "ingmat") == "YES"
      assert kmp_string_search("videobox", "videobox") == "YES"
    end

    test "kmp_string_search - Substring search, KMP algorithm " do
      assert kmp_string_search("abcdeedef", "def") == "YES"
      assert kmp_string_search("abceabcdabeabcdabcdabde", "abcdabd") == "YES"

      {s,p} = {"abcdeedef", "def"}
      assert kmp_string_search(s,p) == "YES"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "YES"

      {s,p} = {"abceabcdabeabcdabcdabde", "abcdabd"}
      assert kmp_string_search(s,p) == "YES"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "YES"

      {s,p} = {"aaaba", "aaaa"}
      assert kmp_string_search(s,p) == "NO"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "NO"

      {s,p} = {"aaabaa", "aaaa"}
      assert kmp_string_search(s,p) == "NO"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "NO"

      {s,p} = {"aaabaaa", "aaaa"}
      assert kmp_string_search(s,p) == "NO"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "NO"

      {s,p} = {"aaabaaaa", "aaaa"}
      assert kmp_string_search(s,p) == "YES"
      assert kmp_string_search(s |> String.split("", trim: true), p |> String.split("", trim: true)) == "YES"
    end

    #https://www.hackerrank.com/challenges/john-and-fences/problem
    test "fence_spans - John and fences, first find fence spans that achieve at least a given height" do
      heights = [2,5,7,4,1,8]
      spans = []

      height = 2
      assert fence_spans(heights, spans, height) == [1, 1, 1, 1, 0, 1] # '1's denotes corresponding fences

      height = 5
      assert fence_spans(heights, spans, height) == [0, 1, 1, 0, 0, 1]
    end

    test "max_span - find the max contiguous span from a binary list of fence spans" do
      fence_spans = [1, 1, 1, 1, 0, 1]
      assert max_span(fence_spans) == 4

      fence_spans = [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1]
      assert max_span(fence_spans) == 3

      fence_spans = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      assert max_span(fence_spans) == 11

      fence_spans = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      assert max_span(fence_spans) == 0
    end

  end

end
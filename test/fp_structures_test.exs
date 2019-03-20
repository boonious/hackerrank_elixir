defmodule FPStructuresTest do
  use ExUnit.Case
  import FP.Structures

  doctest FP.Structures

  describe "structures" do
    @describetag :structures

    test "n - binary tree node creation / addition" do
      assert n(1) ==  %{l: nil, r: nil, v: 1}

      depth = 2
      assert n(1) |> add([2,3], depth) == %{v: 1, l: %{l: nil, r: nil, v: 2}, r: %{l: nil, r: nil, v: 3}}
    end

    test "build_tree - binary tree building" do
      assert build_tree([[2, 3]]) ==  {2, %{l: %{l: nil, r: nil, v: 2}, r: %{l: nil, r: nil, v: 3}, v: 1}}
      assert build_tree([[2, 3], [-1, -1], [-1, -1]])
      == {
        3, 
        %{
          v: 1,
          l: %{v: 2, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
          r: %{v: 3, l: %{l: nil, r: nil, v: -1}, r: %{l: nil, r: nil, v: -1}},
        }
      }

      assert build_tree([[2, 3], [-1, 4], [-1, 5], [-1, -1], [-1, -1]])
      == {
        4,
        %{
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
      }
    end
    
    test "build_tree - binary tree building: large and unbalanced" do
      assert build_tree([[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, -1],[-1, -1],[-1, -1]])
      == {
        5,
          %{
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
      }

      assert build_tree([[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, 9],[-1, -1],[10, 11],[-1, -1],[-1, -1],[-1, -1]])
      == {
        6,
        %{
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
      }

      assert build_tree([[2, 3],[4, 5],[6, -1],[-1, 7],[8, 9],[10, 11],[12, 13],[-1, 14],[-1, -1],[15, -1],[16, 17],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1]])
      == {
        6,
        %{
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
      }
    end

    test "swap - swap function which returns binary tree as Map" do
      {depth, tree} = build_tree([[2, 3], [-1, -1], [-1, -1]])
      k = [1,2]

      assert FP.Structures.swap(tree, depth, k)
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

      {depth, tree} = build_tree([[2, 3], [-1, 4], [-1, 5], [-1, -1], [-1, -1]])
      k = [2]

      assert FP.Structures.swap(tree, depth, k)
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
      {_, tree} = build_tree([[2, 3], [-1, -1], [-1, -1]])
      assert FP.Structures.inorder_traverse(tree) == [2,1,3]

      {_, tree} = build_tree([[2, 3],[4, -1],[5, -1],[-1, -1],[-1, -1]])
      assert FP.Structures.inorder_traverse(tree) == [4,2,1,5,3]

      {_, tree} = build_tree([[2, 3], [-1, 4], [-1, 5],[-1, -1],[-1, -1]])
      assert FP.Structures.inorder_traverse(tree) == [2,4,1,3,5]

      {_, tree} = build_tree([[2, 3],[4, -1],[5, -1],[6, -1],[7, 8],[-1, 9],[-1, -1],[10, 11],[-1, -1],[-1, -1],[-1, -1]])
      assert FP.Structures.inorder_traverse(tree) == [6,9,4,2,1,7,5,10,8,11,3]

      {_, tree} = build_tree([[2, 3],[4, 5],[6, -1],[-1, 7],[8, 9],[10, 11],[12, 13],[-1, 14],[-1, -1],[15, -1],[16, 17],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1],[-1, -1]])
      assert FP.Structures.inorder_traverse(tree) == [4,12,7,13,2,8,14,5,9,1,15,10,6,16,11,17,3]
    end

  end

end
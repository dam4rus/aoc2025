defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  def input, do: ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."

  test "input parsed correctly" do
    assert Day7.parse_input(input()) ==
             {7,
              [
                [7],
                [6, 8],
                [5, 7, 9],
                [4, 6, 10],
                [3, 5, 9, 11],
                [2, 6, 12],
                [1, 3, 5, 7, 9, 13]
              ]}
  end

  test "part one" do
    assert input() |> Day7.count_splits_in_input() == 21
  end

  # test "timeline returns correct sum" do
  #   {start, splitters} = input() |> Day7.parse_input()
  #   assert Day7.timeline(%{start => 1}, splitters) == 40
  # end

  test "part two" do
    assert input() |> Day7.count_timelines_in_input() == 40
  end
end

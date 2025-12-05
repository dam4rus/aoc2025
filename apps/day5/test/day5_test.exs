defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  defp input, do: "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

  test "is ingredient fresh" do
    assert Day5.is_fresh?(5, [3..5, 10..14, 16..20, 12..18])
  end

  test "input parsed correctly" do
    assert Day5.parse_input(input()) == {[3..5, 10..14, 16..20, 12..18], [1, 5, 8, 11, 17, 32]}
  end

  test "part one" do
    assert Day5.count_fresh_ingredients(input()) == 3
  end

  test "part two" do
    assert Day5.merge_ranges(
             [3..5, 10..14, 16..20, 12..18]
             |> Enum.sort_by(fn %Range{first: first} -> first end)
           )
           |> Enum.sum_by(&Range.size/1) == 14
  end
end

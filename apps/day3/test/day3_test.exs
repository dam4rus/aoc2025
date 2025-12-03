defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  defp input, do: "987654321111111
811111111111119
234234234234278
818181911112111"

  test "returns highest joltage for first line" do
    assert Day3.joltage("987654321111111") == 98
  end

  test "returns highest joltage for second line" do
    assert Day3.joltage("811111111111119") == 89
  end

  test "returns highest joltage for third line" do
    assert Day3.joltage("234234234234278") == 78
  end

  test "returns highest joltage for fourth line" do
    assert Day3.joltage("818181911112111") == 92
  end

  test "returns highest joltage for first line with 12 turns" do
    assert Day3.joltage("987654321111111", 12) == 987_654_321_111
  end

  test "returns highest joltage for second line with 12 turns" do
    assert Day3.joltage("811111111111119", 12) == 811_111_111_119
  end

  test "returns highest joltage for third line with 12 turns" do
    assert Day3.joltage("234234234234278", 12) == 434_234_234_278
  end

  test "returns highest joltage for fourth line with 12 turns" do
    assert Day3.joltage("818181911112111", 12) == 888_911_112_111
  end

  test "part one" do
    assert Day3.joltage_sum(input()) == 357
  end

  test "part two" do
    assert Day3.joltage_sum(input(), 12) == 3_121_910_778_619
  end
end

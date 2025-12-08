defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  defp input, do: "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   + "

  test "parses input correctly" do
    assert Day6.parse_input(input(), :human) ==
             {[[6, 45, 123], [98, 64, 328], [215, 387, 51], [314, 23, 64]], ["*", "+", "*", "+"]}
  end

  test "parses cephalopod input corrently" do
    assert Day6.parse_input(input(), :cephalopod) ==
             {[[1, 24, 356], [369, 248, 8], [32, 581, 175], [623, 431, 4]], ["*", "+", "*", "+"]}
  end

  test "solve multiply" do
    assert Day6.solve([123, 45, 6], "*") == 33210
  end

  test "solve add" do
    assert Day6.solve([328, 64, 98], "+") == 490
  end

  test "part one" do
    assert Day6.sum_problems(input(), :human) == 4_277_556
  end

  test "part two" do
    assert Day6.sum_problems(input(), :cephalopod) == 3_263_827
  end
end

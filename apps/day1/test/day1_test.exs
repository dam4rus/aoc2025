defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "rotate left" do
    assert Day1.rotate(50, :left, 1) == 49
  end

  test "rotate left overflow" do
    assert Day1.rotate(50, :left, 51) == 99
  end

  test "rotate left multiple overflow" do
    assert Day1.rotate(50, :left, 201) == 49
  end

  test "rotate right" do
    assert Day1.rotate(50, :right, 1) == 51
  end

  test "rotate right overflow" do
    assert Day1.rotate(50, :right, 51) == 1
  end

  test "rotate right multiple overflow" do
    assert Day1.rotate(50, :right, 201) == 51
  end

  test "single rotate line" do
    assert Day1.process_input(["L50"]) == 1
  end

  test "multiple rotate line" do
    assert Day1.process_input(["L51", "R1"]) == 1
  end

  test "multiple rotate line with rotation at 100" do
    assert Day1.process_input(["L51", "R1", "R200"]) == 2
  end

  @test_input "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  test "part one with test input" do
    assert Day1.process_input(String.split(@test_input, "\n")) == 3
  end
end

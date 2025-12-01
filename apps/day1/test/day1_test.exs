defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  # test "rotate left" do
  #   assert Day1.rotate(50, :left, 1) == {49, 0}
  # end

  # test "rotate left overflow" do
  #   assert Day1.rotate(50, :left, 51) == {99, 1}
  # end

  # test "rotate left multiple overflow" do
  #   assert Day1.rotate(50, :left, 201) == {49, 2}
  # end

  # test "rotate right" do
  #   assert Day1.rotate(50, :right, 1) == {51, 0}
  # end

  # test "rotate right overflow" do
  #   assert Day1.rotate(50, :right, 51) == {1, 1}
  # end

  # test "rotate right multiple overflow" do
  #   assert Day1.rotate(50, :right, 201) == {51, 2}
  # end

  # test "single rotate line" do
  #   assert Day1.process_input(["L50"], :single) == 1
  # end

  # test "multiple rotate line" do
  #   assert Day1.process_input(["L51", "R1"], :single) == 1
  # end

  # test "multiple rotate line with rotation over 100" do
  #   assert Day1.process_input(["L51", "R1", "R200"], :single) == 2
  # end

  # test "multiple rotate line with rotation over 100 using multiple password method" do
  #   assert Day1.process_input(["L51", "R1", "R200"], :multiple) == 4
  # end

  # test "anyad" do
  #   assert Day1.process_input(["L50", "L200"], :multiple) == 3
  # end

  # test "anyad2" do
  #   assert Day1.process_input(["R50", "R200", "L200"], :multiple) == 5
  # end

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

  # test "part one with test input" do
  #   assert Day1.process_input(String.split(@test_input, "\n"), :single) == 3
  # end

  test "part two with test input" do
    assert Day1.process_input(String.split(@test_input, "\n"), :multiple) == 6
  end
end

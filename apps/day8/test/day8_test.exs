defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  def input, do: "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"

  test "calculate distances returns all distance" do
    assert input() |> Day8.parse_input() |> Day8.calculate_distances() |> length() == 190
  end

  test "connects points" do
    assert Day8.product_of_connections(input(), 10) == 40
  end

  test "appends connection to empty accumulator" do
    assert Day8.connect([{{162, 817, 812}, {425, 690, 689}, 0.0}], []) == [
             [
               {162, 817, 812},
               {425, 690, 689}
             ]
           ]
  end

  test "appends connection to existing fuse box" do
    assert Day8.connect([{{162, 817, 812}, {431, 825, 988}, 0.0}], [
             [{162, 817, 812}, {425, 690, 689}]
           ]) == [
             [
               {431, 825, 988},
               {162, 817, 812},
               {425, 690, 689}
             ]
           ]
  end

  test "appends connection to a new fuse box" do
    assert Day8.connect([{{906, 360, 560}, {805, 96, 715}, 0.0}], [
             [{431, 825, 988}, {162, 817, 812}, {425, 690, 689}]
           ]) == [
             [
               {906, 360, 560},
               {805, 96, 715}
             ],
             [
               {431, 825, 988},
               {162, 817, 812},
               {425, 690, 689}
             ]
           ]
  end

  test "does no appends" do
    assert Day8.connect([{{431, 825, 988}, {425, 690, 689}, 0.0}], [
             [
               {431, 825, 988},
               {162, 817, 812},
               {425, 690, 689}
             ],
             [
               {906, 360, 560},
               {805, 96, 715}
             ]
           ]) == [
             [
               {431, 825, 988},
               {162, 817, 812},
               {425, 690, 689}
             ],
             [
               {906, 360, 560},
               {805, 96, 715}
             ]
           ]
  end

  test "connect until the end" do
    assert input()
           |> Day8.multiply_x_coordinates_of_last_two_junction_boxes_that_needs_to_be_connected() ==
             25272
  end
end

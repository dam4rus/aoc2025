defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  defp test_input(),
    do:
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  test "identifies invalid id" do
    assert Day2.is_invalid?("11")
    assert Day2.is_invalid?("22")
    assert Day2.is_invalid?("99")
    assert Day2.is_invalid?("1010")
    assert Day2.is_invalid?("1188511885")
    assert Day2.is_invalid?("38593859")
  end

  test "111 is invalid when using chunk size 1" do
    assert Day2.is_invalid?("111", 1)
  end

  test "2121212121 is invalid when using chunk size 2" do
    assert Day2.is_invalid?("2121212121", 2)
  end

  test "identifies valid id" do
    assert Day2.is_invalid?("10") == false
    assert Day2.is_invalid?("20") == false
    assert Day2.is_invalid?("1188611885") == false
  end

  test "invalid ids between 11-22 should be 2" do
    assert Day2.invalid_ids_in_range(11..22, :at_most_twice) == [11, 22]
  end

  test "part one" do
    assert Day2.sum_invalid_ids(test_input(), :at_most_twice) == 1_227_775_554
  end

  test "part two" do
    assert Day2.sum_invalid_ids(test_input(), :at_least_twice) == 4_174_379_265
  end
end

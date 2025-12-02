defmodule Day2 do
  def is_invalid?(input) when is_binary(input) do
    with input_length <- String.length(input),
         0 <- input_length |> rem(2),
         {lhs, rhs} <- String.split_at(input, input_length |> div(2)) do
      lhs == rhs
    else
      _ -> false
    end
  end

  def invalid_ids_in_range(range = %Range{}) do
    range
    |> Enum.filter(fn n -> Integer.to_string(n) |> is_invalid? end)
  end

  def invalid_ids_in_range({first, last}) do
    invalid_ids_in_range(Range.new(first, last))
  end

  def sum_invalid_ids(input) when is_binary(input) do
    input
    |> String.split(",")
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.map(fn [first, last] -> {String.to_integer(first), String.to_integer(last)} end)
    |> Stream.flat_map(&invalid_ids_in_range/1)
    |> Enum.reduce(&+/2)
  end

  def sum_invalid_ids() do
    sum_invalid_ids(Day2Input.input())
  end
end

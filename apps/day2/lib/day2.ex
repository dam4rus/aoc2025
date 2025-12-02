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

  def is_invalid?(input, chunk_size) when is_binary(input) and chunk_size > 0 do
    [head | tail] =
      String.graphemes(input) |> Enum.chunk_every(chunk_size, chunk_size, Stream.cycle([-1]))

    tail |> Enum.all?(fn value -> value == head end)
  end

  def invalid_ids_in_range(range = %Range{}, :at_most_twice) do
    range
    |> Enum.filter(fn n -> Integer.to_string(n) |> is_invalid? end)
  end

  def invalid_ids_in_range(range = %Range{}, :at_least_twice) do
    range
    |> Enum.filter(fn n ->
      value = Integer.to_string(n)

      case String.length(value) |> div(2) do
        last when last < 1 -> false
        last -> 1..last |> Enum.any?(&is_invalid?(value, &1))
      end
    end)
  end

  def invalid_ids_in_range({first, last}, method) do
    invalid_ids_in_range(Range.new(first, last), method)
  end

  def sum_invalid_ids(input, method) when is_binary(input) do
    input
    |> String.split(",")
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.map(fn [first, last] -> {String.to_integer(first), String.to_integer(last)} end)
    |> Stream.flat_map(&invalid_ids_in_range(&1, method))
    |> Stream.uniq()
    |> Enum.reduce(&+/2)
  end

  def sum_invalid_ids(method) do
    sum_invalid_ids(Day2Input.input(), method)
  end
end

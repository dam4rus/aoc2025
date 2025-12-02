defmodule Day2 do
  @type method() :: :at_most_twice | :at_least_twice

  @doc """
  Returns whether the given input is an invalid ID with at most twice duplication.
  """
  @spec is_invalid?(String.t()) :: boolean()
  def is_invalid?(input) when is_binary(input) do
    with input_length <- String.length(input),
         0 <- input_length |> rem(2),
         {lhs, rhs} <- String.split_at(input, input_length |> div(2)) do
      lhs == rhs
    else
      _ -> false
    end
  end

  @doc """
  Returns whether the given input is an invalid ID with at least twice duplication.
  """
  @spec is_invalid?(String.t(), integer()) :: boolean()
  def is_invalid?(input, chunk_size) when is_binary(input) and chunk_size > 0 do
    # For the left-over chunk `:invalid` values are appended, so it does not equal to head
    [head | tail] =
      String.graphemes(input)
      |> Enum.chunk_every(chunk_size, chunk_size, Stream.cycle([:invalid]))

    tail |> Enum.all?(fn value -> value == head end)
  end

  @doc """
  Finds invalid IDs in the given range.

  Range can be either a tuple of `{first, last}` or a `Range` instance.

  Search method can be either `:at_most_twice` to find ids that only repeat a given pattern twice
  or `:at_least_twice` to find ids that repeats twice or multiple times.
  """
  @spec invalid_ids_in_range({number(), number()} | Range.t(), method()) :: [String.t()]
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

  @doc """
  Sum invalid ID values.
  """
  @spec sum_invalid_ids(String.t(), method()) :: integer()
  def sum_invalid_ids(input, method) when is_binary(input) do
    input
    |> String.split(",")
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.map(fn [first, last] -> {String.to_integer(first), String.to_integer(last)} end)
    |> Stream.flat_map(&invalid_ids_in_range(&1, method))
    |> Stream.uniq()
    |> Enum.reduce(&+/2)
  end

  @spec sum_invalid_ids(method()) :: integer()
  def sum_invalid_ids(method) do
    sum_invalid_ids(Day2Input.input(), method)
  end
end

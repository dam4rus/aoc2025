defmodule Day3 do
  @doc """
  Finds the joltage with brute force when only 2 batteries has to be turned on
  """
  @spec joltage(String.t()) :: integer()
  def joltage(line) when is_bitstring(line) do
    graphemes = String.graphemes(line)

    graphemes
    |> Stream.with_index()
    |> Stream.take(String.length(line) - 1)
    |> Stream.flat_map(fn {first, index} ->
      graphemes
      |> Stream.drop(index + 1)
      |> Stream.map(fn second -> String.to_integer(first <> second) end)
    end)
    |> Enum.max()
  end

  @doc """
  Finds the joltage when 12 batteries has to be turned on.
  """
  @spec joltage(String.t(), integer()) :: integer()
  def joltage(line, 12) when is_bitstring(line) do
    graphemes = String.graphemes(line)
    line_length = String.length(line)
    # Define how many batteries will be not turned on.
    skip_count = line_length - 12

    initial_state = %{start_index: 0, skip_count: skip_count}

    Stream.unfold(initial_state, fn %{
                                      start_index: start_index,
                                      skip_count: skip_count
                                    } ->
      case skip_count do
        # No more batteries will be left turned off at this point. Just return each remaining battery.
        0 ->
          {
            graphemes |> Enum.at(start_index),
            %{
              start_index: start_index + 1,
              skip_count: 0
            }
          }

        # Find the greatest number in a subset when there are still batteries that will be left turned off.
        skip_count ->
          subset = Enum.slice(graphemes, start_index..(start_index + skip_count))

          max = subset |> Enum.max()
          index = subset |> Enum.find_index(fn n -> n == max end)

          {
            max,
            %{
              # The batteries before the greatest number will be never turned off.
              start_index: start_index + index + 1,
              # Reduce how many batteries will not be turned on by the index in the subset of batteries.
              skip_count: skip_count - index
            }
          }
      end
    end)
    |> Stream.take(12)
    |> Enum.join()
    |> String.to_integer()
  end

  @spec joltage_sum(String.t() | integer()) :: integer()
  def joltage_sum(12), do: joltage_sum(Day3Input.input(), 12)

  def joltage_sum(lines) when is_bitstring(lines) do
    String.split(lines, "\n") |> Stream.map(&joltage/1) |> Enum.sum()
  end

  @spec joltage_sum(String.t() | integer()) :: integer()
  def joltage_sum(lines, 12) when is_bitstring(lines) do
    String.split(lines, "\n") |> Stream.map(&joltage(&1, 12)) |> Enum.sum()
  end

  @spec joltage_sum() :: integer()
  def joltage_sum(), do: joltage_sum(Day3Input.input())
end

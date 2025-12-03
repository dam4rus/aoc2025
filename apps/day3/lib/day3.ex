defmodule Day3 do
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

  def joltage_sum(lines) when is_bitstring(lines) do
    String.split(lines, "\n") |> Stream.map(&joltage/1) |> Enum.sum()
  end

  def joltage_sum(), do: joltage_sum(Day3Input.input())
end

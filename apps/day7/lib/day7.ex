defmodule Day7 do
  @doc """
  Parses the input.

  Returns a tuple consisting of the x coordinate of the starting position and the x positions of all splitters in each line.
  """
  @spec parse_input(String.t()) :: {non_neg_integer(), [[non_neg_integer()]]}
  def parse_input(input) when is_bitstring(input) do
    {[first_line], rest} =
      String.split(input, "\n")
      |> Enum.split(1)

    start = String.graphemes(first_line) |> Enum.find_index(fn c -> c == "S" end)

    splitters =
      Stream.drop_every(rest, 2)
      |> Enum.map(fn line ->
        String.graphemes(line)
        |> Stream.with_index()
        |> Stream.filter(fn {c, _} -> c == "^" end)
        |> Enum.map(fn {_, x} -> x end)
      end)

    {start, splitters}
  end

  @doc """
  Count all splits in the given input.
  """
  @spec count_splits_in_input(String.t()) :: non_neg_integer()
  def count_splits_in_input(input) when is_bitstring(input) do
    {start, splitters} = input |> Day7.parse_input()
    project([start], splitters, 0)
  end

  @doc """
  Count all timelines in the given input.
  """
  @spec count_timelines_in_input(String.t()) :: non_neg_integer()
  def count_timelines_in_input(input) when is_bitstring(input) do
    {start, splitters} = Day7.parse_input(input)
    timeline(%{start => 1}, splitters)
  end

  @spec project([non_neg_integer()], [[non_neg_integer()]], non_neg_integer()) ::
          non_neg_integer()
  defp project(_beams, [], splits), do: splits

  defp project(beams, [splitters | tail], splits) when is_integer(splits) do
    beam_set = MapSet.new(beams)
    splitter_set = MapSet.new(splitters)

    intersecting_beams = MapSet.intersection(beam_set, splitter_set)

    # Beams that intersect with a splitter creates 2 new beams
    new_beams = Enum.flat_map(intersecting_beams, fn x -> [x - 1, x + 1] end)
    # Non intersecting beams continues downwards
    non_intersecting_beams = MapSet.difference(beam_set, splitter_set) |> MapSet.to_list()

    project(
      (new_beams ++ non_intersecting_beams) |> Enum.uniq(),
      tail,
      splits + MapSet.size(intersecting_beams)
    )
  end

  @spec timeline(%{non_neg_integer() => non_neg_integer()}, [[non_neg_integer()]]) ::
          non_neg_integer()
  defp timeline(%{} = beams, []), do: beams |> Map.values() |> Enum.sum()

  defp timeline(%{} = beams, [splitters | tail]) do
    beam_set = MapSet.new(beams |> Map.keys())
    splitter_set = MapSet.new(splitters)

    intersecting_beams = MapSet.intersection(beam_set, splitter_set)

    # All beams that intersect with a splitter creates 2 new beams.
    new_beams =
      Enum.reduce(intersecting_beams, %{}, fn x, acc ->
        # The new beam to the left can be reached in `(x - 2) + x` timelines at the current level
        # If no beam reached the coordinates at `x - 2` then it's only reachable from `x`
        left_value =
          if MapSet.member?(intersecting_beams, x - 2), do: Map.get(beams, x - 2, 0), else: 0

        # The new beam to the right can be reached in `x + (x + 2)` timelines at the current level
        # If no beam reached the coordinates at `x + 2` then it's only reachable from `x`
        right_value =
          if MapSet.member?(intersecting_beams, x + 2), do: Map.get(beams, x + 2, 0), else: 0

        # We just assume this always exists
        x_value = Map.get(beams, x)

        Map.put_new(acc, x - 1, x_value + left_value)
        |> Map.put_new(x + 1, x_value + right_value)
      end)

    non_intersecting_beams =
      MapSet.difference(beam_set, splitter_set)
      |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x, Map.get(beams, x)) end)

    # The new beams are merged with the non intersecting beams.
    # When a position exists in both maps, the given position can be accessed in other timelines
    # where there were no splitters in the given positions for one or more lines.
    timeline(Map.merge(new_beams, non_intersecting_beams, fn _, v1, v2 -> v1 + v2 end), tail)
  end
end

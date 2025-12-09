defmodule Day7 do
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

  @spec count_splits_in_input(String.t()) :: non_neg_integer()
  def count_splits_in_input(input) when is_bitstring(input) do
    {start, splitters} = input |> Day7.parse_input()
    project([start], splitters)
  end

  @spec count_timelines_in_input(String.t()) :: non_neg_integer()
  def count_timelines_in_input(input) when is_bitstring(input) do
    {start, splitters} = Day7.parse_input(input)
    timeline(%{start => 1}, splitters)
  end

  @spec project([non_neg_integer()], [[non_neg_integer()]]) :: non_neg_integer()
  def project(beams, splitters), do: project(beams, splitters, 0)

  defp project(_beams, [], splits), do: splits

  defp project(beams, [splitters | tail], splits) when is_integer(splits) do
    beam_set = MapSet.new(beams)
    splitter_set = MapSet.new(splitters)

    intersecting_beams = MapSet.intersection(beam_set, splitter_set)

    new_beams = Enum.flat_map(intersecting_beams, fn x -> [x - 1, x + 1] end)
    non_intersecting_beams = MapSet.difference(beam_set, splitter_set) |> MapSet.to_list()

    project(
      (new_beams ++ non_intersecting_beams) |> Enum.uniq(),
      tail,
      splits + MapSet.size(intersecting_beams)
    )
  end

  @spec timeline(%{non_neg_integer() => non_neg_integer()}, [[non_neg_integer()]]) ::
          non_neg_integer()
  def timeline(%{} = beams, []), do: beams |> Map.values() |> Enum.sum()

  def timeline(%{} = beams, [splitters | tail]) do
    beam_set = MapSet.new(beams |> Map.keys())
    splitter_set = MapSet.new(splitters)

    intersecting_beams = MapSet.intersection(beam_set, splitter_set)

    new_beams =
      Enum.reduce(intersecting_beams, %{}, fn x, acc ->
        left_value =
          if MapSet.member?(intersecting_beams, x - 2) do
            Map.get(beams, x - 2, 0)
          else
            0
          end

        right_value =
          if MapSet.member?(intersecting_beams, x + 2) do
            Map.get(beams, x + 2, 0)
          else
            0
          end

        x_value = Map.get(beams, x)

        Map.put_new(acc, x - 1, x_value + left_value)
        |> Map.put_new(x + 1, x_value + right_value)
      end)

    non_intersecting_beams =
      MapSet.difference(beam_set, splitter_set)
      |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x, Map.get(beams, x)) end)

    timeline(Map.merge(new_beams, non_intersecting_beams, fn _, v1, v2 -> v1 + v2 end), tail)
  end
end

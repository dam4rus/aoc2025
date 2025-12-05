defmodule Day5 do
  def is_fresh?(ingredient, ranges) when is_integer(ingredient) and is_list(ranges) do
    Enum.any?(ranges, &Enum.member?(&1, ingredient))
  end

  def count_fresh_ingredients(ingredients, ranges)
      when is_list(ingredients) and is_list(ranges) do
    Stream.filter(ingredients, &is_fresh?(&1, ranges)) |> Enum.count()
  end

  def count_fresh_ingredients(input) when is_bitstring(input) do
    {ranges, ingredients} = parse_input(input)
    count_fresh_ingredients(ingredients, ranges)
  end

  @doc """
  Merges a range with all overlapping ranges in the given list.

  Returns a tuple of the merged range and all range that were not overlapping with the given range.
  """
  @spec merge_overlapping(Range.t(), [Range.t()]) :: {Range.t(), [Range.t()]}
  def merge_overlapping(
        %Range{} = range,
        ranges
      )
      when is_list(ranges),
      do: merge_overlapping(range, ranges, [])

  @spec merge_overlapping(Range.t(), [Range.t()], [Range.t()]) :: {Range.t(), [Range.t()]}
  defp merge_overlapping(
         %Range{first: first1, last: last1} = range1,
         [%Range{first: first2, last: last2} = range2],
         remaining_ranges
       ) do
    if Range.disjoint?(range1, range2) do
      {range1, [range2 | remaining_ranges]}
    else
      {min(first1, first2)..max(last1, last2), remaining_ranges}
    end
  end

  defp merge_overlapping(
         %Range{first: first1, last: last1} = range1,
         [%Range{first: first2, last: last2} = range2 | tail],
         remaining_ranges
       ) do
    if Range.disjoint?(range1, range2) do
      merge_overlapping(range1, tail, [range2 | remaining_ranges])
    else
      merge_overlapping(min(first1, first2)..max(last1, last2), tail, remaining_ranges)
    end
  end

  @doc """
  Merges all overlapping ranges in the given list. It is assumed that the list is sorted.

  Returns all ranges after merging overlapping ones.
  """
  @spec merge_ranges([Range.t()]) :: [Range.t()]
  def merge_ranges([]), do: []

  def merge_ranges([%Range{} = range]), do: [range]

  def merge_ranges([%Range{} = range | tail]) do
    {new_range, remainining_ranges} = merge_overlapping(range, tail)
    [new_range | merge_ranges(remainining_ranges)]
  end

  @doc """
  Parses the input and returns a tuple of all the ranges and ingredient IDs.
  """
  @spec parse_input(String.t()) :: {[Range.t()], [non_neg_integer()]}
  def parse_input(input) when is_bitstring(input) do
    [ranges, ingredients] = String.split(input, "\n\n")

    {String.split(ranges, "\n")
     |> Stream.map(fn line -> String.split(line, "-") end)
     |> Enum.map(fn [first, last] -> String.to_integer(first)..String.to_integer(last) end),
     String.split(ingredients) |> Enum.map(&String.to_integer/1)}
  end
end

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

  def parse_input(input) when is_bitstring(input) do
    [ranges, ingredients] = String.split(input, "\n\n")

    {String.split(ranges, "\n")
     |> Stream.map(fn line -> String.split(line, "-") end)
     |> Enum.map(fn [first, last] -> String.to_integer(first)..String.to_integer(last) end),
     String.split(ingredients) |> Enum.map(&String.to_integer/1)}
  end
end

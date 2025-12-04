defmodule Day4 do
  def can_access_roll_of_paper?(%Grid{width: width, height: height} = grid, x, y)
      when (x == 0 or x == width - 1) and (y == 0 or y == height - 1),
      do: Grid.at(grid, x, y) == "@"

  def can_access_roll_of_paper?(%Grid{} = grid, x, y) do
    case Grid.at(grid, x, y) do
      "." ->
        false

      _ ->
        count =
          neighbors(grid, x, y)
          |> Enum.map(fn {x, y} -> Grid.at(grid, x, y) end)
          |> Enum.filter(fn c -> c == "@" end)
          |> Enum.count()

        count < 4
    end
  end

  def count_accessable_roll_of_papers(input) when is_bitstring(input) do
    grid = Grid.from_input(input)

    0..(grid.height - 1)
    |> Stream.flat_map(fn y -> 0..(grid.width - 1) |> Enum.map(fn x -> {x, y} end) end)
    |> Stream.filter(fn {x, y} -> Day4.can_access_roll_of_paper?(grid, x, y) end)
    |> Enum.count()
  end

  defp neighbors(_grid, x, y) when x == 0 and is_integer(y),
    do: [{x, y - 1}, {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}, {x, y + 1}]

  defp neighbors(%Grid{width: width}, x, y) when x == width - 1 and is_integer(y),
    do: [{x, y - 1}, {x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1}, {x, y + 1}]

  defp neighbors(_grid, x, y) when is_integer(x) and y == 0,
    do: [{x - 1, y}, {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}, {x + 1, y}]

  defp neighbors(%Grid{height: height}, x, y) when is_integer(x) and y == height - 1,
    do: [{x - 1, y}, {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}, {x + 1, y}]

  defp neighbors(_grid, x, y) when is_integer(x) and is_integer(y),
    do: [
      {x, y - 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1}
    ]
end

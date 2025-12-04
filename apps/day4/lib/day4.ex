defmodule Day4 do
  @type method() :: :once | :until_empty

  @spec can_access_roll_of_paper?(Grid.t(), non_neg_integer(), non_neg_integer()) :: boolean()
  def can_access_roll_of_paper?(%Grid{width: width, height: height} = grid, x, y)
      when (x == 0 or x == width - 1) and (y == 0 or y == height - 1),
      do: Grid.at(grid, x, y) == "@"

  def can_access_roll_of_paper?(%Grid{} = grid, x, y) do
    case Grid.at(grid, x, y) do
      "@" ->
        count =
          neighbors(grid, x, y)
          |> Enum.map(fn {x, y} -> Grid.at(grid, x, y) end)
          |> Enum.filter(fn c -> c == "@" end)
          |> Enum.count()

        count < 4

      _ ->
        false
    end
  end

  @spec count_accessable_roll_of_papers(String.t() | Grid.t(), method()) :: non_neg_integer()
  def count_accessable_roll_of_papers(input, :once) when is_bitstring(input) do
    mark_accessable_roll_of_papers(Grid.from_input(input))
    |> Stream.filter(fn item -> item == "x" end)
    |> Enum.count()
  end

  def count_accessable_roll_of_papers(input, :until_empty) when is_bitstring(input) do
    count_accessable_roll_of_papers(Grid.from_input(input), :until_empty)
  end

  def count_accessable_roll_of_papers(%Grid{} = grid, :until_empty) do
    grid = mark_accessable_roll_of_papers(grid)

    case grid
         |> Stream.filter(fn item -> item == "x" end)
         |> Enum.count() do
      0 ->
        0

      count ->
        count +
          (remove_marked_roll_of_papers(grid) |> count_accessable_roll_of_papers(:until_empty))
    end
  end

  @spec mark_accessable_roll_of_papers(Grid.t()) :: Grid.t()
  def mark_accessable_roll_of_papers(%Grid{map: map} = grid) do
    map =
      Enum.with_index(map)
      |> Enum.map(fn {line, y} ->
        Enum.with_index(line)
        |> Enum.map(fn {item, x} ->
          case can_access_roll_of_paper?(grid, x, y) do
            true -> "x"
            false -> item
          end
        end)
      end)

    %Grid{grid | map: map}
  end

  @spec remove_marked_roll_of_papers(Grid.t()) :: Grid.t()
  defp remove_marked_roll_of_papers(%Grid{map: map} = grid) do
    map =
      Enum.map(map, fn line ->
        Enum.map(line, fn item ->
          case item do
            "x" -> "."
            item -> item
          end
        end)
      end)

    %Grid{grid | map: map}
  end

  @spec neighbors(Grid.t(), non_neg_integer(), non_neg_integer()) :: [
          {non_neg_integer(), non_neg_integer()}
        ]
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

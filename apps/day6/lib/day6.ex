defmodule Day6 do
  def sum_problems(input) when is_bitstring(input) do
    {numbers, operations} = Day6.parse_input(input)

    Stream.zip(numbers, operations)
    |> Enum.sum_by(fn {numbers, operation} -> Day6.solve(numbers, operation) end)
  end

  def parse_input(input) when is_bitstring(input) do
    lines =
      String.split(input, "\n") |> Enum.map(fn line -> String.split(line, " ", trim: true) end)

    {numbers, [operations | _]} = Enum.split(lines, length(lines) - 1)

    numbers =
      Enum.reduce(numbers, Stream.cycle([[]]) |> Enum.take(length(operations)), fn line, acc ->
        Stream.zip(line, acc) |> Enum.map(fn {number, list} -> [number | list] end)
      end)

    {numbers |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end), operations}
  end

  def solve(numbers, "+"), do: Enum.sum(numbers)

  def solve(numbers, "*"), do: Enum.product(numbers)
end

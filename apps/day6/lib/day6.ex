defmodule Day6 do
  @type math_type() :: :human | :cephalopod

  @doc """
  Helper method to sum the result of all problems with either in `:human` or `:cephalodo` math type.

  Returns the sum of the results of all problem.
  """
  @spec sum_problems(String.t(), math_type()) :: non_neg_integer()
  def sum_problems(input, math_type) when is_bitstring(input) do
    {numbers, operations} = Day6.parse_input(input, math_type)

    Stream.zip(numbers, operations)
    |> Enum.sum_by(fn {numbers, operation} -> Day6.solve(numbers, operation) end)
  end

  @doc """
  Parses the given input in either `:human` or `:cephalopod` format.

  In `:human` format each line is read either as a table of numbers or operations.
  Then the table of numbers are transposed and combined with their respective operations.

  In `:cephalopod` format the lines are read the same way as in `:human` format.
  Then each problems column width are calculated. Using these widths the lines are split again
  and reduced to the same format as in `:human` format.

  Returns a list of numbers for each problem and their respective operation.
  """
  @spec parse_input(String.t(), math_type()) :: {[[non_neg_integer()]], [String.t()]}
  def parse_input(input, :human) when is_bitstring(input) do
    lines =
      String.split(input, "\n") |> Enum.map(fn line -> String.split(line, " ", trim: true) end)

    {numbers, [operations | _]} = Enum.split(lines, length(lines) - 1)

    numbers =
      Enum.reduce(numbers, Stream.cycle([[]]) |> Enum.take(length(operations)), fn line, acc ->
        Stream.zip(line, acc) |> Enum.map(fn {number, list} -> [number | list] end)
      end)

    {numbers |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end), operations}
  end

  def parse_input(input, :cephalopod) when is_bitstring(input) do
    lines = String.split(input, "\n")

    {numbers, [operations | _]} =
      Enum.map(lines, fn line -> String.split(line, " ", trim: true) end)
      |> Enum.split(length(lines) - 1)

    column_widths =
      Enum.reduce(numbers, Stream.cycle([0]) |> Enum.take(length(operations)), fn line, acc ->
        Stream.zip(line, acc)
        |> Enum.map(fn {number, column_width} -> max(column_width, String.length(number)) end)
      end)

    numbers =
      Stream.take(lines, length(lines) - 1)
      |> Enum.reduce(
        column_widths |> Enum.map(fn width -> Stream.cycle([""]) |> Enum.take(width) end),
        fn line, acc ->
          Stream.zip(acc, split_by_column_widths(String.graphemes(line), column_widths))
          |> Enum.map(fn {acc_columns, problem_columns} ->
            Stream.zip(acc_columns, problem_columns)
            |> Enum.map(fn
              {acc_column, " "} -> acc_column
              {acc_column, problem_column} -> acc_column <> problem_column
            end)
          end)
        end
      )

    {numbers |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end), operations}
  end

  @spec solve(Enumerable.t(), String.t()) :: non_neg_integer()
  def solve(numbers, "+"), do: Enum.sum(numbers)

  def solve(numbers, "*"), do: Enum.product(numbers)

  @spec split_by_column_widths([String.t()], [non_neg_integer()]) :: [String.t()]
  defp split_by_column_widths([], []), do: []

  defp split_by_column_widths(line, [width]) when is_integer(width) do
    {column, remaining} = Enum.split(line, width)
    [column |> Enum.take(width) | split_by_column_widths(remaining, [])]
  end

  defp split_by_column_widths(line, [width | tail]) when is_integer(width) do
    {column, remaining} = Enum.split(line, width + 1)
    [column |> Enum.take(width) | split_by_column_widths(remaining, tail)]
  end
end

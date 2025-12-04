defmodule Grid do
  @type t() :: %__MODULE__{
          grid: [[String.t()]],
          width: integer(),
          height: integer()
        }
  defstruct [:grid, :width, :height]

  @spec from_input(String.t()) :: t()
  def from_input(input) do
    grid =
      String.split(input, "\n")
      |> Enum.map(fn line -> String.graphemes(line) end)

    %__MODULE__{
      grid: grid,
      width: Enum.at(grid, 0) |> length,
      height: length(grid)
    }
  end

  def at(%__MODULE__{grid: grid, width: width, height: height}, x, y)
      when x >= 0 and x < width and y >= 0 and y < height do
    Enum.at(grid, y) |> Enum.at(x)
  end
end

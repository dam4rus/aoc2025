defmodule Grid do
  @type t() :: %__MODULE__{
          map: [[String.t()]],
          width: integer(),
          height: integer()
        }
  defstruct [:map, :width, :height]

  defimpl Enumerable, for: __MODULE__ do
    def reduce(%Grid{map: map}, acc, fun) do
      Enumerable.reduce(Stream.flat_map(map, fn line -> line end), acc, fun)
    end

    def count(%Grid{map: map}) do
      Enumerable.count(Stream.flat_map(map, fn line -> line end))
    end

    def member?(%Grid{map: map}, element) do
      Enumerable.member?(Stream.flat_map(map, fn line -> line end), element)
    end

    def slice(%Grid{map: map}) do
      Enumerable.slice(Stream.flat_map(map, fn line -> line end))
    end
  end

  @spec from_input(String.t()) :: t()
  def from_input(input) do
    map =
      String.split(input, "\n")
      |> Enum.map(fn line -> String.graphemes(line) end)

    %__MODULE__{
      map: map,
      width: Enum.at(map, 0) |> length,
      height: length(map)
    }
  end

  def at(%__MODULE__{map: map, width: width, height: height}, x, y)
      when x >= 0 and x < width and y >= 0 and y < height do
    Enum.at(map, y) |> Enum.at(x)
  end
end

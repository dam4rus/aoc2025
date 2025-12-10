defmodule Day8 do
  @type coordinates() :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}

  @type distance() :: {coordinates(), coordinates(), float()}

  @spec parse_input(String.t()) :: [coordinates()]
  def parse_input(input) when is_bitstring(input) do
    String.split(input, "\n")
    |> Enum.map(fn line ->
      [x, y, z] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
      {x, y, z}
    end)
  end

  @spec product_of_connections(String.t(), non_neg_integer()) :: non_neg_integer()
  def product_of_connections(input, take \\ 1000) when is_bitstring(input),
    do:
      input
      |> Day8.parse_input()
      |> Day8.calculate_distances()
      |> Enum.sort_by(fn {_, _, distance} -> distance end)
      |> Enum.take(take)
      |> Day8.connect([])
      |> Enum.map(&length/1)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.product()

  @spec multiply_x_coordinates_of_last_two_junction_boxes_that_needs_to_be_connected(String.t()) ::
          non_neg_integer()
  def multiply_x_coordinates_of_last_two_junction_boxes_that_needs_to_be_connected(input)
      when is_bitstring(input) do
    points = parse_input(input)

    {{x1, _, _}, {x2, _, _}, _} =
      points
      |> Day8.calculate_distances()
      |> Enum.sort_by(fn {_, _, distance} -> distance end)
      |> Enum.reduce_while([], fn connection, acc ->
        case Day8.connect([connection], acc) do
          [single_box] when length(single_box) == length(points) ->
            {:halt, connection}

          acc ->
            {:cont, acc}
        end
      end)

    x1 * x2
  end

  @spec connect([distance()], [coordinates()]) :: [coordinates()]
  def connect([], acc), do: acc

  def connect([{pt1, pt2, _} | tail], acc) do
    pt1_index =
      Enum.find_index(acc, fn connections ->
        Enum.any?(connections, fn pt -> pt == pt1 end)
      end)

    pt2_index =
      Enum.find_index(acc, fn connections ->
        Enum.any?(connections, fn pt -> pt == pt2 end)
      end)

    case {pt1_index, pt2_index} do
      {nil, nil} ->
        connect(tail, [[pt1, pt2] | acc])

      {pt1_index, nil} ->
        connect(
          tail,
          List.update_at(acc, pt1_index, fn connections -> [pt2 | connections] end)
        )

      {nil, pt2_index} ->
        connect(
          tail,
          List.update_at(acc, pt2_index, fn connections -> [pt1 | connections] end)
        )

      {pt1_index, pt2_index} when pt1_index != pt2_index ->
        connect(tail, [
          Enum.concat(Enum.at(acc, pt1_index), Enum.at(acc, pt2_index))
          | List.delete_at(acc, max(pt1_index, pt2_index))
            |> List.delete_at(min(pt1_index, pt2_index))
        ])

      _ ->
        connect(tail, acc)
    end
  end

  @spec calculate_distances([coordinates()]) :: [distance()]
  def calculate_distances([]), do: []

  def calculate_distances([head | tail]),
    do: Enum.concat(calculate_distances(head, tail), calculate_distances(tail))

  defp calculate_distances(_point1, []), do: []

  defp calculate_distances({_x1, _y1, _z1} = point1, [{_x2, _y2, _z2} = point2 | tail]) do
    [{point1, point2, distance(point1, point2)} | calculate_distances(point1, tail)]
  end

  @spec distance(coordinates(), coordinates()) :: float()
  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    ((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2) ** 0.5
  end
end

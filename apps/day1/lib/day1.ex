defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  @type direction() :: :left | :right

  @type password_method() :: :single | :multiple

  @doc """
  Rotates the dial in the given direction.

  Returns the dial position after the rotation and how many times it clicked at zero in a tuple.
  """
  @spec rotate(number(), direction(), number()) :: {number(), number()}
  def rotate(dial, :left, rotation) when is_number(dial) and is_number(rotation) do
    zero_count = div(rotation, 100)

    case dial - rem(rotation, 100) do
      0 -> {0, zero_count + 1}
      new_dial when new_dial < 0 and dial > 0 -> {new_dial + 100, zero_count + 1}
      new_dial when new_dial < 0 -> {new_dial + 100, zero_count}
      new_dial -> {new_dial, zero_count}
    end
  end

  def rotate(dial, :right, rotation) when is_number(dial) and is_number(rotation) do
    zero_count = div(rotation, 100)

    case dial + rem(rotation, 100) do
      new_dial when new_dial > 99 -> {new_dial - 100, zero_count + 1}
      new_dial -> {new_dial, zero_count}
    end
  end

  @doc """
  Processes input lines.

  Password method can be `:single` or `:multiple`.
  With `:single` method, returns the number the dial rest at 0.
  With `:multiple` method, returns the number the dial was at 0.
  """
  @spec process_input([String.t()], password_method()) :: number()
  def process_input(lines, password_method) when is_list(lines) do
    process_input(50, lines, 0, password_method)
  end

  @doc """
  Processes the embedded real input lines.

  See `process_input/2` for details.
  """
  @spec process_input(password_method()) :: number()
  def process_input(password_method) do
    process_input(Day1Input.input() |> String.split("\n"), password_method)
  end

  @spec process_input(number(), [String.t()], number(), password_method()) :: number()
  defp process_input(dial, [line], zero_count, :single)
       when is_number(dial) and is_binary(line) and is_number(zero_count) do
    {dial, _} = process_line(dial, line)

    case dial do
      dial when dial > 99 or dial < 0 ->
        raise "invalid dial value. must be between [0-100), got: #{dial}"

      0 ->
        zero_count + 1

      _ ->
        zero_count
    end
  end

  defp process_input(dial, [line | tail], zero_count, :single)
       when is_number(dial) and is_binary(line) and is_number(zero_count) do
    {dial, _} = process_line(dial, line)

    case dial do
      dial when dial > 99 or dial < 0 ->
        raise "invalid dial value. must be between [0-100), got: #{dial}"

      dial when dial == 0 ->
        process_input(dial, tail, zero_count + 1, :single)

      dial ->
        process_input(dial, tail, zero_count, :single)
    end
  end

  defp process_input(dial, [line], zero_count, :multiple)
       when is_number(dial) and is_binary(line) and is_number(zero_count) do
    {dial, rotation_zero_count} = process_line(dial, line)

    case dial do
      dial when dial > 99 or dial < 0 ->
        raise "invalid dial value. must be between [0-100), got: #{dial}"

      _ ->
        zero_count + rotation_zero_count
    end
  end

  defp process_input(dial, [line | tail], zero_count, :multiple)
       when is_number(dial) and is_binary(line) and is_number(zero_count) do
    {dial, rotation_zero_count} = process_line(dial, line)

    case dial do
      dial when dial > 99 or dial < 0 ->
        raise "invalid dial value. must be between [0-100), got: #{dial}"

      dial ->
        process_input(dial, tail, zero_count + rotation_zero_count, :multiple)
    end
  end

  defp process_line(dial, line) do
    {:ok, rotation_direction} = String.at(line, 0) |> rotation_direction

    rotate(
      dial,
      rotation_direction,
      String.slice(line, 1..(String.length(line) - 1)) |> String.to_integer()
    )
  end

  @spec rotation_direction(String.t()) :: direction()
  defp rotation_direction("L"), do: {:ok, :left}

  defp rotation_direction("R"), do: {:ok, :right}

  defp rotation_direction(direction), do: {:error, "invalid direction: #{direction}"}
end

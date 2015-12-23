defmodule SolverSix do
  def solve do
    state = lights
    {:ok, input} = File.read("input.txt")
    instructions = input |> String.split("\n", trim: true)

    result = Enum.reduce(instructions, state, fn(inst, state) ->
      IO.puts inst
      interact(state, inst)
    end) |> Dict.values

    brightness = result |> Enum.reduce(0, fn(x, acc) -> acc + x[:brightness] end)
    turned_on = result |> Enum.filter(fn(x) -> x[:on] end) |> Enum.count

    [
      turned_on: turned_on,
      brightness: brightness
    ]
  end

  defp interact(state, "") do
    state
  end

  defp interact(state, inst) do
    cond do
      String.starts_with?(inst, "turn on") -> update_state(state, inst, :on)
      String.starts_with?(inst, "turn off") -> update_state(state, inst, :off)
      String.starts_with?(inst, "toggle") -> update_state(state, inst, :toggle)
      true -> state
    end
  end

  defp update_state(state, inst, value) do
    [x0, y0, x1, y1] = parse_instruction(inst)

    Enum.map(x0..x1, fn(x) ->
      Enum.map(y0..y1, fn(y) ->
        to_string(x) <> "x" <> to_string(y)
      end)
    end) |> List.flatten
    |> Enum.reduce(state, fn(light, new_state) ->
        {_, dict} = Dict.get_and_update(new_state, light, fn(v) ->
          [on: on, brightness: brightness] = v
          case value do
            :on -> {v, [on: true, brightness: brightness + 1]}
            :off -> {v, [on: false, brightness: Enum.max([0, brightness - 1])]}
            :toggle -> {v, [on: !on, brightness: brightness + 2]}
            _ -> {v, v}
          end
        end)

        dict
    end)
  end

  defp parse_instruction(inst) do
    Regex.scan(~r/[0-9]+/, inst)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)
  end

  defp grid do
    Enum.map(0..999, fn(x) ->
      Enum.map(0..999, fn(y) ->
        %{x: x, y: y}
      end)
    end) |> List.flatten
  end

  defp lights do
    Enum.reduce(grid, %{}, fn(l, dict) ->
      key = to_string(l[:x]) <> "x" <> to_string(l[:y])
      Dict.put_new(dict, key, [on: false, brightness: 0])
    end)
  end
end

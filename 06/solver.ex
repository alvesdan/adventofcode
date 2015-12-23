defmodule SolverSix do
  def solve do
    state = lights
    {:ok, input} = File.read("input.txt")
    instructions = input |> String.split("\n", trim: true)

    Enum.reduce(instructions, state, fn(inst, state) ->
      IO.puts inst
      interact(state, inst)
    end) |> Dict.values |> Enum.filter(fn(x) -> x end) |> Enum.count
  end

  defp interact(state, "") do
    state
  end

  defp interact(state, inst) do
    [start, finish] = parse_instruction(inst)
    cond do
      String.starts_with?(inst, "turn on") -> update_state(state, start, finish, :on)
      String.starts_with?(inst, "turn off") -> update_state(state, start, finish, :off)
      String.starts_with?(inst, "toggle") -> update_state(state, start, finish, :toggle)
      true -> state
    end
  end

  defp update_state(state, start, finish, value) do
    [x0, y0] = start
    [x1, y1] = finish

    Enum.map(x0..x1, fn(x) ->
      Enum.map(y0..y1, fn(y) ->
        to_string(x) <> "x" <> to_string(y)
      end)
    end) |> List.flatten
    |> Enum.reduce(state, fn(light, new_state) ->
        {_, dict} = Dict.get_and_update(new_state, light, fn(v) ->
          case value do
            :on -> {true, true}
            :off -> {false, false}
            :toggle -> {!v, !v}
            _ -> {v, v}
          end
        end)

        dict
    end)
  end

  defp parse_instruction(inst) do
    Regex.scan(~r/[0-9,]+/, inst)
      |> List.flatten
      |> Enum.map(fn(x) -> x |> String.split(",", trim: true) end)
      |> Enum.map(fn(x) -> Enum.map(x, &String.to_integer/1) end)
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
      Dict.put_new(dict, key, false)
    end)
  end
end

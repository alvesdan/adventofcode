defmodule SolverThree do
  def solve do
    {:ok, input} = File.read("input.txt")
    chars = String.split(input, "", trim: true)

    Enum.reduce(chars, [%{x: 0, y: 0}], fn(c, acc) ->
      current = List.last(acc)
      [x, y] = [current[:x], current[:y]]
      moved = case c do
        "^" -> %{x: x, y: y + 1}
        ">" -> %{x: x + 1, y: y}
        "v" -> %{x: x, y: y - 1}
        "<" -> %{x: x - 1, y: y}
        _   -> %{x: x, y: y}
      end

      Enum.concat(acc, [moved])
    end) |> Enum.uniq |> Enum.count
  end
end


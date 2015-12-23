defmodule SolverOne do
  def solve do
    {:ok, input} = File.read("input.txt")
    list = String.split(input, "", trim: true)

    Enum.reduce(list, [0, 0], fn(char, acc) ->
      [floor, index] = acc
      if floor < 0, do: raise("Went to basement at " <> to_string(index))
      case char do
        "(" -> [floor + 1, index + 1]
        ")" -> [floor - 1, index + 1]
        _   -> [floor, index + 1]
      end
    end)
  end
end

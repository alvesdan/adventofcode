defmodule SolverOne do
  def solve do
    {:ok, input} = File.read("input.txt")
    list = String.split(input, "")
    Enum.reduce(list, 0, fn(char, acc) ->
      case char do
        "(" -> acc + 1
        ")" -> acc - 1
        _   -> acc
      end
    end)
  end
end

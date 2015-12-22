defmodule SolverOne do
  def solve(input) do
    s = String.split(input, "")
    Enum.reduce(s, 0, fn(char, acc) ->
      case char do
        "(" -> acc + 1
        ")" -> acc - 1
        _ -> acc
      end
    end)
  end
end

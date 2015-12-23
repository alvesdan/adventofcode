defmodule SolverThree do
  def solve do
    {:ok, input} = File.read("input.txt")
    state = [%{x: 0, y: 0}, [%{x: 0, y: 0}]]
    chars = String.split(input, "")
    houses = visit(state, chars)
    Enum.count(Enum.uniq(houses))
  end

  def visit(state, []) do
    [_, visited] = state
    visited
  end

  def visit(state, list) do
    [visiting, visited] = state
    x = visiting[:x]
    y = visiting[:y]
    movement = hd(list)

    case movement do
      "^" -> visit([%{x: x, y: y + 1}, Enum.concat(visited, [%{x: x, y: y + 1}])], tl(list))
      ">" -> visit([%{x: x + 1, y: y}, Enum.concat(visited, [%{x: x + 1, y: y}])], tl(list))
      "v" -> visit([%{x: x, y: y - 1}, Enum.concat(visited, [%{x: x, y: y - 1}])], tl(list))
      "<" -> visit([%{x: x - 1, y: y}, Enum.concat(visited, [%{x: x - 1, y: y}])], tl(list))
      _   -> visit(state, tl(list))
    end
  end
end


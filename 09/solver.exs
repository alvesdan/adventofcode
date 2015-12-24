defmodule SolverNine do
  def solve do
    {:ok, input} = File.read("input.txt")
    lines = String.split(input, "\n", trim: true)
    dis = distances(lines)

    Enum.reduce(permutations(cities(lines)), [], fn(route, acc) ->
      distance = Enum.reduce(route, [0, 0], fn(a, acc) ->
        [index, total] = acc
        b = Enum.at(route, index + 1)
        case b do
          nil -> [index + 1, total]
          _   -> [index + 1, total + (dis[{a, b}] || dis[{b, a}])]
        end
      end) |> List.last

      Enum.concat(acc, [distance])
    end) |> Enum.max
  end

  defp cities(lines) do
    Enum.reduce(lines, [], fn(line, acc) ->
      case Regex.run(~r/(\w+) to (\w+) = (\d+)/, line) do
        [_, a, b, _] ->
          Enum.uniq(Enum.concat(acc, [a,b]))
        _ -> acc
      end
    end)
  end

  def distances(lines) do
    Enum.reduce(lines, %{}, fn(line, acc) ->
      case Regex.run(~r/(\w+) to (\w+) = (\d+)/, line) do
        [_, a, b, distance] ->
          Dict.put acc, {a, b}, String.to_integer(distance)
        _ -> acc
      end
    end)
  end

  def permutations([]), do: [[]]
  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end
end

IO.inspect SolverNine.solve

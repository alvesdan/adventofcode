defmodule SolverNine do
  def solve do
    {:ok, input} = File.read("input.txt")
    lines = String.split(input, "\n", trim: true)
    [cities, distances] = parse(lines)

    Enum.reduce(permutations(cities), [], fn(route, acc) ->
      distance = Enum.reduce(route, [0, 0], fn(a, acc) ->
        [index, total] = acc
        b = Enum.at(route, index + 1)
        case b do
          nil -> [index + 1, total]
          _   -> [index + 1, total + (distances[{a, b}] || distances[{b, a}])]
        end
      end) |> List.last

      acc ++ [distance]
    end) |> Enum.max
  end

  defp parse(lines) do
    Enum.reduce(lines, [[], %{}], fn(line, acc) ->
      [cities, distances] = acc

      case Regex.run(~r/(\w+) to (\w+) = (\d+)/, line) do
        [_, a, b, distance] ->
          [ Enum.uniq(cities ++ [a,b]),
            Dict.put(distances, {a, b}, String.to_integer(distance)) ]
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

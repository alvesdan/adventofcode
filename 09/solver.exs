defmodule SolverNine do
  def solve do
    {:ok, input} = File.read("input.txt")
    lines = String.split(input, "\n", trim: true)
    distances = parse(lines)
    start = sort(distances) |> List.first
    goto(start, tl(distances), 0)
  end

  defp parse(lines) do
    Enum.reduce(lines, [], fn(line, acc) ->
      case Regex.run(~r/(\w+) to (\w+) = (\d+)/, line) do
        [_, a, b, distance] ->
          Enum.concat(acc, [
            [a <> b, distance: String.to_integer(distance)],
            [b <> a, distance: String.to_integer(distance)]
          ])
        _ -> acc
      end
    end)
  end

  defp sort(distances) do
    Enum.sort_by(distances, fn(dis) ->
      dis[:distance]
    end)
  end

  defp goto(current, [], covered) do
    covered
  end

  defp goto(current, distances, covered) do
    IO.inspect(current)
    destiny = current[:b]
    distance = current[:distance]
    possible = filter(current, destiny, distances)
    next = sort(possible) |> List.first

    goto(
      next,
      List.delete(distances, next),
      covered + distance
    )
  end

  defp filter(current, destiny, distances) do
    Enum.filter(distances, fn(dis) ->
      dis[:a] == destiny
    end)
  end
end

IO.inspect SolverNine.solve

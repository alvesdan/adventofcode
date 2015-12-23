defmodule SolverEight do
  def solve do
    {:ok, input} = File.read("input.txt")
    input |>
      String.split("\n", trim: true)
      |> sum
  end

  defp sum(lines) do
    Enum.reduce(lines, [chars: 0, mem: 0], fn(line, acc) ->
      [
        chars: acc[:chars] + String.length(line),
        mem: acc[:mem] + memory(line) + 2
      ]
    end)
  end

  defp memory(line) do
    line
      |> String.replace(~r/"|\\/, "**")
      |> String.length
  end
end

IO.inspect SolverEight.solve

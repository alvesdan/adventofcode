defmodule SolverTwo do
  def solve do
    {:ok, file} = File.read("input.txt")
    boxes = String.split(file, "\n")

    Enum.reduce(boxes, 0, fn(box, acc) ->
      acc + surface(box)
    end)
  end

  defp surface(box) do
    [l, w, h] = dimensions(box)
    extra = Enum.min([l*w, w*h, h*l])

    2*l*w + 2*w*h + 2*h*l + extra
  end

  defp dimensions("") do
    [0, 0, 0]
  end

  defp dimensions(box) do
    String.strip(box)
      |> String.split("x", trim: true)
      |> Enum.map(&String.to_integer/1)
  end
end

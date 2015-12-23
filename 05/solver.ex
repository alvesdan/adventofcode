defmodule SolverFive do
  def solve do
    {:ok, input} = File.read("input.txt")
    strings = String.split(input, "\n", trim: true)

    Enum.reduce(strings, 0, fn(string, acc) ->
      cond do
        nice?(string) -> acc + 1
        true -> acc
      end
    end)
  end

  defp nice?(string) do
    vowels?(string) && letters?(string) && allowed?(string)
  end

  defp vowels?(string) do
    Regex.scan(~r/[aeiou]/, string)
      |> List.flatten
      |> Enum.count > 2
  end

  defp letters?(string) do
    letters = String.split("qwertyuiopasdfghjklzxcvbnm", "", trim: true)
     Enum.any?(letters, fn(l) ->
       String.contains? string, l <> l
     end)
  end

  defp allowed?(string) do
    !Regex.match?(~r/ab|cd|pq|xy/, string)
  end
end

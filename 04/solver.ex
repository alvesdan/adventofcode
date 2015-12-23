defmodule SolverFour do
  def solve do
    match(0, "bgvyzdsv")
  end

  def match(n, input) do
    hash = :crypto.hash(:md5, input <> Integer.to_string(n)) |> Base.encode16
    cond do
      String.starts_with?(hash, "00000") -> n
      true -> match(n + 1, input)
    end
  end
end

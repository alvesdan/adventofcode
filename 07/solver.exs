use Bitwise

defmodule SolverSeven do
  @regexs [
    ~r/(NOT) (\w+) -> (\w+)/,
    ~r/(\w+) (\w+) ([\w\d]+) -> (\w+)/,
    ~r/([\w\d]+) -> (\w+)/
  ]

  def solve do
    {:ok, input} = File.read("input.txt")
    instructions = String.split(input, "\n", trim: true)
    parse_signals(%{"b" => 16076}, parse_operations(instructions))
  end

  def parse_operations(instructions) do
    Enum.reduce(instructions, [], fn(inst, ops) ->
      Enum.concat ops, [parse_operation(inst, @regexs)]
    end)
  end

  def parse_operation(inst, [r|tail]) do
    run = Regex.run(r, inst)
    case run do
      nil -> parse_operation(inst, tail)
      [_, signal, dest] -> %{ operator: :signal, signal: signal, dest: dest }
      [_, x, operator, y, dest] -> %{ operator: operator, x: x, y: y, dest: dest }
      [_, operator, x, dest] -> %{ operator: operator, x: x, dest: dest }
    end
  end

  def parse_operation(_, []) do nil end
  def parse_signals(cache, []) do cache end

  def parse_signals(cache, operations) do
    op = hd(operations)
    signal = parse_integer(op[:signal])

    if signal do
      dict = Dict.put_new(cache, op[:dest], signal)
      parse_signals(dict, tl(operations))
    else
      if complete?(op) do
        x = parse_integer(op[:x])
        y = parse_integer(op[:y])
        operator = op[:operator] |> String.downcase |> String.to_atom

        case operator do
          :and    -> Dict.put(cache, op[:dest], band(x, y))
          :not    -> Dict.put(cache, op[:dest], bnot(x))
          :rshift -> Dict.put(cache, op[:dest], bsr(x, y))
          :lshift -> Dict.put(cache, op[:dest], bsl(x, y))
          :or     -> Dict.put(cache, op[:dest], bor(x, y))
        end
          |> parse_signals(tl(operations))
      else
        ops = Enum.concat(tl(operations), [get_wire_values(cache, op)])
        parse_signals(cache, ops)
      end
    end
  end

  def complete?(operation) do
    if operation[:signal] do
      false
    else
      [operation[:x], operation[:y]]
        |> Enum.all?(fn(x) ->
          is_nil(x) || is_integer(parse_integer(x))
        end)
    end
  end

  def get_wire_values(cache, operation) do
    Enum.map(operation, fn({k, v}) ->
      if cache[v] do
        {k, cache[v]}
      else
        {k, v}
      end
    end)
  end

  def parse_integer(nil) do
    nil
  end

  def parse_integer(n) do
    if is_integer(n) do
      n
    else
      case Integer.parse(n) do
        :error -> nil
        {n, _} -> n
      end
    end
  end
end

IO.puts SolverSeven.solve["a"]

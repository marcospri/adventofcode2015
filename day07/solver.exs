use Bitwise

defmodule Day7 do
  @instructions_regexp  [
    ~r/(NOT) (\w+) -> (\w+)/,
    ~r/(\w+) (\w+) ([\w\d]+) -> (\w+)/,
    ~r/([\w\d]+) -> (\w+)/,
  ]

  @intlimit 65535

  def try_regex _, [] do nil end
  def try_regex str, [regexh|t] do
    r = Regex.run(regexh, str)
    case r do
      nil -> 
        try_regex str, t
      [_, signal, wire] ->
        %{operator: "signal", dest: wire, signal: signal}
      [_, wire1, operator, wire2, wire3] ->
        %{op1: wire1, operator: operator, op2: wire2, dest: wire3}
      [_, operator, wire1, wire2] ->
        %{operator: operator, op1: wire1, dest: wire2}
    end
  end
  def parse_instructions str do try_regex str, @instructions_regexp end

  def build_circuit [], circuit do circuit end
  def build_circuit [instruction|t], circuit do
    circuit = Map.put(circuit, instruction[:dest], instruction)
    build_circuit t, circuit
  end

  def get_wire_signal circuit, wire, cache do
    case cache[wire] do
      nil ->
        r = Integer.parse(wire)
        case r do
          {n, _} ->
            cache = Map.put(cache, wire, n)
            {n, cache}
          :error -> 
            wire_input = circuit[wire]

            case wire_input[:operator] do
              "signal" ->
                r = Integer.parse(wire_input[:signal])
                case r do
                  :error ->
                    {get_wire_signal(circuit, wire_input[:signal], cache), cache}
                  {n, _} ->
                    cache = Map.put(cache, wire, n)
                    {n, cache}
                end
              "NOT" ->
                {op1, cache} = get_wire_signal(circuit, wire_input[:op1], cache) 
                val = @intlimit - op1
                cache = Map.put(cache, wire, val)
                {val, cache}
              "RSHIFT" ->
                shift = String.to_integer(wire_input[:op2])
                {op1, cache} = get_wire_signal(circuit, wire_input[:op1], cache) 
                val = op1 >>> shift
                cache = Map.put(cache, wire, val)
                {val, cache}
              "LSHIFT" ->
                shift = String.to_integer(wire_input[:op2])
                {op1, cache} = get_wire_signal(circuit, wire_input[:op1], cache) 
                val = op1 <<< shift
                cache = Map.put(cache, wire, val)
                {val, cache}
              "OR" ->
                {op1, cache} = get_wire_signal(circuit, wire_input[:op1], cache) 
                {op2, cache} = get_wire_signal(circuit, wire_input[:op2], cache) 
                val = bor(op1, op2)
                cache = Map.put(cache, wire, val)
                {val, cache}
              "AND" ->
                {op1, cache} = get_wire_signal(circuit, wire_input[:op1], cache) 
                {op2, cache} = get_wire_signal(circuit, wire_input[:op2], cache) 
                val = band(op1, op2)
                cache = Map.put(cache, wire, val)
                {val, cache}
          end
        end
        val ->
          {val, cache}
      end
  end
end

instructions = "input.txt"
|> File.stream!
|> Enum.map(&Day7.parse_instructions/1)

circuit = Day7.build_circuit instructions, %{}

IO.inspect (Day7.get_wire_signal circuit, "a", %{})

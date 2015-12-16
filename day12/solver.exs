defmodule Day12 do
  def parse_json str do
    Poison.Parser.parse!(str)
  end

  def is_red?  [], acc do acc end
  def is_red? d = %{}, acc do
    case  Enum.any?(Map.values(d), fn(x) -> x == "red" end) do
      true ->
        0 
      false ->
        v = Enum.map(Map.values(d), &(is_red?(&1, 0))) |> Enum.sum
        v + acc
    end
  end

  def is_red? [elem|t], acc do
     value = is_red? elem, 0
     is_red?(t, acc + value)
  end

  def is_red?(value, _) when value != "red" and is_integer value do value end
  def is_red?(value, _) do 0 end
end

"input.txt"
|> File.read!
|> to_string
|> Day12.parse_json
|> Day12.is_red?(0)
|> IO.puts

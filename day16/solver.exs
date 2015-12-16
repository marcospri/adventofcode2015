defmodule Day16 do
  def load_aunts line do 
    line = String.strip line
    [_, sue_number] = Regex.run(~r/Sue (\d+): /, line)

    rules = String.split(line, ", ")
    |> Enum.map(fn(p) -> 
      [_, r, qty] = Regex.run(~r/(\w+): (\d+)/, p)
      Map.put(%{}, r, String.to_integer(qty))
    end)
    |> Enum.reduce(&Map.merge/2)

    %{"sue" => String.to_integer(sue_number), "rules" => rules}
  end
end

"input.txt"
|> File.stream!
|> Enum.map(&Day16.load_aunts/1)
|> Enum.filter(fn(x) -> x["rules"]["children"] == nil || x["rules"]["children"] == 3 end)
|> Enum.filter(fn(x) -> x["rules"]["cats"] == nil || x["rules"]["cats"] > 7 end)
|> Enum.filter(fn(x) -> x["rules"]["samoyeds"] == nil || x["rules"]["samoyeds"] == 2 end)
|> Enum.filter(fn(x) -> x["rules"]["pomeranians"] == nil || x["rules"]["pomeranians"] < 3 end)
|> Enum.filter(fn(x) -> x["rules"]["akitas"] == nil || x["rules"]["akitas"] == 0 end)
|> Enum.filter(fn(x) -> x["rules"]["vizslas"] == nil || x["rules"]["vizslas"] == 0 end)
|> Enum.filter(fn(x) -> x["rules"]["goldfish"] == nil || x["rules"]["goldfish"] < 5 end)
|> Enum.filter(fn(x) -> x["rules"]["trees"] == nil || x["rules"]["trees"] > 3 end)
|> Enum.filter(fn(x) -> x["rules"]["cars"] == nil || x["rules"]["cars"] == 2 end)
|> Enum.filter(fn(x) -> x["rules"]["perfumes"] == nil || x["rules"]["perfumes"] == 1 end)
|> IO.inspect

defmodule Day17 do
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
      (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end

  def find_bottles(_, n_bottles, total_bottles) when n_bottles > total_bottles do 0 end
  def find_bottles bottles_sizes, n_bottles, total_bottles do
    total = combination(n_bottles, bottles_sizes)
    |> Enum.filter(fn(x) -> Enum.sum(x) == 150 end)
    |> Enum.count
    case total > 0 do
      true ->
        total
      false ->
        find_bottles bottles_sizes,  n_bottles + 1, total_bottles
    end
  end
  def find_bottles bottles do
    find_bottles bottles, 2, Enum.count(bottles)
  end

end

"input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.to_integer/1)
|> Day17.find_bottles
|> IO.puts

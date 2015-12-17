defmodule Day17 do
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
      (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end

  def find_bottles _, 0, n_combinations do n_combinations end
  def find_bottles bottles_sizes, n_bottles, n_combinations do
    total = combination(n_bottles, bottles_sizes)
    |> Enum.filter(fn(x) -> Enum.sum(x) == 150 end)
    |> Enum.count
    find_bottles bottles_sizes,  n_bottles - 1, n_combinations + total
  end
  def find_bottles bottles do
    find_bottles bottles, Enum.count(bottles), 0
  end

end

"input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.to_integer/1)
|> Day17.find_bottles
|> IO.puts

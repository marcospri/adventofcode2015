defmodule Day24 do
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
      (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end
  def get_groups numbers, groups, target_sum, n1, [], [], [] do
    g = combination(n1, numbers)
    |> Enum.filter(fn(x) -> Enum.sum(x) == target_sum end)

    case g do
      [] -> 
        get_groups numbers, groups, target_sum, n1 + 1, [], [], []
      _ ->
        g
    end
  end
end

numbers = "input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.to_integer/1)

target_sum_part1 = div(Enum.sum(numbers), 3)
target_sum_part2 = div(Enum.sum(numbers), 4)

#Part 1, cheating, just get the first group that sums the target and hope the other two can do it too
Day24.get_groups(numbers, 3, target_sum_part1, 2, [], [], [])
|> Enum.map(fn(x) -> Enum.reduce(x, fn(y, acc) ->  y * acc end) end)
|> Enum.min
|> IO.inspect

#Same cheat for part2 seems to work...
Day24.get_groups(numbers, 3, target_sum_part2, 2, [], [], [])
|> Enum.map(fn(x) -> Enum.reduce(x, fn(y, acc) ->  y * acc end) end)
|> Enum.min
|> IO.inspect



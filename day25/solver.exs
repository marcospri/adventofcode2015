defmodule Day25 do
  def code(1), do: 20151125
  def code(n), do: rem(code(n-1) * 252533, 33554393)

  def number(row, column), do: Enum.sum(1..row + column - 2) + column
end

row = 2978
column = 3083

n = Day25.number(row, column)

Day25.code(n)
|> IO.puts

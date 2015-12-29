defmodule Day20 do
  def divisors(n) do
    #Copy pasted this bit
    e = n |> :math.sqrt |> trunc

    (1..e)
    |> Enum.flat_map(fn
      x when rem(n, x) != 0 -> []
      x when x != div(n, x) -> [x, div(n, x)]
      x -> [x]
    end)
  end

  def house_gifts house, cache do
    f = divisors(house) |> Enum.sort |> Enum.filter(fn(x) -> div(house, x) <= 50 end)
    gifts = f |> Enum.map(&(&1 * 11)) |> Enum.sum
    {gifts, cache}
  end

  def find_house min do
    find_house min, 1, %{} #Head start
  end

  defp find_house min, house, cache do
    {gifts, cache} = house_gifts(house, cache) 
    case gifts >= min do
      true ->
        house
      false ->
        find_house(min, house + 1, cache)
    end
  end
end

Day20.find_house(33100000)
|> IO.inspect

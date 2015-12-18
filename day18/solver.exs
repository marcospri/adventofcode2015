defmodule Day18 do
  def load_board file_name do
    file_name
    |> File.stream!
    |> Enum.map(&String.strip/1)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
  end

  def light_at(_, {x, y}) when (x < 0 or y < 0), do:  {".", x}
  def light_at(lights, {x,y}) do
    case Enum.at(lights, y) do
      nil -> {".", x}
      {row, _} -> Enum.at(row, x) || {".", x}
    end
  end

  def neighbors(x,y) do 
    [ 
      {x, y-1}, {x+1, y-1}, {x+1, y}, {x+1, y+1}, 
      {x, y+1}, {x-1, y+1}, {x-1, y}, {x-1, y-1}
    ]
  end

  def next_light_at old_lights, {x,y}, light do
    lights_on = 
      neighbors(x,y)
      |> Enum.map(fn(pos) -> Day18.light_at(old_lights, pos) end)
      |> Enum.count(fn({l, _ })  -> l == "#" end)

    cond do
      light == "#" and (lights_on == 2 or lights_on == 3) ->
        {"#", x}
      light == "." and (lights_on == 3) ->
        {"#", x}
      true ->
        {".", x} 
    end
  end

  def update_lights lights do
    Enum.map(lights, fn({row, y}) -> 
      Enum.map(row, fn({l, x}) ->
        next_light_at lights, {x,y}, l
      end)
    end)
    |> Enum.with_index
  end

  def update_lights lights, 0 do lights end
  def update_lights lights, times do
    lights = update_lights(lights)
    update_lights(lights, times - 1)
  end
end

start_board = "input.txt" |> Day18.load_board
board = Day18.update_lights start_board, 100

board
|> Enum.map(fn({row, _}) -> 
      Enum.count(row, fn({l, _}) -> l == "#" end)
   end)
|> Enum.sum
|> IO.inspect


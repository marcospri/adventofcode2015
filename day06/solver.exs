defmodule Day6 do
  def switch "turn on", _ do true end
  def switch "turn off", _ do false end
  def switch "toggle", true do false end
  def switch "toggle", false do true end
  def switch "toggle", nil do true end

  def switch_part2 "turn on", nil do 1 end
  def switch_part2 "turn on", n do n + 1 end
  def switch_part2 "turn off", nil do 0 end
  def switch_part2 "turn off", 0 do 0 end
  def switch_part2 "turn off", n do n - 1 end
  def switch_part2 "toggle", nil do 2 end
  def switch_part2 "toggle", n do n + 2 end



  def new_lights size do 
    for _ <- 1..size, do: (for _ <- 1..size, do: false)
  end

  def parse_instructions str do
    [_, type, x1, y1, x2, y2] = Regex.run(~r/(turn on|toggle|turn off) (\d+),(\d+) through (\d+),(\d+)/, str)
    {x1, _} = Integer.parse(x1)
    {y1, _} = Integer.parse(y1)
    {x2, _} = Integer.parse(x2)
    {y2, _} = Integer.parse(y2)
    {type, x1, y1, x2, y2}
  end 

  def update_points [], lights, _ do lights end
  def update_points [{type, x, y}|t], lights, switch_type do
    lights = Map.put(lights, {x,y}, switch_type.(type, lights[{x,y}]))
    update_points(t, lights, switch_type)
  end

  def apply_instructions [], _, lights do lights end
  def apply_instructions [h|t], switch_type, lights do
    {type, x1, y1, x2, y2} = h
    points = List.flatten(for x <- x1..x2, do: (for y <- y1..y2, do: {type, x, y}))
    lights = update_points(points, lights, switch_type)

    apply_instructions t, switch_type, lights
  end

end

santa_instructions = "input.txt"
|> File.stream!
|> Enum.map(&Day6.parse_instructions/1)


n_ligths_on = Day6.apply_instructions(santa_instructions, &Day6.switch/2, %{})
|> Map.values
|> Enum.count(fn(x) -> x == true end)


ligths_on_values = Day6.apply_instructions(santa_instructions, &Day6.switch_part2/2, %{})
|> Map.values
|> Enum.sum


IO.puts "#{n_ligths_on} lights on after instructions (part 1)"
IO.puts "#{ligths_on_values} lights levels sum on after instructions (part 2)"

defmodule Day3 do
  def char_to_movement("^") do  {0, 1} end
  def char_to_movement(">") do  {1, 0} end
  def char_to_movement("<") do  {-1, 0} end
  def char_to_movement("v") do  {0, -1} end

  def next_house({posX, posY}, {movX, movY}) do
    {posX + movX,  posY + movY}
  end
  
  def deliver_presents([char|rest], map, position) do
    new_position = next_house(position, char_to_movement(char))
    updated_map = Map.put(map, new_position, true)
    Day3.deliver_presents(rest, updated_map, new_position)
  end
  
  def deliver_presents([], map, _) do map end
end

mov_chars = 
  "input.txt"
  |> File.read!
  |> String.strip
  |> String.codepoints
 

santa_map =
  mov_chars
  |> Enum.take_every(2)
  |> Day3.deliver_presents(%{{0, 0} => true}, {0, 0})


[_|robot_chars] = mov_chars

total_map =
  robot_chars
  |> Enum.take_every(2)
  |> Day3.deliver_presents(santa_map, {0, 0})

houses = Map.size total_map

IO.puts "#{houses} houses got at least one present."

defmodule Day1 do
  def calculate_floor("(" <> rest, position, below_position, floor) do 
    calculate_floor(rest, position + 1, below_position, floor +  1) 
  end

  def calculate_floor(")" <> rest, position, below_position, floor) do 
    case {floor, below_position} do 
     {0, 0} -> 
        calculate_floor(rest, position + 1, position + 1, floor -  1) 
      _ ->
        calculate_floor(rest, position + 1, below_position, floor -  1) 
    end
  end
  def calculate_floor("\n" <> _, _, below_position, floor) do {below_position, floor} end
end

result = "input.txt"
|> File.read!
|> Day1.calculate_floor(0, 0, 0)

case result do
  {0, floor} ->
    IO.puts "Never below 0 floor. Last floor is #{floor}"
  {b, floor} ->
    IO.puts "First time below floor 0 at position #{b}. Last floor is #{floor}"
end


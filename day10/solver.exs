defmodule Day10 do
  def look_and_say [], current_number, current_count, next do 
    next = next <> Integer.to_string(current_count) <> current_number
    next 
  end

  def look_and_say([h|str], current_number, current_count, next) when h == current_number do
    look_and_say str, current_number, current_count + 1, next
  end

  def look_and_say([h|str], current_number, current_count, next) when h != current_number do
    next = next <> Integer.to_string(current_count) <> current_number
    look_and_say str, h, 1, next
  end

  def look_and_say str do
    chars = String.codepoints(str)
    [first|rest] = chars
    look_and_say rest, first, 1, ""
  end

  def repeat str, 1 do
    look_and_say str
  end

  def repeat str, times do
    str = look_and_say str
    Day10.repeat str, times - 1
  end
end

input = "3113322113"


result = Day10.repeat(input, 50)
result_length = String.length result

IO.puts "#{result} length is #{result_length}"

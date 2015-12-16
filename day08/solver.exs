defmodule Day8 do

  def count_total str do
    String.length str
  end

  def count_real str do
    str = Regex.replace(~r/\\\\/, str, "#")
    str = Regex.replace(~r/\\\"/, str, "#")
    str = Regex.replace(~r/\\x[\da-f]{2}/, str, "#")
    str = Regex.replace(~r/\"/, str, "")
    String.length str
  end

  def count_grow str do 
    str = Regex.replace(~r/\\/, str, "##")
    str = Regex.replace(~r/\"/, str, "##")
    str = "\"#{str}\""
    String.length str
  end

  def count_part1 str do
    count_total(str) - count_real(str)
  end

  def count_part2 str do
    count_grow(str) - count_total(str)
  end
end

"input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&Day8.count_part1/1)
|> Enum.sum
|> IO.puts

"input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&Day8.count_part2/1)
|> Enum.sum
|> IO.puts

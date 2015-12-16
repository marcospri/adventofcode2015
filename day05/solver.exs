defmodule Day5 do
  def is_vowel?(char) when 
      char == "a" or char == "e" or char == "i" or char == "o" or char == "u" do 
    true 
  end
  def is_vowel? _ do false end

  def condition1? str do
    #It contains at least three vowels (aeiou only),
    #like aei, xazegov, or aeiouaeiouaeiou.
    condition1_search str, []
  end

  def condition1_search(_, vowel_list)  when length(vowel_list) == 3 do true end
  def condition1_search [h|t], vowel_list do 
    vowel_list = case is_vowel? h do
      true ->
        vowel_list ++ [h]
      false ->
        vowel_list
    end
    condition1_search t, vowel_list
  end
  def condition1_search [], _ do false end

  def condition2? [h|t] do
    #It contains at least one letter that appears twice in a row,
    #like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
      condition2_search t, h
  end
  
  def condition2_search [], _ do false end
  def condition2_search([h|_], char)  when h == char do  true end
  def condition2_search([h|t], _)  do condition2_search t, h end

  def condition3? str do
    #It does not contain the strings ab, cd, pq, or xy,
    #even if they are part of one of the other requirements.
    ! Regex.match?(~r/ab|cd|pq|xy/, to_string str)
  end

  def part2_condition1 str do
    Regex.match?(~r/(\w{2})\w*\1/, to_string str)
  end

  def part2_condition2 str do
    Regex.match?(~r/(\w)\w\1/, to_string str)
  end
end

part1_rules_nice = "input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.codepoints/1)
|> Enum.filter(&Day5.condition1?/1)
|> Enum.filter(&Day5.condition2?/1)
|> Enum.filter(&Day5.condition3?/1)
|> Enum.count

part2_rules_nice = "input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.codepoints/1)
|> Enum.filter(&Day5.part2_condition1/1)
|> Enum.filter(&Day5.part2_condition2/1)
|> Enum.count

IO.puts "#{part1_rules_nice} nice strings with part 1 rules"
IO.puts "#{part2_rules_nice} nice strings with part 2 rules"

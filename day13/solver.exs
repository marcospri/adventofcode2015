defmodule Day13 do
  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

  def parse str do
    [_, person1, type, happiness, person2] =
      Regex.run ~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)/, str

    case type do
      "gain" -> {person1, person2, String.to_integer(happiness)}
      "lose" -> {person1, person2, String.to_integer(happiness) * -1}
    end
  end

  def generate_rules [], rules, people do {rules, people} end
  def generate_rules [h|t], rules, people do 
    {p1, p2, value} = h

    people = Set.put(people, p1)
    people = Set.put(people, p2)

    rules = Map.put(rules, {p1, p2}, value)

    generate_rules t, rules, people
  end
  def generate_rules rules do 
    generate_rules rules, %{}, HashSet.new
  end

  def find_better_table [], _, max do max end
  def find_better_table [h|t], rules, max do
    table = h ++ [List.first(h)] #Make it a circle

    happiness = total_happiness table, rules, 0
    min = case happiness > max do
      true -> 
        IO.inspect table
        happiness
      _ -> max
    end
    find_better_table t, rules, min
  end

  def total_happiness [_], _, happiness do happiness end
  def total_happiness [h|t], rules, happiness do
    {p1, p2} = {h, hd(t)}
    happiness = rules[{p1,p2}] + rules[{p2,p1}] + happiness
    total_happiness t, rules, happiness
  end
end

{rules, people} = "input.txt"
|> File.stream!
|> Enum.map(&Day13.parse/1)
|> Day13.generate_rules

posible_tables = Day13.permute(Set.to_list(people))
n_possible_tables = (Enum.count(posible_tables))
IO.puts "Trying #{n_possible_tables} table arragments"

max_happines = Day13.find_better_table posible_tables, rules, 0
IO.puts max_happines

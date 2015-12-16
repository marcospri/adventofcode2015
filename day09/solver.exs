defmodule Day9 do
  def parse str do
    [_, origin, dest, distance] = Regex.run(~r/(\w+) to (\w+) = (\d+)/, str)
    {origin, dest, distance}
  end

  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

  def load_distances [], distances, cities do {distances, cities} end
  def load_distances [h|t], distances, cities do
    {origin, dest, distance} = h

    distances = Map.put(distances, {origin, dest}, distance)
    cities = Set.put(cities, origin)
    cities = Set.put(cities, dest)

    load_distances t, distances, cities
  end

  def calculate_distance [_], _ do 0 end
  def calculate_distance [c1|t], distances do
  	c2 = List.first(t)
	length = distances[{c1, c2}] 
	case length do
	  nil ->
	    length = distances[{c2, c1}]
	    String.to_integer(length) + calculate_distance(t, distances)
	  _ ->
	    String.to_integer(length) + calculate_distance(t, distances)
	end
  end

  def problem_distance _, [], _, min do min end
  def problem_distance comp, [path|t], distances, min do
	d = calculate_distance path, distances
	case comp.(d, min) do
	  true ->
	    problem_distance comp, t, distances, d
	  false ->
	    problem_distance comp, t, distances, min
	end
  end
end

file_distances = "input.txt"
|> File.stream!
|> Enum.map &Day9.parse/1

{distances_map, cities} = Day9.load_distances file_distances, %{}, HashSet.new
posible_paths = Day9.permute (Set.to_list(cities))

IO.puts(Day9.problem_distance &</2, posible_paths, distances_map, 10000000)
IO.puts(Day9.problem_distance &>/2, posible_paths, distances_map, 0)


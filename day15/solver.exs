defmodule Day15 do
  def calculate_recipe({sugar, sprinkles, candy, chocolate}, ingredients) do
    sugar_total = Enum.map(ingredients["sugar"], fn(v) -> sugar * v end)
    sprinkles_total = Enum.map(ingredients["sprinkles"], fn(v) -> sprinkles * v end)
    candy_total = Enum.map(ingredients["candy"], fn(v) -> candy * v end)
    chocolate_total = Enum.map(ingredients["chocolate"], fn(v) -> chocolate * v end)

    [calories|rest] = List.zip([sugar_total, sprinkles_total, candy_total, chocolate_total])
     |> Enum.map(fn({x,y,z,w}) -> max(x+y+z+w, 0) end)
     |> Enum.reverse 

     case calories do
       500 -> Enum.reduce(rest, &*/2)
       _ -> 0 
     end
  end

  def all_recipes ingredients do
    (for x <- 1..100, do: 
      (for y <- 1..100 - x, do: 
        (for z <- 1..100 - x - y, do: 
          (for v <- 1..100 - x - y - z, do: 
            calculate_recipe({x,y,z,v}, ingredients)))))
    |> List.flatten
  end
end

#Not feeling like parsing the input
ingredients = %{
  "sugar"=> [3, 0, 0, -3, 2],
  "sprinkles"=> [-3, 3, 0, 0, 9],
  "candy"=> [-1, 0, 4, 0, 1],
  "chocolate"=> [0, 0, -2, 2, 8],
}

Day15.all_recipes(ingredients)
|> Enum.max
|> IO.puts

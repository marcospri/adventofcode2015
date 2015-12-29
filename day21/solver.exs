defmodule Day21 do
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
      (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end

  def combine_loot weapon, armor, rings do 
    [weapon, armor, rings]
    |> List.flatten
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> List.to_tuple
  end

  def battle({boss_points, _, _}, {_, cost, _, _}, _) when boss_points <= 0 do
    {true, cost}
  end

  def battle(_, {player_points, cost, _, _}, _) when player_points <= 0 do
    {false, cost}
  end

  def battle({boss_points, boss_damage, boss_armor}, {points, cost, damage, armor}, round) do
    if rem(round, 2) == 0 do
      player_damage = max((damage - boss_armor), 1)
      battle({boss_points - player_damage, boss_damage, boss_armor}, {points, cost, damage, armor}, round + 1)

    else
      boss = max((boss_damage - armor), 1)
      battle({boss_points, boss_damage, boss_armor}, {points - boss, cost, damage, armor}, round + 1)
    end
  end
end

weapons = [
  {8, 4, 0},
  {10, 5, 0},
  {25, 6, 0},
  {40, 7, 0},
  {74, 8, 0},
]

armor = [
  {0, 0, 0}, #No armor
  {13, 0, 1},
  {31, 0, 2},
  {53, 0, 3},
  {75, 0, 4},
  {102, 0, 5},
]

rings = [
  {0, 0, 0}, #No ring
  {0, 0, 0}, #No ring
  {25, 1, 0},
  {50, 2, 0},
  {100, 3, 0},
  {20, 0, 1},
  {40, 0, 2},
  {80, 0, 3},
]

boss_stats = {103, 9, 2}

ring_combinations = Day21.combination(2, rings)

(for weapon <- weapons, do: 
  (for armor <- armor, do:
    (for ring <- ring_combinations do
      loot_stats = Day21.combine_loot(weapon, armor, ring)
      loot_stats = Tuple.insert_at(loot_stats, 0, 100)
      Day21.battle(boss_stats, loot_stats, 0)
    end)))
|> List.flatten
|> Enum.filter(fn ({win, _}) -> not win end)
|> Enum.max_by(fn ({_, cost}) -> cost end)
|> IO.inspect

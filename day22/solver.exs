defmodule Day22 do
  #This is the crappiest of my solutions
  @spells [
    {:missile, 53, :effect, 0},
    {:drain, 73, :effect, 0},
    {:shield, 113, :effect, 6},
    {:poison, 173, :effect, 6},
    {:recharge, 229, :effect, 5},
  ]

  def apply_spell({:missile, spell_mana, _, _}, {boss_points, boss_damage}, {points, mana, effects, spent_mana}) do
    {
      {boss_points - 4, boss_damage}, 
      {points, mana - spell_mana, effects, spent_mana + spell_mana}
    }
  end

  def apply_spell({:drain, spell_mana, _, _}, {boss_points, boss_damage}, {points, mana, effects, spent_mana}) do
    {
      {boss_points - 2, boss_damage}, 
      {points + 2 , mana - spell_mana, effects, spent_mana + spell_mana}
    }
  end

  def apply_spell({spell, spell_mana, :effect, turns}, {boss_points, boss_damage}, {points, mana, effects, spent_mana}) do
    effects = Map.put(effects, spell, turns)
    {
      {boss_points, boss_damage}, 
      {points, mana - spell_mana, effects, spent_mana + spell_mana}
    }
  end

  def apply_effects effects do
    armor = if effects[:shield] > 0, do: 7, else: 0 
    poison = if effects[:poison] > 0, do: 3, else: 0 
    extra_mana = if effects[:recharge] > 0, do: 101, else: 0 
    
    effects = Dict.update(effects, :poison, 0, fn(v) -> max(v - 1, 0) end)
    effects = Dict.update(effects, :recharge, 0, fn(v) -> max(v - 1, 0) end)
    effects = Dict.update(effects, :shield, 0, fn(v) -> max(v - 1, 0) end)
    
    {armor, poison, extra_mana, effects} 
  end

  def posible_spells mana, effects do
    @spells 
    |> Enum.filter(fn({_, cost, _, _}) -> cost <= mana end)
    |> Enum.filter(fn({name, _, _, turns}) -> turns == 0 or effects[name] <= 0 end)
  end

  def battle({boss_points, _}, {_, _, _, spent_mana}, _, sh) when boss_points <= 0 do
    IO.puts spent_mana
    {true, spent_mana}
  end

  def battle(_, {points, _, _, spent_mana}, _, sh) when points <= 0 do
    {false, spent_mana}
  end

  def battle({boss_points, boss_damage}, {points, mana, effects, spent_mana}, round, sh) when rem(round, 2) == 1 do
    {armor, poison, extra_mana, effects} = apply_effects effects
    dealt_damage = max(boss_damage - armor, 1) 
    battle({boss_points - poison, boss_damage}, {points - dealt_damage, mana + extra_mana, effects, spent_mana}, round + 1, sh)
  end

   def battle({boss_points, boss_damage}, {points, mana, effects, spent_mana}, round, spell_history) do
    #Part 2
    points = points - 1
    if points == 0 do
      []  
    else
      {_, poison, extra_mana, effects} = apply_effects effects
      spells = posible_spells mana, effects
      case spells do 
        [] ->
          []
        _ ->
          (for spell <- spells do
            s = apply_spell(spell, {boss_points, boss_damage}, {points, mana, effects, spent_mana})
            case s do
                {false, _} -> 
                  []
                {{b_p, b_d}, {p, m, effects, spent_mana}} -> 
                  battle({b_p - poison, b_d}, {p, m + extra_mana, effects, spent_mana}, round + 1, [spell|spell_history])
            end
          end)
        end
    end
  end
end
boss_stats = {51, 9}
#boss_stats = {14, 8}

Day22.battle(boss_stats, {50, 500, %{:shield => 0, :poison => 0, :recharge => 0},  0}, 0, [])
|> List.flatten
|> Enum.filter(fn ({win, _}) -> win end)
|> Enum.min_by(fn ({_, v}) -> v end)
|> IO.inspect

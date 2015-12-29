defmodule Day19 do
  def load_input file do
    [rules, molecule] = File.read!(file)
    |> String.split("\n\n")
    {rules, inverse_rules} = load_rules(String.split(rules, "\n"), %{}, %{})
    atoms = split_molecule(String.strip(molecule))

    {rules, inverse_rules, atoms}
  end

  def load_rules([], rules_map, inverse_rules), do: {rules_map, inverse_rules}
  def load_rules [rule|t], rules_map, inverse_rules  do
    [lhside, rhside] = String.split(rule, "=>") 
    lhside = String.strip lhside
    rhside = String.strip rhside

    inverse_rules = Map.put(inverse_rules, String.reverse(rhside), String.reverse(lhside))

    case rules_map[lhside] do
      nil ->
        rules_map = Map.put(rules_map, lhside, [rhside])
      n ->
        rules_map = Map.put(rules_map, lhside, [rhside|n])
    end
    load_rules t, rules_map, inverse_rules
  end

  def split_molecule(mol), do: split_molecule mol, []
  defp split_molecule("", atoms), do: atoms
  defp split_molecule mol, atoms do
    [atom] = Regex.run(~r/[A-Z][a-z]?/, mol)
    mol = String.slice(mol, String.length(atom)..String.length(mol))
    
    split_molecule(mol, [atom|atoms])
  end

  def updated_molecules(_, _, [], posibilities), do: posibilities
  def updated_molecules molecules, index, [subtitution|t], posibilities do
    molecule = List.replace_at(molecules, index, subtitution)
    |> Enum.reverse
    |> Enum.join

    posibilities = Set.put(posibilities, molecule)

    updated_molecules molecules, index, t, posibilities
  end

  def generate_all_molecules(molecules, rules) do
    generate_all_molecules molecules, rules, Enum.count(molecules) - 1, HashSet.new
  end

  defp generate_all_molecules(_, _, -1, posibilities), do: posibilities
  defp generate_all_molecules(molecules, rules, index, posibilities) do 
    atom_substitutions = rules[Enum.at(molecules, index)] || []
    new_molecules = updated_molecules(molecules, index, atom_substitutions, posibilities)

    generate_all_molecules(molecules, rules, index - 1, new_molecules)
  end
end

{rules, inverse_rules, atoms} = 
  "input.txt"
  |> Day19.load_input

Day19.generate_all_molecules(atoms, rules)
|> Enum.count
|> IO.inspect


# For part2 i got stuck, tried different aproaches and end up giving up
# Ideas from reddit didn't help (niether the actual implementantions there, at least the go & python I tried)
# Finally this guys post is the more clever solution without any real code:
# https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/cy4etju
total = Enum.count(atoms)
sides = Enum.count(atoms, fn(x) -> x == "Rn" || x == "Ar"  end)
content = Enum.count(atoms, fn(x) -> x == "Y" end)

solution = total - sides - (2 * content) - 1
IO.puts solution



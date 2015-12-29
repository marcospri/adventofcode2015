defmodule Day23 do
  def parse str do
    instruction_parts = Regex.run(~r/(hlf|tpl|inc|jmp|jie|jio) (a|b|(-|\+)\d+)(, ((-|\+)\d+))?/, str)

    parse_inc instruction_parts
  end

  defp parse_inc([_, "inc", reg]), do: %{:instruction => "inc", :reg => reg}
  defp parse_inc([_, "hlf", reg]), do: %{:instruction => "hlf", :reg => reg}
  defp parse_inc([_, "tpl", reg]), do: %{:instruction => "tpl", :reg => reg}
  defp parse_inc([_, inst, reg, _, _, offset|_]) do
    jump = String.to_integer(offset)
    %{:instruction => inst, :reg => reg, :offset => jump}
  end
  defp parse_inc([_, "jmp", offset, _]) do
    jump = String.to_integer(offset)
    %{:instruction => "jmp", :offset => jump}
  end

  def execute program do
    execute %{"a" => 0, "b" => 0}, program, 0, Enum.count(program)
  end

  def execute_part2 program do
    execute %{"a" => 1, "b" => 0}, program, 0, Enum.count(program)
  end

  defp execute(registers, _, ip, program_length) when ip >= program_length, do: registers
  defp execute registers, program, ip, program_length do
    inst = Enum.at(program, ip)

    case inst[:instruction] do
      "inc" -> 
        registers = Dict.update!(registers, inst[:reg], fn(v) -> v + 1 end)
        execute registers, program, ip + 1, program_length
      "tpl" -> 
        registers = Dict.update!(registers, inst[:reg], fn(v) -> v * 3 end)
        execute registers, program, ip + 1, program_length
      "hlf" -> 
        registers = Dict.update!(registers, inst[:reg], fn(v) -> div(v, 2) end)
        execute registers, program, ip + 1, program_length
      "jio" -> 
        is_one = registers[inst[:reg]] == 1
        if is_one do
          execute registers, program, ip + inst[:offset], program_length
        else
          execute registers, program, ip + 1, program_length
        end
      "jie" -> 
        is_even = rem(registers[inst[:reg]], 2) == 0
        if is_even do
          execute registers, program, ip + inst[:offset], program_length
        else
          execute registers, program, ip + 1, program_length
        end
      "jmp" -> 
          execute registers, program, ip + inst[:offset], program_length
    end
  end
end

program = "input.txt"
|> File.stream!
|> Enum.map(&Day23.parse/1)

Day23.execute(program)
|> IO.inspect

Day23.execute_part2(program)
|> IO.inspect

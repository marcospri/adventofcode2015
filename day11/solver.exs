defmodule Day11 do
  @ascii_a 97

  def next_pass str do Enum.reverse(next_pass_list(Enum.reverse str)) end
  def next_pass_list [h|t] do  
    nc = next_char h
    case nc do
      @ascii_a ->
        [@ascii_a|next_pass_list t]
      _ ->
        [nc|t]
    end
  end

  def next_char char do 
    char = char - @ascii_a
    next = char + 1
    next = rem next, 26
    next = next + @ascii_a

    next
  end

  def has_increasing _, 2 do true end
  def has_increasing [_], _ do false end
  def has_increasing [h|t], count do 
    case h + 1== hd(t) do
      true ->
        has_increasing t, count + 1
      false ->
        has_increasing t, 0
    end
  end

  def valid? pass do 
    pass = to_string pass

    condition1 = has_increasing(to_char_list(pass), 0)
    condition2 = !Regex.match?(~r/(i|o|l)/, pass)
    condition3 = Regex.match?(~r/(\w)\1\w*(\w)\2/, pass)

    condition1 && condition2 && condition3
  end

  def find_next_valid_pass str do
    next = next_pass(to_char_list(str))
    case valid? next do
      true -> 
        IO.puts next
        next
      false ->
        find_next_valid_pass next
    end
  end
end

"hxbxwxba"
|> Day11.find_next_valid_pass
|> Day11.find_next_valid_pass

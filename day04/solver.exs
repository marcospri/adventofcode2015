defmodule Day4 do
  def hex_hash(key, number) do
    Base.encode16(:erlang.md5(key <> Integer.to_string(number)))
  end

  def expensive_coin?("000000" <> _) do true end 
  def expensive_coin?(_) do false end 

  def coin?("00000" <> _) do true end 
  def coin?(_) do false end 

  def mine_coin(hash, number, test_func) do
    case test_func.(Day4.hex_hash(hash, number)) do
      true ->
        number
      false ->
        mine_coin(hash, number + 1, test_func)
    end
  end
end

secret_key = "iwrupvqb"

IO.puts Day4.mine_coin(secret_key, 0, &Day4.coin?/1)
IO.puts Day4.mine_coin(secret_key, 0, &Day4.expensive_coin?/1)

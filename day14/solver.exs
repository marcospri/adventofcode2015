defmodule Day14 do
  def where? _, {position, 0, _, _}, position_history do position_history end
  def where? {speed, burst, rest}, {position, seconds_left, :moving, phase_seconds_left}, position_history do
      seconds_left = seconds_left - 1
      position = position + speed
      phase_seconds_left = phase_seconds_left - 1

      position_history = [position|position_history]
      case phase_seconds_left do
        0 ->
          where? {speed, burst, rest}, {position, seconds_left, :resting, rest}, position_history
        _ ->
          where? {speed, burst, rest}, {position, seconds_left, :moving, phase_seconds_left}, position_history
      end
  end

  def where? {speed, burst, rest}, {position, seconds_left, :resting, phase_seconds_left}, position_history do
      seconds_left = seconds_left - 1
      phase_seconds_left = phase_seconds_left - 1

      position_history = [position|position_history]
      case phase_seconds_left do
        0 ->
          where? {speed, burst, rest}, {position, seconds_left, :moving, burst}, position_history
        _ ->
          where? {speed, burst, rest}, {position, seconds_left, :resting, phase_seconds_left}, position_history
      end
  end

  def where? {speed, burst, rest}, seconds do
    where?({speed, burst, rest}, {0, seconds, :moving, burst}, [])
  end

  def find_all_index c do
    find_all_index c, 0, 0, [] end
  def find_all_index [], _, _, indexes do indexes end
  def find_all_index [h|t], index, score, indexes do
    cond do
      h > score -> 
        find_all_index t, index + 1, h, [index]
      h == score ->
        find_all_index t, index + 1, score, [index|indexes]
      true ->
        find_all_index t, index + 1, score, indexes
    end
  end
end

[
  Day14.where?({27, 5, 132}, 2503),
  Day14.where?({22, 2, 41}, 2503),
  Day14.where?({11, 5, 48}, 2503),
  Day14.where?({28, 5, 134}, 2503),
  Day14.where?({4, 16, 55}, 2503),
  Day14.where?({14, 3, 38}, 2503),
  Day14.where?({3, 21, 40}, 2503),
  Day14.where?({18, 6, 103}, 2503),
  Day14.where?({18, 5, 84}, 2503),
]
|> List.zip
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(&Day14.find_all_index/1)
|> List.flatten
|> Enum.group_by(fn(x) -> x end)
|> Map.values
|> Enum.map(&Enum.count/1)
|> Enum.max
|> IO.inspect

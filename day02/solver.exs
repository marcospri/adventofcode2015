defmodule Day2 do
  def clean_box_size(box_size) do
    [{l, _}, {w, _}, {h, _}] = 
      box_size 
      |> String.strip 
      |> String.split("x")
      |> Enum.map &Integer.parse/1
    [l, w, h]
  end

  def smallest_side(box_sizes) do
    box_sizes -- [Enum.max box_sizes]
  end

  def bow_ribbon(box_sizes) do
    box_sizes
    |> Enum.reduce &*/2
  end

  def box_ribbon(box_sizes) do
    smallest = smallest_side box_sizes
    (smallest |> Enum.reduce &+/2) * 2
  end

  def total_ribbon(box_size) do
    size = clean_box_size box_size
    bow_r = bow_ribbon size
    box_r = box_ribbon size

    box_r + bow_r
  end

  def box_paper_need(box_size) do
    [l, w, h] = clean_box_size box_size
    smallest = 
      smallest_side([l, w, h])
      |> Enum.reduce  &*/2

    2*l*w + 2*w*h + 2*h*l + (smallest)
  end
end

paper =
  "input.txt"
  |> File.stream!
  |> Enum.map(&Day2.box_paper_need/1)
  |> Enum.reduce &+/2


ribbon =
  "input.txt"
  |> File.stream!
  |> Enum.map(&Day2.total_ribbon/1)
  |> Enum.reduce &+/2


IO.puts "Total papper needed #{paper}"
IO.puts "Total ribbon needed #{ribbon}"

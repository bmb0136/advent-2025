defmodule Day5 do
  def line_to_ints(arr) do
    arr |> Enum.map(&(String.to_integer(&1)))
  end

  def in_range(x, r) do
    [a, b] = r
    x >= a and x <= b
  end

  def is_fresh(x, fresh_ids) do
    fresh_ids |> Enum.any?(&(in_range(x, &1)))
  end
end


[file_name] = System.argv()
{:ok, input} = File.read(file_name)
lines = String.split(input, "\n")

fresh_ids = Stream.filter(lines, &(&1 =~ "-"))
  |> Stream.map(&(&1 |> String.split("-")))
  |> Enum.map(&(Day5.line_to_ints(&1)))

spoiled = Stream.filter(lines, &(!(&1 =~ "-") and &1 != ""))
  |> Enum.map(&(String.to_integer(&1)))
  |> Enum.filter(&(Day5.is_fresh(&1, fresh_ids)))
  |> Enum.count()

IO.puts("Answer: " <> Integer.to_string(spoiled))

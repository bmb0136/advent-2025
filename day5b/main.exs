defmodule Day5 do
  def line_to_range(arr) do
    [a, b] = arr |> Enum.map(&(String.to_integer(&1)))
    %{start: a, count: b - a + 1}
  end

  def get_longest(group) do
    {_, vals} = group
    Enum.max_by(vals, &(&1.count))
  end

  def get_shortest(group) do
    {_, vals} = group
    Enum.min_by(vals, &(&1.count))
  end

  def merge_pairs(ranges) do

    if length(ranges) == 1 do
      ranges
    else
      [r1, r2] = ranges
      [%{start: r1.start, count: min(r2.start - r1.start, r1.count)}, r2]
    end
  end
end


[file_name] = System.argv()
{:ok, input} = File.read(file_name)
lines = String.split(input, "\n")

fresh_count = Stream.filter(lines, &(&1 =~ "-"))
  |> Stream.map(&(&1 |> String.split("-")))
  |> Stream.map(&(Day5.line_to_range(&1)))
  |> Enum.group_by(&(&1.start))
  |> Stream.map(&(Day5.get_longest(&1)))
  |> Enum.sort_by(&(&1.start))
  |> Enum.chunk_every(2, 1)
  |> Stream.flat_map(&(Day5.merge_pairs(&1)))
  |> Enum.group_by(&(&1.start))
  |> Stream.map(&(Day5.get_shortest(&1)))
  |> Stream.map(&(&1.count))
  |> Enum.sum()

IO.puts("Answer: " <> Integer.to_string(fresh_count))

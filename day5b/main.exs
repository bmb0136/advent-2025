defmodule Day5 do
  def line_to_range(arr) do
    [a, b] = arr |> Enum.map(&(String.to_integer(&1)))
    %{start: a, end: b}
  end

  def is_trivial_overlap?(r, fresh) do
    fresh |> Enum.any?(&(r.start >= &1.start && r.end <= &1.end && r != &1))
  end

  def merge_pairs(ranges) do
    if length(ranges) == 1 do
      [r1] = ranges
      r1
    else
      [r1, r2] = ranges
      %{start: r1.start, end: min(r1.end, r2.start - 1)}
    end
  end
end


[file_name] = System.argv()
{:ok, input} = File.read(file_name)
lines = String.split(input, "\n")

fresh = lines
  |> Stream.filter(&(&1 =~ "-"))
  |> Stream.map(&(&1 |> String.split("-")))
  |> Enum.map(&(Day5.line_to_range(&1)))

fresh2 = fresh
  |> Stream.filter(&(!Day5.is_trivial_overlap?(&1, fresh)))
  |> Enum.sort_by(&(&1.start))

fresh3 = fresh2
  |> Enum.chunk_every(2, 1)
  |> Stream.map(&(Day5.merge_pairs(&1)))
  |> Stream.filter(&(&1.end >= &1.start))
  |> Stream.map(&(&1.end - &1.start + 1))

IO.puts("Answer: " <> Integer.to_string(Enum.sum(fresh3)))

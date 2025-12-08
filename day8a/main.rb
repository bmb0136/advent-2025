if ARGV.length != 1 then
  puts "Missing input file"
  return
end

lines = File.read(ARGV[0]).split("\n")
boxes = lines.map {|l| l.split(",").map { |s| s.to_i }}
$circuits = Hash.new()
$connections = Hash.new()

for i in 0...(boxes.length) do
  $circuits[boxes[i]] = i
  $connections[i] = i
end

def find(a)
  prev = nil
  ptr = $circuits[a]
  while prev != ptr do
    prev = ptr
    ptr = $connections[ptr]

    # Path compression
    $connections[prev] = ptr
  end
  return ptr
end

def connect(a, b)
  ptr_a = find(a)
  ptr_b = find(b)
  if ptr_a != ptr_b then
    $connections[ptr_a] = $connections[ptr_b]
  end
end

distances = Array.new(boxes.length ** 2, 0)
for i in 0...(boxes.length) do
  for j in 0...(boxes.length) do
    if i >= j then
      distances[(i * boxes.length) + j] = Float::INFINITY
    else
      distances[(i * boxes.length) + j] = [Math.sqrt((boxes[i][0] - boxes[j][0]) ** 2 + (boxes[i][1] - boxes[j][1]) ** 2 + (boxes[i][2] - boxes[j][2]) ** 2), i, j]
    end
  end
end

for _, i, j in (distances.sort_by { |d, _, _| d }).first(boxes.length / 2) do
  #puts "Connecting #{i} (#{boxes[i]}) -> #{j} (#{boxes[j]})"
  connect(boxes[i], boxes[j])
  #boxes.each { |box| puts "\t#{box.to_s.ljust(20)}#{find(box)}" }
end


freq = Hash.new 0

boxes.each { |box| freq[find(box)] += 1 }

#puts freq

puts "# of circuits: #{freq.length}"
puts "Answer: #{freq.values.sort.last(3).inject(1) { |acc, x| acc * x }}"

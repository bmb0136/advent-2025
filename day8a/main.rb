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

distances = Array.new(boxes.length) { Array.new(boxes.length, 0) }
for i in 0...(boxes.length) do
  for j in 0...(boxes.length) do
    if i == j then
      distances[i][j] = Float::INFINITY
    else
      distances[i][j] = Math.sqrt((boxes[i][0] - boxes[j][0]) ** 2 + (boxes[i][1] - boxes[j][1]) ** 2 + (boxes[i][2] - boxes[j][2]) ** 2)
    end
  end
end

for _ in 1..(boxes.length / 2) do
  mindex = [-1, -1]
  min_val = Float::INFINITY
  distances.each_with_index do |arr, i|
    arr.each_with_index do |val, j|
      if val < min_val then
        mindex = [i, j]
        min_val = val
      end
    end
  end

  i, j = mindex
  connect(boxes[i], boxes[j])
  distances[i][j] = Float::INFINITY
  distances[j][i] = Float::INFINITY
end

freq = Hash.new 0

boxes.each { |box| freq[find(box)] += 1 }

puts "Answer: #{freq.values.sort.last(3).inject(1) { |acc, x| acc * x }}"

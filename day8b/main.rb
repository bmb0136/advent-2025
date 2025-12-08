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
      distances[(i * boxes.length) + j] = [Float::INFINITY, i, j]
    else
      distances[(i * boxes.length) + j] = [Math.sqrt((boxes[i][0] - boxes[j][0]) ** 2 + (boxes[i][1] - boxes[j][1]) ** 2 + (boxes[i][2] - boxes[j][2]) ** 2), i, j]
    end
  end
end

for _, i, j in (distances.sort_by { |d, _, _| d }).filter { |d, _, _| d != Float::INFINITY } do
  #puts "Connecting #{i} (#{boxes[i]}) -> #{j} (#{boxes[j]})"
  connect(boxes[i], boxes[j])

  c = find(boxes[0])
  done = true
  for k in 1...(boxes.length) do
    if find(boxes[k]) != c then
      done = false
      break
    end
  end

  if done then
    puts "Answer: #{boxes[i][0] * boxes[j][0]}"
    return
  end
end



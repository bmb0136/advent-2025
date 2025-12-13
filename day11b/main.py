import sys

if len(sys.argv) != 2:
    print("Invalid number of arguments; expected input file")
    sys.exit(1)

with open(sys.argv[1]) as f:
    lines: list[list[str]] = [x.strip().split(":") for x in f.readlines() if len(x.strip()) > 0]

edges = {
    key: val.strip().split(" ")
    for key, val in lines
}
edges["out"] =  set()  # pyright: ignore[reportArgumentType]

def count(node: str, target: str, seen: dict[str, int]) -> int:
    if node == target:
        return 1
    if node in seen:
        return seen[node]
    total = 0
    for x in edges[node]:
        total += count(x, target, seen)
    seen[node] = total
    return total

fft_first = count("svr", "fft", {}) * count("fft", "dac", {}) * count("dac", "out", {})
dac_first = count("svr", "dac", {}) * count("dac", "fft", {}) * count("fft", "out", {})

print(f"Answer: {fft_first + dac_first}")

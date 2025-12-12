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

def dfs(node: str, seen: set[str]) -> int:
    if node == "out":
        return 1
    total = 0
    for e in edges[node]:
        if e not in seen:
            seen.add(e)
            total += dfs(e, seen)
            seen.remove(e)
    return total

print(f"Answer: {dfs("you", set())}")


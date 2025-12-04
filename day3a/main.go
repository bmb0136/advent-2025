package main

import (
	"fmt"
	"strings"
	_ "embed"
)

//go:embed input.txt
var input string

func main() {
	banks := strings.Split(input, "\n")

	total := 0

	for _, line := range banks {
		if len(line) == 0 {
			continue
		}

		batteries := make([]int, len(line))
		for i, c := range line {
			batteries[i] = int(c) - 0x30
		}

		max_jolt := 0
		max_val := 0
		for i, d := range batteries {
			if d > max_val && i != len(batteries) - 1 {
				max_val = d
				max_jolt = 0
			} else {
				max_jolt = max(max_jolt, (10 * max_val) + d)
			}
		}

		total += max_jolt
	}

	fmt.Printf("Answer: %d\n", total)
}

package main

import (
	"fmt"
	"strings"
	_ "embed"
)

//go:embed input.txt
var input string

const JOLT_SIZE = 12

type Pair struct {
	Value int
	Index int
}

func main() {
	banks := strings.Split(input, "\n")

	total := int64(0)

	for _, line := range banks {
		if len(line) == 0 {
			continue
		}

		batteries := make([]int, len(line))
		for i, c := range line {
			batteries[i] = int(c) - 0x30
		}

		s := make([]int, 0)
		n := len(batteries) - JOLT_SIZE

		for _, x := range batteries {
			for n > 0 && len(s) > 0 && s[len(s) - 1] < x {
				s = s[0:len(s) - 1]
				n--
			}
			s = append(s, x)
		}

		s = s[0:JOLT_SIZE]

		jolt := int64(0)
		for _, x := range s {
			jolt = (jolt * 10) + int64(x)
		}
		total += jolt
	}

	fmt.Printf("Answer: %d\n", total)
}

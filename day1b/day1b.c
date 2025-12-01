#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc != 2) {
    puts("Usage: day1 <input file>");
    return 1;
  }

  FILE *file = fopen(argv[1], "r");
  if (!file) {
    fprintf(stderr, "Failed to open file %s\n", argv[1]);
    return 1;
  }

  // Position starts at 50
  int position = 50;

  // Number of zeroes
  int answer = 0;

  char line[10];
  while (!feof(file)) {
    if (fgets(line, 10, file) != line) {
      continue;
    }

    char direction = line[0];
    int amount = atoi(line + 1);

    for (size_t i = 0; i < amount; i++) {
      position += direction == 'L' ? -1 : 1;
      if (position < 0) {
        position = 99;
      } else if (position > 99) {
        position = 0;
      }

      if (position == 0) {
        answer++;
      }
    }
  }

  printf("Answer: %d\n", answer);

  fclose(file);
  return 0;
}

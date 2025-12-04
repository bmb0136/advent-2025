import java.io.*;
import java.util.*;

public class Main {
  public static void main(String[] args) {
    if (args.length < 1) {
      System.err.println("Usage: day4a <input file>");
      return;
    }

    var map = new ArrayList<String>();

    try (var freader = new FileReader(args[0]); var reader = new BufferedReader(freader)) {
      String line;
      while ((line = reader.readLine()) != null) {
        line = line.trim();
        if (line.length() == 0) {
          continue;
        }
        map.add(line);
      }
    } catch (IOException e) {
      e.printStackTrace();
    }

    int count = 0;

    for (int row = 0; row < map.size(); row++) {
      for (int col = 0; col < map.get(row).length(); col++) {
        if (map.get(row).charAt(col) != '@') {
          continue;
        }

        int adjacent = 0;
        for (int d = 0; d < 9; d++) {
          // 0 1 2
          // 3 4 5
          // 6 7 8
          if (d == 4) {
            continue;
          }

          int dx = (d % 3) - 1;
          int dy = (d / 3) - 1;

          int r = row + dy;
          int c = col + dx;
          if (r < 0 || c < 0 || r >= map.size() || c >= map.get(r).length()) {
            continue;
          }

          if (map.get(r).charAt(c) == '@') {
            adjacent++;
          }
        }

        if (adjacent < 4) {
          count++;
        }
      }
    }

    System.out.printf("Answer: %d\n", count);
  }
}

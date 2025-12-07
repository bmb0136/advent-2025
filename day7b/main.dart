import "dart:io";

void main(List<String> args) async {
  if (args.length != 1) {
    print("Usage: ./day7 <input>");
    return;
  }

  final lines = (await File(args[0]).readAsString()).trim().split("\n");

  final trachyon = List<int>.filled(lines[0].length, 0);

  trachyon[lines[0].indexOf("S")] = 1;

  for (var row = 1; row < lines.length; row++) {
    for (var i = 0; i < lines[row].length; i++) {
      if (trachyon[i] != 0 && lines[row][i] == '^') {
        trachyon[i + 1] += trachyon[i];
        trachyon[i - 1] += trachyon[i];

        trachyon[i] = 0;
      }
    }
  }

  final answer = trachyon.fold(0, (a, b) => a + b);

  print("Answer: $answer");
}

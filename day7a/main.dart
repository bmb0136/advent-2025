import "dart:io";

void main(List<String> args) async {
  if (args.length != 1) {
    print("Usage: ./day7 <input>");
    return;
  }

  final lines = (await File(args[0]).readAsString()).trim().split("\n");

  final trachyon = List<bool>.filled(lines[0].length, false);

  trachyon[lines[0].indexOf("S")] = true;

  var numSplits = 0;

  for (var row = 1; row < lines.length; row++) {
    for (var i = 0; i < lines[row].length; i++) {
      if (trachyon[i] && lines[row][i] == '^') {
        trachyon[i - 1] = true;
        trachyon[i] = false;
        trachyon[i + 1] = true;
        numSplits++;
      }
    }
  }

  print("Answer: $numSplits");
}

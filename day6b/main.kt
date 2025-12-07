import java.io.File

fun main(args: Array<String>) {
  if (args.size != 1) {
    println("Usage: day6 <input>")
    return
  }

  val lines = File(args[0]).readLines()

  var col = lines[0].length - 1

  val answers = mutableListOf<Long>()

  val temp = mutableListOf<Long>()

  while (col >= 0) {
    var row = 0
    var num = 0L
    while (row < lines.size - 1) {
      if (lines[row][col] != ' ') {
        num = (10 * num) + (lines[row][col] - '0')
      }
      row++
    }
    
    temp.add(num)

    val op = lines[row][col]

    when {
      op == '+' -> {
        answers.add(temp.sum())
        temp.clear()
        col-- // Skip empty column of spaces
      }
      op == '*' -> {
        answers.add(temp.fold(1L) { acc, x -> acc * x })
        temp.clear()
        col-- // Skip empty column of spaces
      }
    }

    col--
  }

  println("Answer: " + answers.sum())
}

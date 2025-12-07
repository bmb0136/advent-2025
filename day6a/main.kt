import java.io.File

fun main(args: Array<String>) {
  if (args.size != 1) {
    println("Usage: day6 <input>")
    return
  }
  val lines = File(args[0]).readLines()
    .map { line -> line.trim().split(" ").filter { s -> s.length > 0 } }

  var problems = (0..<lines[0].size).map { i -> (0..<lines.size).map { j -> lines[j][i] } }

  var nums = problems.map { p -> p.slice(0..<(p.size - 1)).map(String::toLong) }
  var ops = problems.map({ p -> p[p.size - 1] })

  var answers = ops.mapIndexed { i, op -> when(op) {
    "+" -> nums[i].sum()
    "*" -> nums[i].fold(1L) { acc, x -> acc * x }
    else -> throw Exception("Unknown op: " + op)
  }}

  println("Answer: " + answers.sum())
}

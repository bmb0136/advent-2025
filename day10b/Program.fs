open System
open System.IO

type Machine = { Goal: string; Buttons: int[][]; Joltage: int[] }

let parseButton (button: string) =
  button[1..(button.Length - 2)].Split(",", StringSplitOptions.TrimEntries)
    |> Array.map Int32.Parse

let parseLine (line: string): Machine =
  let parts = line.Split(" ", StringSplitOptions.TrimEntries)
  let rawJolt = parts[parts.Length - 1]
  let rawButtons = parts[1..(parts.Length - 2)]
  {
    Goal = parts[0][1..(parts[0].Length - 2)];
    Buttons = rawButtons |> Array.map parseButton;
    Joltage = rawJolt[1..(rawJolt.Length - 2)].Split(",", StringSplitOptions.TrimEntries)
      |> Array.map Int32.Parse
  }

(*
let rec allCombos (maxes: int list): seq<int list> =
  match maxes with
  | [] -> Seq.empty
  | [x] -> seq { 0..x } |> Seq.map List.singleton
  | head :: tail ->
    Seq.allPairs (seq { 0..head }) (allCombos tail) |> Seq.map (fun (h: int, t: int list) -> List.append [h] t)
*)

let getUpperBounds (matrix: int[][]) (jolts: int[]): int[] =
  let minOrZero arr =
    match arr with
    | [||] -> 0
    | _ -> Array.min arr
  let rows = Array.length matrix
  let getFor (variable: int) =
    [| 0..(rows - 1) |]
    |> Array.filter (fun i -> matrix[i][variable] = 1)
    |> Array.map (fun i -> jolts[i])
    |> minOrZero
  let cols = Array.length matrix[0]
  [| 0..(cols - 1) |]
  |> Array.map getFor

let getOrder (matrix: int[][]) (U: int[]): int[] =
  let m = Array.length matrix
  let n = Array.length matrix[0]
  let covg = [|0..(n - 1)|] |> Array.map (fun j -> seq { 0..(m - 1) } |> Seq.sumBy (fun i -> matrix[i][j]))
  [|0..(n - 1)|]
  |> Array.sortBy (fun (j) -> (-covg[j], U[j]))

let branchAndBound (matrix: int[][]) (jolts: int[]): int =
  let numLights = Array.length matrix
  let numButtons = Array.length matrix[0]
  let U = getUpperBounds matrix jolts
  let order = getOrder matrix U
  let updateResiduals (residuals: int[]) (value: int) (index: int): int[] =
    residuals
    |> Array.indexed
    |> Array.map (fun (i, x) -> if matrix[i][index] = 1 then x - value else x)
  let tightenBound (j: int) (r: int[]): int =
    let touched = r |> Array.indexed |> Array.filter (fun (i, x) -> matrix[i][j] = 1) |> Array.map snd
    match touched with
    | [||] -> 0
    | _ -> min U[j] (Array.min touched)
  let rec search (index: int) (residuals: int[]) (currentSum: int): int =
    // If residuals == 0 then solution is valid
    if residuals |> Array.forall (fun x -> x = 0) then currentSum
    // If no more varaibles to set, stop
    else if index >= numButtons then 1000000000
    // Skip variable if zero U or coverage
    else
      let j = order[index]
      if U[j] = 0 || (matrix |> Array.map (fun row -> row[j]) |> Array.sum) = 0 then
        search (index + 1) residuals currentSum
      else
        let ub = tightenBound j residuals
        let findLocalBest (localBest: int) (value: int): int = 
          if currentSum + value >= localBest then localBest
          else
            let newR = updateResiduals residuals value j
            if Array.exists (fun r -> r < 0) newR then localBest
            else min localBest (search (index + 1) newR (currentSum + value))
        seq { 0..ub } |> Seq.fold findLocalBest 1000000000 
  (search 0 jolts 0)

let buildMat (m: Machine): int[][] =
  let onesAt (bs: int[]) = 
    Array.zeroCreate m.Joltage.Length
    |> Array.mapi (fun i _ -> if Array.contains i bs then 1 else 0)
  m.Buttons
  |> Array.map onesAt
  |> Array.transpose

let solve (m: Machine) =
  branchAndBound (buildMat m) m.Joltage

let day10 (file: string) =
  let lines = File.ReadAllLines(file)
  let ms = lines |> Array.map parseLine
  let ans = ms |> Array.Parallel.map solve |> Array.sum
  printf "Answer: %d" ans

[<EntryPoint>]
let main (args: string[]) =
  match args with
  | [|file|] ->
    day10 file
    0
  | [||] ->
    printfn "Missing input"
    1
  | _ ->
    printfn "Too many arguments"
    1

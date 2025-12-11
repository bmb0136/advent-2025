open System
open System.IO
open System.Collections.Immutable

type Machine = { Goal: string; Buttons: int[][]; Joltage: int[] }

type Step = { ButtonIndex: int; Previous: option<Step> }

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


let incCounter (jolts: int[]) (i: int): int[] =
  let arr = jolts |> Array.copy
  Array.set arr i (arr[i] + 1)
  arr

let compareJolts (m: Machine) (jolts: int[]) (func: int * int -> bool): bool =
  (Array.zip jolts m.Joltage)
  |> Array.map func
  |> Array.fold (&&) true

let joltsToKey (jolts: int[]): string =
  jolts
  |> Array.map string
  |> String.concat "," 

let rec findShortestPath (m: Machine): list<int> =
  let seen = System.Collections.Generic.HashSet<string>()
  let rec bfs (queue: list<int[] * option<Step>>): option<Step> =
    match queue with
    | [] -> None
    | (current, prev) :: tail ->
      if compareJolts m current (fun (x, y) -> x = y) then prev
      else 
        let asArr = m.Buttons |> List.ofArray
        let adjacent = asArr |> List.mapi (fun (i: int) (buttons: int[]) -> (i, Array.fold incCounter current buttons)) |> List.filter (fun (_, j) -> compareJolts m j (fun (x, y) -> x <= y))
        let filtered = adjacent |> List.filter (fun (_, j) -> not (j |> joltsToKey |> seen.Contains)) 
        List.fold (fun _ (_, x) -> x |> joltsToKey |> seen.Add) false filtered |> ignore
        let next = filtered |> List.map (fun (i, s) -> (s, Some({ ButtonIndex = i; Previous = prev })))
        bfs (List.append tail next)
  let startState = Array.zeroCreate m.Joltage.Length
  let rec traverse (ptr: option<Step>): seq<int> =
    match ptr with
    | None -> Seq.empty
    | Some(step) -> seq { 
      yield step.ButtonIndex
      yield! (traverse step.Previous)
    }
  bfs (List.singleton (startState, None)) |> traverse |> Seq.rev |> List.ofSeq

let day10 (file: string) =
  let lines = File.ReadAllLines(file)
  let answer = lines |> Array.Parallel.map (parseLine >> findShortestPath >> List.length) |> Array.sum
  printfn $"Answer: {answer}"

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

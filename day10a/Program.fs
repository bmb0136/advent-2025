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

let flipLight (lights: string) (i: int): string =
  let arr = lights.ToCharArray()
  Array.set arr i (if arr[i] = '#' then '.' else '#')
  arr |> String

let rec findShortestPath (m: Machine): list<int> =
  let seen = System.Collections.Generic.HashSet<string>()
  let rec bfs (queue: list<string * option<Step>>): option<Step> =
    match queue with
    | [] -> None
    | (current, prev) :: tail ->
      if current = m.Goal then prev
      else 
        let asArr = m.Buttons |> List.ofArray
        let adjacent = asArr |> List.mapi (fun (i: int) (buttons: int[]) -> (i, Array.fold flipLight current buttons))
        let filtered = adjacent |> List.filter (fun (i: int, s: string) -> not (seen.Contains s))
        List.fold (fun _ (_, x) -> seen.Add(x)) false filtered |> ignore
        let next = filtered |> List.map (fun (i: int, s: string) -> (s, Some({ ButtonIndex = i; Previous = prev })))
        bfs (List.append tail next)
  let startState = String.replicate m.Goal.Length "."
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
  let answer = lines |> Array.map (parseLine >> findShortestPath >> List.length) |> Array.sum
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

import System.Environment
import System.IO
import Data.List.Split (splitOn)
import qualified Data.Text as T
import Data.Bits

doesIntersectPosX [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    py >= (min y1 y2) && py <= (max y1 y2) && px < x1
  else if y1 == y2 then -- horizontal
    py == y1 && px < x1
  else
    error "Should not happen"

doesIntersectNegX [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    py >= (min y1 y2) && py <= (max y1 y2) && px > x1
  else if y1 == y2 then -- horizontal
    py == y1 && px > x1
  else
    error "Should not happen"

doesIntersectPosY [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    px == x1 && py < y1
  else if y1 == y2 then -- horizontal
    px >= (min x1 x2) && px <= (max x1 x2) && py < y1
  else
    error "Should not happen"

doesIntersectNegY [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    px == x1 && py > y1
  else if y1 == y2 then -- horizontal
    px >= (min x1 x2) && px <= (max x1 x2) && py > y1
  else
    error "Should not happen"

doesOverlap [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    py >= (min y1 y2) && py <= (max y1 y2) && px == x1
  else if y1 == y2 then -- horizontal
    px >= (min x1 x2) && px <= (max x1 x2) && py == y1
  else
    error "Should not happen"


isInside :: [[Int]] -> [Int] -> Bool
isInside points p =
  let segments = zip points (tail points ++ [head points])
  in let anyOverlap = any (doesOverlap p) segments
  in let funcs = [doesIntersectPosX, doesIntersectNegX, doesIntersectPosY, doesIntersectNegY]
  in let intersections = map (\f -> length $ filter (f p) segments) funcs
  in let oddX = all odd [intersections !! 0, intersections !! 1]
  in let oddY = all odd [intersections !! 2, intersections !! 3]
  in anyOverlap || oddX || oddY

test points p =
  let segments = zip points (tail points ++ [head points])
  in let funcs = [doesIntersectPosX, doesIntersectNegX, doesIntersectPosY, doesIntersectNegY]
  in map (\f -> length $ filter (f p) segments) funcs

strip = T.unpack . T.strip . T.pack

parseInt :: String -> Int
parseInt s = read s

parseLine :: String -> [Int]
parseLine line = map parseInt (splitOn "," line)

pairs :: [[Int]] -> [[[Int]]]
pairs xs =
  let n = length xs
  in let indices = map (\i -> [div i  n, mod i n]) [0..(n * n) - 1]
  in let deduped = filter (\a -> (a !! 0) < (a !! 1)) indices
  in map (\a -> [xs !! (a !! 0), xs !! (a !! 1)]) deduped

area :: [[Int]] -> Int
area [[x1, y1], [x2, y2]] =
  let w = abs (x1 - x2)
  in let h = abs (y1 - y2)
  in if x1 == x2 || y1 == y2 then 0 else (w + 1) * (h + 1)

rectPoints :: [[Int]] -> [[Int]]
rectPoints [[x1, y1], [x2, y2]] =
  let minX = min x1 x2
  in let maxX = max x1 x2
  in let minY = min y1 y2
  in let maxY = max y1 y2
  in [
    [minX, minY],
    [minX, maxY],
    [maxX, maxY],
    [maxX, minY]
  ]

isValidRect points rect =
  let xs = map (\p -> p !! 0) rect
  in let ys = map (\p -> p !! 1) rect
  in let minX = minimum xs
  in let maxX = maximum xs
  in let minY = minimum ys
  in let maxY = maximum ys
  {-
  in let allPoints = concat $ map (\x -> map (\y -> [x, y]) [minY..maxY]) [minX..maxX]
  in all (isInside points) allPoints
  -}
  in let boundaries = concat [map (\x -> [x, minY]) [minX..maxX], map (\x -> [x, maxY]) [minX..maxX], map (\y -> [minX, y]) [minY..maxY], map (\y -> [maxX, y]) [minY..maxY]]
  in all (isInside points) boundaries

day9 :: [String] -> IO ()
day9 [] = do
  putStrLn "Missing input file"

day9 (a : b : _) = do
  putStrLn "Too many arguments"

day9 [inputPath] = do
  input <- readFile inputPath
  let lines = splitOn "\n" (strip input)
  let points = map parseLine lines
  let rects = map rectPoints (pairs points)
  let validRects = filter (isValidRect points) rects
  let corners = map (\r -> [(r !! 0), (r !! 2)]) validRects
  let answer = if length corners > 0 then maximum (map area corners) else -1
  putStrLn ("Answer: " ++ (show answer))

main :: IO ()
main = do
  args <- getArgs
  day9 args


import System.Environment
import System.IO
import Data.List.Split (splitOn)
import qualified Data.Text as T
import Data.Bits

doesIntersect [px, py] ([x1, y1], [x2, y2]) =
  if x1 == x2 then -- vertical
    py >= (min y1 y2) && py <= (max y1 y2) && px == x1
  else if y1 == y2 then -- horizontal
    px >= (min x1 x2) && px <= (max x1 x2) && py == y1
  else
    error "Should not happen"


isInside :: [[Int]] -> [Int] -> Bool
isInside points p =
  let segments = zip points (tail points ++ [head points])
  in let count = length $ (filter (doesIntersect p) segments)
  in odd count

test points p =
  let segments = zip points (tail points ++ [head points])
  in (filter (doesIntersect p) segments)

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
  in (w + 1) * (h + 1)

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

avgPoint [[x1, y1], [x2, y2]] = [(x1 + x2) `div` 2, (y1 + y2) `div` 2]

isValidRect points rect =
  in all (\p -> isInside points p) (map avgPoint (pairs rect))

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
  print corners
  putStrLn "---------------------------------"
  print rects
  putStrLn "---------------------------------"
  print (test points [9,5])
  print (test points [2,3])
  print (test points [2,5])
  print (test points [9,3])
  let answer = if length corners > 0 then maximum (map area corners) else -1
  putStrLn ("Answer: " ++ (show answer))

main :: IO ()
main = do
  args <- getArgs
  day9 args


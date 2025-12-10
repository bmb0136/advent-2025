import System.Environment
import System.IO
import Data.List.Split (splitOn)
import qualified Data.Text as T
import Data.Bits

getCounts :: [Int] -> ([Int], [Int]) -> [Int]
getCounts p (v1, v2) =
  let [px, py] = p
  in let [x1, y1] = v1
  in let [x2, y2] = v2
  in let minX = min x1 x2
  in let maxX = max x1 x2
  in let minY = min y1 y2
  in let maxY = max y1 y2
  in let xInside = px >= minX && px <= maxX
  in let yInside = py >= minY && py <= maxY
  in let vertical = maxX - minX == 0
  in let horizontal = maxY - minY == 0
  in if px >= minX && px <= maxX && py >= minY && py <= maxY then
    [-69]
  else if vertical && yInside then
    [
      -- nL
      if px > minX then 1 else 0,
      -- nR
      if px > minX then 0 else 1,
      0,
      0
    ]
  else if horizontal && xInside then
    [
      0,
      0,
      -- nA
      if py > minY then 0 else 1,
      -- nU
      if py > minY then 1 else 0
    ]
  else
   [0, 0, 0, 0]

sumCounts :: [[Int]] -> [Int]
sumCounts [] = [0, 0, 0, 0]
sumCounts [x] = x
sumCounts (x:xs) = map (\((a, b)) -> a + b) (zip x (sumCounts xs))

isInside :: [[Int]] -> [Int] -> Bool
isInside points p =
  let segments = zip points (tail points ++ [head points])
  in let counts = map (getCounts p) segments
  in if any (\t -> (t !! 0) == -69) counts then
    True
  else
    let [nL, nR, nA, nU] = sumCounts counts
    in (nL > 0 && nR > 0 && (odd nL) && (odd nR)) || (nA > 0 && nU > 0 && (odd nA) && (odd nU))

test points p =
  let segments = zip points (tail points ++ [head points])
  in let counts = map (getCounts p) segments
  in if any (\t -> (t !! 0) == -69) counts then
    ""
  else
    (show counts) ++ " | " ++ (show (sumCounts counts))

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
    [maxX, minY],
    [maxX, maxY]
  ]

isValidRect points rect =
  all (\p -> isInside points p) rect

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
  let corners = map (\r -> [(r !! 0), (r !! 3)]) validRects
  print corners
  print (isInside points [9,5])
  print (isInside points [2,3])
  print "------"
  print (isInside points [9,3])
  print (test points [9,3])
  print "------"
  print (isInside points [2,5])
  let answer = maximum (map area corners)
  putStrLn ("Answer: " ++ (show answer))

main :: IO ()
main = do
  args <- getArgs
  day9 args


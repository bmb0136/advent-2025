import System.Environment
import System.IO
import Data.List.Split (splitOn)
import qualified Data.Text as T

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

day9 :: [String] -> IO ()
day9 [] = do
  putStrLn "Missing input file"

day9 (a : b : _) = do
  putStrLn "Too many arguments"

day9 [inputPath] = do
  input <- readFile inputPath
  let lines = splitOn "\n" (strip input)
  let nums = map parseLine lines
  let answer = maximum (map area (pairs nums))
  putStrLn ("Answer: " ++ show answer)


main :: IO ()
main = do
  args <- getArgs
  day9 args


module GameOfLife.Core where

--------------------------------------------------------------------------------
import Control.Monad.State
import Data.List


--------------------------------------------------------------------------------
type Cell = (Int, Int)
type Board = [Cell]


--------------------------------------------------------------------------------
isAlive :: Board -> Cell -> Bool
isAlive board cell = cell `elem` board


--------------------------------------------------------------------------------
neighbors :: Cell -> [Cell]
neighbors (x,y) = [(x',y') | x' <- [x-1..x+1], y' <- [y-1..y+1], (x',y') /= (x,y)]


--------------------------------------------------------------------------------
aliveNeighborCount :: Board -> Cell -> Int
aliveNeighborCount board = length . filter (isAlive board) . neighbors 


--------------------------------------------------------------------------------
liveOrDie :: Board -> Cell -> Bool
liveOrDie board cell 
    | alive && ns == 2     = True
    | alive && ns == 3     = True
    | not alive && ns == 3 = True
    | otherwise            = False 
    where 
        alive = isAlive board cell 
        ns    = aliveNeighborCount board cell
        

--------------------------------------------------------------------------------
generation :: State Board Board
generation = do 
    board <- get
    let deadNeighbors = nub $ filter (not . isAlive board) $ concatMap neighbors board
        livingSurvivors = filter (liveOrDie board) board
        newBirths = filter (liveOrDie board) deadNeighbors
        board' = livingSurvivors ++ newBirths
    put board'
    return board 


--------------------------------------------------------------------------------
generations :: State Board [Board]
generations = do 
    board <- generation 
    future <- generations
    return (board : future)

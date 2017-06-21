module GameOfHaskell.Patterns
    ( translatePattern 
    , block 
    , blinker
    , toad
    , beacon
    , pulsar
    , pentadecathlon
    , glider
    , rPentomino
    , dieHard
    , acorn
    ) where
        

import GameOfHaskell.Core 

translatePattern :: Cell -> [Cell] -> [Cell]
translatePattern (x,y) = map (\(a,b) -> (a+x, b+y))

-- | Still
------------------------------------------
block :: [Cell]
block = [(0,0),(0,1),(1,0),(1,1)]


-- | Oscillators
------------------------------------------
blinker :: [Cell]
blinker = [(0,1),(0,2),(0,3)]

toad :: [Cell]
toad = []

beacon :: [Cell]
beacon = []

pulsar :: [Cell]
pulsar = []

pentadecathlon :: [Cell]
pentadecathlon = []

-- | Spaceships
------------------------------------------
glider :: [Cell]
glider = [(0,1),(1,2),(2,0),(2,1),(2,2)] 

-- | Methuselahs
------------------------------------------
rPentomino :: [Cell]
rPentomino = [(0,1),(1,0),(1,1),(1,2),(2,0)]

dieHard :: [Cell]
dieHard = [(0,1),(1,1),(1,2),(6,0),(5,2),(6,2),(7,2)] 

acorn :: [Cell]
acorn = [(0,2),(1,0),(1,2),(3,1),(4,2),(5,2),(6,2)]
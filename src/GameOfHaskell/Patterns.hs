module GameOfHaskell.Patterns
    ( translatePattern 
    , blinker
    , toad
    , beacon
    , pulsar
    , pentadecathlon
    , glider
    ) where
        

import GameOfHaskell.Core 

translatePattern :: Cell -> [Cell] -> [Cell]
translatePattern (x,y) = map (\(a,b) -> (a+x, b+y))

-- | Still
------------------------------------------

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
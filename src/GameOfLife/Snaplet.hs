{-# LANGUAGE OverloadedStrings #-}

module GameOfLife.Snaplet where

import Control.Monad.State
import GameOfLife.Core
import Snap.Snaplet

-- data GameOfLife = GameOfLife 
--     { _generations :: [Board] }

-- gameInit :: SnapletInit b GameOfLife
-- gameInit =  makeSnaplet "gameOfLife" "Game Of Life" Nothing $ do
--     let generations' = evalState generations [(1,0),(2,0),(3,0)]
--     return GameOfLife generations' 
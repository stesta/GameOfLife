{-# LANGUAGE TemplateHaskell #-}

module Application where

import GameOfLife.Snaplet
import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.Heist

data App = App
    { _heist :: Snaplet (Heist App) }

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist

type AppHandler = Handler App App
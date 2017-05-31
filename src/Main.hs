module Main where

import Site
import Snap.Snaplet
import Snap.Http.Server

main :: IO ()
main = serveSnaplet defaultConfig siteInit

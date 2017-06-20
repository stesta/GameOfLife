{-# LANGUAGE OverloadedStrings #-}
module Site where


--------------------------------------------------------------------------------
import           Application
import           Control.Monad           (forever)
import           Control.Monad.State
import           Data.Aeson
import qualified Data.Text               as T
import           GameOfHaskell.Core         
import           GameOfHaskell.Patterns     
import qualified Network.WebSockets      as WS
import qualified Network.WebSockets.Snap as WS
import           Snap.Snaplet
import           Snap.Snaplet.Heist      
import           Snap.Util.FileServe 


--------------------------------------------------------------------------------
siteInit :: SnapletInit App App
siteInit = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes [ ("/", render "index.tpl")
              , ("gameoflife", gameOfLife)
              , ("",  serveDirectory "assets")
              ]
    return $ App h


-- | Game of Life handler
--------------------------------------------------------------------------------
gameOfLife :: AppHandler () 
gameOfLife = WS.runWebSocketsSnap gameOfLifeApp 


-- | Game of Life server app
-- set an initial board state and continually listen for
-- the next msg::Int (corresponds to a board generation #) 
-- sends back to the client the requested board via JSON array
--------------------------------------------------------------------------------
gameOfLifeApp :: WS.ServerApp
gameOfLifeApp pending = do 
    conn <- WS.acceptRequest pending
    let game = evalState generations $ (translatePattern (10,1) glider) ++ (blinker)
    forever $ do
        msg <- WS.receiveData conn
        let g = read $ T.unpack msg :: Int
        WS.sendTextData conn $ encode $ game!!g

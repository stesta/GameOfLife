{-# LANGUAGE OverloadedStrings #-}
module Site where


--------------------------------------------------------------------------------
import           Application
import           Control.Monad           (forever)
import           Control.Monad.State
import           Data.List
import qualified Data.Text               as T
import           GameOfLife.Core         
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


-- | Game Of Life
--------------------------------------------------------------------------------
gameOfLife :: AppHandler () 
gameOfLife = WS.runWebSocketsSnap gameOfLifeApp 


--------------------------------------------------------------------------------
gameOfLifeApp :: WS.ServerApp
gameOfLifeApp pending = do 
    conn <- WS.acceptRequest pending
    let game = evalState generations [(1,0),(2,0),(3,0)]
    forever $ do
        msg <- WS.receiveData conn
        let g = read $ T.unpack msg :: Int
            response = boardToJsonArray $ game!!g
        WS.sendTextData conn $ "[" `T.append` response `T.append` "]\n"


--------------------------------------------------------------------------------
boardToJsonArray :: Board -> T.Text
boardToJsonArray xs =
    T.pack $ intercalate "," $ map fmt xs 
    where
        fmt (a,b) = "[" ++ show a ++ "," ++ show b ++ "]"

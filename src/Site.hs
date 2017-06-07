{-# LANGUAGE OverloadedStrings #-}
module Site where


--------------------------------------------------------------------------------
import           Application
import           Control.Concurrent      (forkIO)
import           Control.Exception       (finally)
import           Control.Monad           (forever, unless)
import           Control.Monad.State
import qualified Data.ByteString         as B
import qualified Data.ByteString.Char8   as BC
import           Data.List
import qualified Data.Text               as T
import           GameOfLife.Core         
import qualified Network.WebSockets      as WS
import qualified Network.WebSockets.Snap as WS
import qualified Snap.Core               as Snap
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import qualified Snap.Util.FileServe     as Snap
import qualified System.IO               as IO
import qualified System.Process          as Process


--------------------------------------------------------------------------------
siteInit :: SnapletInit App App
siteInit = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes [ ("/", render "index.tpl")
              , ("test", render "test.tpl")
              , ("console", render "console.tpl")
              , ("console/:shell", console)
              , ("gameofLife", render "gameOfLife.tpl")
              , ("gameOfLife/start", gameOfLife)
              , ("",  Snap.serveDirectory "assets")
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


-- | Console  
--------------------------------------------------------------------------------
console :: AppHandler ()
console = do
    Just shell <- Snap.getParam "shell"
    WS.runWebSocketsSnap $ consoleApp $ BC.unpack shell


--------------------------------------------------------------------------------
consoleApp :: String -> WS.ServerApp
consoleApp shell pending = do
    (stdin, stdout, stderr, phandle) <- Process.runInteractiveCommand shell
    conn                             <- WS.acceptRequest pending

    _ <- forkIO $ copyHandleToConn stdout conn
    _ <- forkIO $ copyHandleToConn stderr conn
    _ <- forkIO $ copyConnToHandle conn stdin

    exitCode <- Process.waitForProcess phandle
    putStrLn $ "consoleApp ended: " ++ show exitCode


--------------------------------------------------------------------------------
copyHandleToConn :: IO.Handle -> WS.Connection -> IO ()
copyHandleToConn h c = do
    bs <- B.hGetSome h 1024
    unless (B.null bs) $ do
        putStrLn $ "> " ++ show bs
        WS.sendTextData c bs
        copyHandleToConn h c


--------------------------------------------------------------------------------
copyConnToHandle :: WS.Connection -> IO.Handle -> IO ()
copyConnToHandle c h = flip finally (IO.hClose h) $ forever $ do
    bs <- WS.receiveData c
    putStrLn $ "< " ++ show bs
    B.hPutStr h bs
    IO.hFlush h
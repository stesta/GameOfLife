{-# LANGUAGE OverloadedStrings #-}
module Site where


--------------------------------------------------------------------------------
import           Control.Concurrent      (forkIO)
import           Control.Exception       (finally)
import           Control.Monad           (forever, unless)
import qualified Data.ByteString         as B
import qualified Data.ByteString.Char8   as BC
import qualified Network.WebSockets      as WS
import qualified Network.WebSockets.Snap as WS
import           Snap.Core               (Snap)
import qualified Snap.Core               as Snap
import qualified Snap.Http.Server        as Snap
import qualified Snap.Util.FileServe     as Snap
import qualified System.IO               as IO
import qualified System.Process          as Process
import Application
import Data.ByteString (ByteString)
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe


--------------------------------------------------------------------------------
siteInit :: SnapletInit App App
siteInit = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes [ ("/", render "index.tpl")
              , ("test", render "text.tpl")
              , ("console", render "console.tpl")
              , ("console/:shell", console)
              , ("",  serveDirectory "assets")
              ]
    return $ App h


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
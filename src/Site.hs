{-# LANGUAGE OverloadedStrings #-}

module Site where

import Application
import Data.ByteString (ByteString)
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe

routes :: [(ByteString, Handler App App ())]
routes = [ ("/", render "index.tpl")
         , ("",  serveDirectory "assets")
         ]

siteInit :: SnapletInit App App
siteInit = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h
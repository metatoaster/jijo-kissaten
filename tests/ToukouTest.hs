{-# LANGUAGE OverloadedStrings #-}
module ToukouTest
    ( toukouSpecs
    ) where

import TestImport
import qualified Data.List as L

toukouSpecs :: Spec
toukouSpecs =
    ydescribe "Testing posts." $ do

        yit "List all posts when new" $ do
            get ToukouListR
            statusIs 200
            htmlAllContain "#main p" "There is nothing here at this moment."

        yit "Submit a new post" $ do
            get ToukouAddR
            statusIs 200

            request $ do
                setMethod "POST"
                setUrl ToukouAddR
                addNonce
                byLabel "Path" "http://img.example.com/test.png"

            toukous <- runDB $ selectList ([] :: [Filter Toukou]) []
            assertEqual "toukou added" 1 $ L.length toukous

            statusIs 302

        yit "Get a post" $ do
            get $ ToukouR $ Key $ PersistInt64 1
            statusIs 200
            htmlAllContain "h1#toukou_id" "post:1"
            htmlAllContain "#main dl dd" "http://img.example.com/test.png"

        yit "List posts after some are added." $ do
            get ToukouListR
            statusIs 200
            htmlCount "#main ul li" 1

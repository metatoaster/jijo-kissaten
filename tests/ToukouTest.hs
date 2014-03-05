{-# LANGUAGE OverloadedStrings #-}
module ToukouTest
    ( toukouSpecs
    ) where

import TestImport
import qualified Data.List as L

toukouSpecs :: Spec
toukouSpecs =
    ydescribe "Testing submissions." $ do

        yit "List all submissions" $ do
            get ToukouListR
            statusIs 200
            printBody
            htmlAllContain "#main p" "There are no toukous defined"

        yit "Post a submission" $ do
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

        yit "Get a submission" $ do
            get $ ToukouR $ Key $ PersistInt64 1
            statusIs 200
            htmlAllContain "h1#toukou_id" "http://img.example.com/test.png"

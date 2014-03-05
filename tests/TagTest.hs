{-# LANGUAGE OverloadedStrings #-}
module TagTest
    ( tagSpecs
    ) where

import TestImport
import qualified Data.List as L

import Data.Text

tagSpecs :: Spec
tagSpecs =
    ydescribe "Testing tags." $ do

        yit "Default tag list" $ do
            get TagListR
            statusIs 200
            printBody
            htmlAllContain "#main p" "There are no tags defined"

        yit "Post a tag" $ do
            get TagAddR
            statusIs 200

            request $ do
                setMethod "POST"
                setUrl TagAddR
                addNonce
                byLabel "Name" "a_tag"
                byLabel "Type" "default"

            tags <- runDB $ selectList ([] :: [Filter Tag]) []
            assertEqual "tag added" 1 $ L.length tags

            statusIs 302

        yit "Get a tag" $ do
            get $ TagR $ Key $ PersistInt64 1
            statusIs 200
            htmlAllContain "h1#tag_id" "a_tag"

        yit "Get a tag via path" $ do
            get ("/tag/info/1" :: Text)
            statusIs 200
            htmlAllContain "h1#tag_id" "a_tag"

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
            htmlAllContain "#main p" "There are no tags defined"
            htmlCount "#main ul li" 0

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

        yit "Tag list with a tag" $ do
            get TagListR
            statusIs 200
            htmlCount "#main ul li" 1

        yit "Post a duplicate tag" $ do
            get TagAddR
            request $ do
                setMethod "POST"
                setUrl TagAddR
                addNonce
                byLabel "Name" "a tag"
                byLabel "Type" "default"

            statusIs 200
            -- autocorrected to a_tag
            htmlAllContain "#hident2" "a_tag"

            tags <- runDB $ selectList ([] :: [Filter Tag]) []
            assertEqual "duplicate not added" 1 $ L.length tags

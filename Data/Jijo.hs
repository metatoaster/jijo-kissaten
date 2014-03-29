{-# LANGUAGE TemplateHaskell #-}

module Data.Jijo
    ( toTagText
    , fromTagText
    , TagText
    ) where

import Prelude
import qualified Data.Text as T
import Database.Persist.TH

newtype TagText = TagText T.Text deriving (Eq, Show, Read)
derivePersistField "TagText"

toTagText :: T.Text -> TagText
toTagText x = TagText $ T.intercalate (T.pack "_") $ T.words x

fromTagText :: TagText -> T.Text
fromTagText (TagText x) = x

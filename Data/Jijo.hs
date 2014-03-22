module Data.Jijo
    ( toTag
    , fromTag
    ) where

import Data.Char (isSpace)

toUnderscore :: Char -> Char
toUnderscore c
    | isSpace c = '_'
    | otherwise = c

newtype Tag = Tag String deriving (Eq, Show)

toTag :: String -> Tag
toTag x = Tag $ map toUnderscore x

fromTag :: Tag -> String
fromTag (Tag x) = x

{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TypeFamilies          #-}

module Handler.Tag
    ( getTagListR
    , getTagR
    , getTagAddR
    , postTagAddR
    )
where

import Import

import Data.Text as T (pack)
import Data.Jijo (toTagText, fromTagText, TagText)

tagtextField :: Monad m => RenderMessage (HandlerSite m) FormMessage => Field m TagText
tagtextField = Field
    { fieldParse = parseHelper $ Right . toTagText
    , fieldView = \theId name attrs val isReq ->
        [whamlet|
$newline never
<input id="#{theId}" name="#{name}" *{attrs} type="text" :isReq:required value="#{showVal val}">
|]
    , fieldEnctype = UrlEncoded
    }
  where showVal = either id (T.pack . show)


entryForm :: Form Tag
entryForm = renderDivs $ Tag
    <$> areq tagtextField "Name" Nothing
    <*> areq textField "Type" Nothing

getTagListR :: Handler Html
getTagListR = do
    tags <- runDB $ selectList [] [Asc TagName]
    defaultLayout $ do
        $(widgetFile "tag-list")

getTagAddR :: Handler Html
getTagAddR = do
    (tagWidget, enctype) <- generateFormPost entryForm
    defaultLayout $ do
        $(widgetFile "tag-add")

postTagAddR :: Handler Html
postTagAddR = do
    ((res, tagWidget), enctype) <- runFormPost entryForm
    case res of
        FormSuccess tag -> do
            tagId <- runDB $ insert tag
            setMessage $ toHtml $ (fromTagText $ tagName tag) <> " created"
            redirect $ TagR tagId
        _ -> defaultLayout $ do
            setTitle "Please correct the errors and try again"
            $(widgetFile "tag-add")

getTagR :: TagId -> Handler Html
getTagR tagId = do
    tag <- runDB $ get404 tagId
    defaultLayout $ do
        setTitle $ toHtml $ fromTagText $ tagName tag
        $(widgetFile "tag")

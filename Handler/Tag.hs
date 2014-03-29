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
  where showVal = either id (fromTagText)


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
            tagId <- runDB $ insertUnique tag
            case tagId of
                Just tagId' -> do
                    setMessage $ toHtml $ (fromTagText $ tagName tag) <> " created"
                    redirect $ TagR tagId'
                Nothing -> defaultLayout $ do
                    setTitle "Tag name already exist, please correct."
                    -- TODO add the error message at the relevant field.
                    $(widgetFile "tag-add")
        _ -> defaultLayout $ do
            setTitle "Please correct the errors and try again"
            $(widgetFile "tag-add")

getTagR :: TagId -> Handler Html
getTagR tagId = do
    tag <- runDB $ get404 tagId
    defaultLayout $ do
        setTitle $ toHtml $ fromTagText $ tagName tag
        $(widgetFile "tag")

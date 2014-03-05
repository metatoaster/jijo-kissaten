module Handler.Tag
    ( getTagsR
    , getTagR
    , getTagAddR
    , postTagAddR
    )
where

import Import


entryForm :: Form Tag
entryForm = renderDivs $ Tag
    <$> areq textField "Name" Nothing
    <*> areq textField "Type" Nothing

getTagsR :: Handler Html
getTagsR = do
    tags <- runDB $ selectList [] [Asc TagName]
    defaultLayout $ do
        $(widgetFile "tags")

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
            setMessage $ toHtml $ (tagName tag) <> " created"
            redirect $ TagR tagId
        _ -> defaultLayout $ do
            setTitle "Please correct the errors and try again"
            $(widgetFile "tag-add")

getTagR :: TagId -> Handler Html
getTagR tagId = do
    tag <- runDB $ get404 tagId
    defaultLayout $ do
        setTitle $ toHtml $ tagName tag
        $(widgetFile "tag")

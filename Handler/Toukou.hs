module Handler.Toukou
    ( getToukouListR
    , getToukouR
    , getToukouAddR
    , postToukouAddR
    )
where

import Import

toukouAddForm :: Form Toukou
toukouAddForm = renderDivs $ Toukou
    <$> areq textField "Path" Nothing

-- listing

getToukouListR :: Handler Html
getToukouListR = do
    toukous <- runDB $ selectList ([] :: [Filter Toukou]) []
    defaultLayout $ do
        $(widgetFile "toukou-list")

-- singular submission view

getToukouR :: ToukouId -> Handler Html
getToukouR toukouId = do
    toukou <- runDB $ get404 toukouId
    defaultLayout $ do
        setTitle $ toHtml $ toukouPath toukou
        $(widgetFile "toukou")

-- low level add form

getToukouAddR :: Handler Html
getToukouAddR = do
    (toukouWidget, enctype) <- generateFormPost toukouAddForm
    defaultLayout $ do
        $(widgetFile "toukou-add")

postToukouAddR :: Handler Html
postToukouAddR = do
    ((res, toukouWidget), enctype) <- runFormPost toukouAddForm
    case res of
        FormSuccess toukou -> do
            toukouId <- runDB $ insert toukou
            setMessage $ toHtml $ (toukouPath toukou) <> " created"
            redirect $ ToukouR toukouId
        _ -> defaultLayout $ do
            setTitle "Please correct the errors and try again"
            $(widgetFile "toukou-add")

-- higher level generic upload.

getToukouUploadR :: Handler Html
getToukouUploadR = do
    error "Not yet implemented: getToukouUploadR"

postToukouUploadR :: Handler Html
postToukouUploadR = do
    error "Not yet implemented: postToukouUploadR"

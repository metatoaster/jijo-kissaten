module Handler.Toukou where

import Import

toukouAddForm :: Form Toukou
toukouAddForm = renderDivs $ Toukou
    <$> areq textField "Path" Nothing

-- listing

getToukouListR :: Handler Html
getToukouListR = do
    error "Not yet implemented: getToukousR"

-- singular submission

getToukouR :: ToukouId -> Handler Html
getToukouR = do
    error "Not yet implemented: getToukouR"

-- low level add form

getToukouAddR :: Handler Html
getToukouAddR = do
    error "Not yet implemented: getToukouAddR"

postToukouAddR :: Handler Html
postToukouAddR = do
    error "Not yet implemented: postToukouAddR"

-- higher level generic upload.

getToukouUploadR :: Handler Html
getToukouUploadR = do
    error "Not yet implemented: getToukouUploadR"

postToukouUploadR :: Handler Html
postToukouUploadR = do
    error "Not yet implemented: postToukouUploadR"

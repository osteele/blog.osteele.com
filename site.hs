#!/usr/bin/env runhaskell

--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, mconcat)
import           Hakyll
import           SiteUtils


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    -- Static files
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    --match (fromList ["about.rst", "contact.markdown"]) $ do
    --    route   $ setExtension "html"
    --    compile $ pandocCompiler
    --        >>= loadAndApplyTemplate "templates/default.html" defaultContext
    --        >>= relativizeUrls

    match "posts/*" $ do
        route $ rewritePermalinkDate `composeRoutes` setExtension "html"
        compile $ pandocCompiler
            >>= replaceUrlPrefixes "/images/" "http://assets.osteele.com/images/"
            >>= replaceUrlPrefixes "/movies/" "http://assets.osteele.com/movies/"
            >>= replaceUrlPrefixes "/music/" "http://assets.osteele.com/music/"
            >>= setRelativeUrlBases "http://osteele.com"
            >>= replaceUrlPrefixes "http://osteele.com/archive/" "/posts/"
            >>= replaceUrlPrefixes "http://osteele.com/archives/" "/posts/"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= removeExtensionsFromLocalUrls ".html"
                >>= relativizeUrls

    match "index.html" $ do
        route $ setExtension "html"
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    -- Render RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            loadAllSnapshots "posts/*" "content"
                >>= fmap (take 10) . recentFirst
                >>= renderRss (feedConfiguration "All posts") feedCtx

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
-- Source: https://github.com/jaspervdj/jaspervdj
feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

--------------------------------------------------------------------------------
feedConfiguration :: String -> FeedConfiguration
feedConfiguration title = FeedConfiguration
    { feedTitle       = "Oliver Steele - " ++ title
    , feedDescription = "Oliver Steele’s historical blog"
    , feedAuthorName  = "Oliver Steele"
    , feedAuthorEmail = "steele@osteele.com"
    , feedRoot        = "http://blog.osteele.com"
    }

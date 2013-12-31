#!/usr/bin/env runhaskell

--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>), mappend, mconcat)
import           Hakyll
import           SiteUtils

--import Data.Monoid (, mconcat, mempty)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    -- Buid Tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Copy static files
    match "files/**" $ do
        route $ gsubRoute "files/" (const "") `composeRoutes` gsubRoute "htaccess" (const ".htaccess")
        compile copyFileCompiler

    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Render posts
    match "posts/*" $ do
        route $ rewritePermalinkDate `composeRoutes` setExtension "html"
        compile $ pandocCompiler
            >>= replaceUrlPrefixes "/images/" "http://assets.osteele.com/images/"
            >>= replaceUrlPrefixes "/movies/" "http://assets.osteele.com/movies/"
            >>= replaceUrlPrefixes "/music/" "http://assets.osteele.com/music/"
            >>= setRelativeUrlBases "http://osteele.com"
            >>= replaceUrlPrefixes "http://osteele.com/archive/" "/posts/"
            >>= replaceUrlPrefixes "http://osteele.com/archives/" "/posts/"
            >>= saveSnapshot "content" -- for RSS
            >>= loadAndApplyTemplate "templates/post.html"    (tagsField "tags" tags `mappend` postCtx)
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= removeExtensionsFromLocalUrls ".html"
            >>= relativizeUrls

    --create ["archive/index.html"] $ do
    --    route idRoute
    --    compile $ do
    --        posts <- recentFirst =<< loadAll "posts/*"
    --        let archiveCtx =
    --                listField "posts" postCtx (return posts) `mappend`
    --                constField "title" "Archives"            `mappend`
    --                defaultContext

    --        makeItem ""
    --            >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
    --            >>= loadAndApplyTemplate "templates/default.html" archiveCtx
    --            >>= removeExtensionsFromLocalUrls ".html"
    --            >>= relativizeUrls

     -- Create one page per tag
    tagsRules tags $ \tag pattern -> do
        let title = "Tag: " ++ tag
        route $ downcaseRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title <>
                        tagsField "tags" tags <>
                        listField "posts" postCtx (return posts) <>
                        siteCtx
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    -- Render index
    match "index.html" $ do
        route $ setExtension "html"
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    siteCtx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= removeExtensionsFromLocalUrls ".html"
                >>= relativizeUrls

    -- Render RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            loadAllSnapshots "posts/*" "content"
                >>= fmap (take 10) . recentFirst
                >>= renderRss (feedConfiguration "All posts") feedCtx

    match "templates/*" $ compile templateCompiler


-- ==========================
-- Options and Configurations
-- ==========================
config :: Configuration
config = defaultConfiguration {
    deployCommand  = "rsync -aiz --delete _site/ osteele.com:/var/www/blog.osteele.com"
}


-- =================
-- Context functions
-- =================
siteCtx :: Context String
siteCtx =
    constField "author" "Oliver Steele"              `mappend`
    constField "feedTitle" "Oliver Steele’s Blog"    `mappend`
    constField "copyright-range" "2003 &ndash; 2013" `mappend`
    defaultContext

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y"                     `mappend`
    siteCtx

feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , siteCtx
    ]

feedConfiguration :: String -> FeedConfiguration
feedConfiguration title = FeedConfiguration
    { feedTitle       = "Oliver Steele - " ++ title
    , feedDescription = "Oliver Steele’s Blog"
    , feedAuthorName  = "Oliver Steele"
    , feedAuthorEmail = "steele@osteele.com"
    , feedRoot        = "http://blog.osteele.com"
    }

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
    -- Copy static files
    match "files/**" $ do
        route $ gsubRoute "files/" (const "")
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
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
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

    -- Buid Tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

     -- Create one page per tag
    tagsRules tags $ \tag pattern -> do
        let title = "Tag: " ++ tag
        route idRoute
        compile $ do
            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" title `mappend`
                            constField "body" list `mappend`
                            siteCtx)
                >>= loadAndApplyTemplate "templates/default.html"
                        (constField "title" title `mappend`
                            siteCtx)
                >>= removeExtensionsFromLocalUrls ".html"
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
-- Tags
-- ==========================

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/post-item.html"
    posts'      <- loadAll pattern
    posts       <- preprocess' posts'
    applyTemplateList postItemTpl postCtx posts


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
    constField "copyright-range" "2003 &mdash; 2013" `mappend`
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

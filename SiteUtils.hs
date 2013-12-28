module SiteUtils
    ( removeExtensionsFromLocalUrls
    , replaceUrlPrefixes
    , setRelativeUrlBases
    ) where

import           Data.List            (isPrefixOf, isSuffixOf, stripPrefix)
import           Data.Maybe           (fromMaybe, mapMaybe)


--------------------------------------------------------------------------------
import           Hakyll.Core.Compiler
import           Hakyll.Core.Item
import           Hakyll.Web.Html
import           Hakyll.Web.Html.RelativizeUrls


--------------------------------------------------------------------------------
setRelativeUrlBases :: String  -- ^ Prepend relative URLs by this prefix
                    -> Item String -> Compiler (Item String)
setRelativeUrlBases prefix item = do
  route <- getRoute $ itemIdentifier item
  return $ case route of
      Nothing -> item
      Just r  -> fmap (relativizeUrlsWith $ prefix) item


----------------------------------------------------------------------------------
removeExtensionsFromLocalUrls :: String
                                 -> Item String -> Compiler (Item String)
removeExtensionsFromLocalUrls suffix item = do
  return $ fmap (withUrls removeLocalExtension) item
  where
    isLocalUrl url = "/" `isPrefixOf` url || "." `isPrefixOf` url
    removeLocalExtension url = if isLocalUrl url then fromMaybe url $ stripSuffix suffix url else url


----------------------------------------------------------------------------------
replaceUrlPrefixes :: String  -- ^ Match URLs beginning with this prefix
                   -> String  -- ^ Prepend matched URLs by this prefix
                   -> Item String -> Compiler (Item String)
replaceUrlPrefixes matchPrefix replacementPrefix item = do
  return $ fmap (replaceMatchingUrlsBy matchPrefix replacementPrefix) item


----------------------------------------------------------------------------------
replaceMatchingUrlsBy :: String  -- ^ Path to the site root
                      -> String  -- ^ Prepend matched URLs by this prefix
                      -> String  -- ^ HTML to relativize
                      -> String  -- ^ Resulting HTML
replaceMatchingUrlsBy matchPrefix replacementPrefix = withUrls rel
  where
    rel url   = replacePrefix matchPrefix replacementPrefix url


----------------------------------------------------------------------------------
replacePrefix :: String
              -> String
              -> String
              -> String
replacePrefix prefix replacement s =
  case stripPrefix prefix s of
    Nothing -> s
    Just s  -> replacement ++ s


----------------------------------------------------------------------------------
stripSuffix :: Eq a => [a] -> [a] -> Maybe [a]
stripSuffix suffix = fmap reverse . stripPrefix (reverse suffix) . reverse

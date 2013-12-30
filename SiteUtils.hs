module SiteUtils
    ( removeExtensionsFromLocalUrls
    , rewritePermalinkDate
    , replaceUrlPrefixes
    , setRelativeUrlBases
    ) where

import Control.Exception (assert)
import Data.List         (isPrefixOf, stripPrefix)
import Data.Maybe        (fromMaybe)
import Text.Regex.Posix  ((=~))
import Hakyll

--------------------------------------------------------------------------------
setRelativeUrlBases :: String  -- ^ Prepend relative URLs by this prefix
                    -> Item String -> Compiler (Item String)
setRelativeUrlBases prefix item = do
  return $ fmap (relativizeUrlsWith $ prefix) item


----------------------------------------------------------------------------------
rewritePermalinkDate :: Routes
rewritePermalinkDate = customRoute $ fn . toFilePath
  where
    fn path = case path =~ "/([0-9]{4})-([0-9]{2})-([0-9]{2})-([^/]+)$" :: (String, String, String, [String]) of
      (_, _, _, [])                          -> path
      (before, _, _, [yyyy, mm, _dd, title]) -> before ++ "/" ++ yyyy ++ "/" ++ mm ++ "/" ++ title
      _                                      -> assert False (error "unreachable case alternative")

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
    Nothing        -> s
    Just remainder -> replacement ++ remainder


----------------------------------------------------------------------------------
stripSuffix :: Eq a => [a] -> [a] -> Maybe [a]
stripSuffix suffix = fmap reverse . stripPrefix (reverse suffix) . reverse

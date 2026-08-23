{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Char (isSpace)
import Data.List (isPrefixOf, sortBy)
import Data.Maybe (fromMaybe, mapMaybe)
import Data.Ord (comparing, Down (..))
import Data.Time.Format (defaultTimeLocale, formatTime, parseTimeM)
import Data.Time.LocalTime (LocalTime)
import Hakyll hiding (trim)
import System.FilePath (takeBaseName, takeDirectory, takeFileName, (</>))

main :: IO ()
main = hakyll $ do
    tags <- buildTags postsPattern tagRoute

    -- Copy files that should be served exactly as they appear in source.
    match "assets/**" $ do
        route idRoute
        compile copyFileCompiler

    -- Expose raw logs as a plain-text file at /logs.txt.
    match "content/logs.txt" $ do
        route $ constRoute "logs.txt"
        compile getResourceBody

    -- Journey source is compiled so /journey/ can depend on it.
    match "content/journey.txt" $ compile getResourceBody

    -- Register every reusable template used by the page compilers below.
    match "templates/*" $ compile templateBodyCompiler

    -- Turn each Markdown post into a page and retain rendered content for teasers.
    match postsPattern $ do
        route postRoute
        compile $ renderPost tags

    -- Compile the standalone Markdown pages at the site root.
    match "content/*.md" $ do
        route pageRoute
        compile $ renderPage pageContext

    -- Directory pages: /donate/, /domains/, ...
    match "content/pages/*.md" $ do
        route dirPageRoute
        compile $ renderPage pageContext

    -- Create a tag archive for every tag declared in post front matter.
    tagsRules tags $ \tag pattern -> do
        route idRoute
        compile $ do
            posts <- loadRecentPosts pattern
            let context =
                    constField "title" ("posts tagged \"" <> tag <> "\"")
                        <> listField "posts" (postContext tags) (pure posts)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Build the home page with the three most recent posts + recent logs.
    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- take 3 <$> loadRecentPosts postsPattern
            logPairs <- loadLogPairs
            let recentLogs = take 8 logPairs
                logItems = logPairsToItems recentLogs
                logCtx = logContext logPairs
                hasMore = length logPairs > 8
                context =
                    constField "title" "home"
                        <> constField "description" defaultDescription
                        <> listField "posts" (postContext tags) (pure posts)
                        <> listField "logs" logCtx (pure logItems)
                        <> boolField "hasMoreLogs" (const hasMore)
                        <> boolField "hasLogs" (const $ not $ null logPairs)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/home.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Build the complete chronological blog archive.
    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- loadRecentPosts postsPattern
            let context =
                    constField "title" "blog"
                        <> constField "description" "notes on making, learning, and the strange machinery around us."
                        <> listField "posts" (postContext tags) (pure posts)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Build the full logs archive at /logs/.
    create ["logs/index.html"] $ do
        route idRoute
        compile $ do
            logPairs <- loadLogPairs
            let logItems = logPairsToItems logPairs
                logCtx = logContext logPairs
                context =
                    constField "title" "logs"
                        <> constField "description" "short timestamped notes, newest first."
                        <> listField "logs" logCtx (pure logItems)
                        <> boolField "hasLogs" (const $ not $ null logPairs)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/logs.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Build the journey timeline at /journey/.
    create ["journey/index.html"] $ do
        route idRoute
        compile $ do
            notes <- loadJourneyPairs
            let items = journeyPairsToItems notes
                context =
                    constField "title" "journey"
                        <> constField "description" "a sparse timeline of what i've been doing."
                        <> listField "years" (journeyContext notes) (pure items)
                        <> boolField "hasJourney" (const $ not $ null notes)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/journey.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    create ["robots.txt"] $ do
        route idRoute
        compile $ makeItem robotsTxt

    create ["sitemap.xml"] $ do
        route idRoute
        compile makeSitemap

postsPattern :: Pattern
postsPattern = "content/posts/*"

-- Keep published page URLs independent of the source directory layout.
pageRoute :: Routes
pageRoute = customRoute $ \identifier -> takeBaseName (toFilePath identifier) <> ".html"

dirPageRoute :: Routes
dirPageRoute = customRoute $ \identifier -> takeBaseName (toFilePath identifier) </> "index.html"

postRoute :: Routes
postRoute = customRoute $ \identifier -> "posts/" <> takeBaseName (toFilePath identifier) <> ".html"

tagRoute :: String -> Identifier
tagRoute = fromCapture "tags/*.html"

-- Render a post once, saving the rendered Markdown before templates wrap it.
renderPost :: Tags -> Compiler (Item String)
renderPost tags =
    pandocCompiler
        >>= saveSnapshot "content"
        >>= loadAndApplyTemplate "templates/post.html" (postContext tags)
        >>= loadAndApplyTemplate "templates/default.html" (postContext tags)
        >>= relativizeUrls

-- Render a regular Markdown page inside the shared site layout.
renderPage :: Context String -> Compiler (Item String)
renderPage context =
    pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" context
        >>= relativizeUrls

-- Load posts in reverse chronological order, using their front-matter dates.
loadRecentPosts :: Pattern -> Compiler [Item String]
loadRecentPosts pattern = recentFirst =<< loadAll pattern

siteRoot :: String
siteRoot = "https://thealokverse.com"

defaultDescription :: String
defaultDescription = "the notebook of light — programmer and technologist."

-- Context shared by pages that do not need post-specific metadata.
pageContext :: Context String
pageContext =
    field "canonical" canonicalField
        <> field "description" descriptionField
        <> constField "ogType" "website"
        <> defaultContext

-- Context available to a post itself and to every item in a post list.
postContext :: Tags -> Context String
postContext tags =
    dateField "date" "%B %e, %Y"
        <> dateField "isoDate" "%F"
        <> teaserField "excerpt" "content"
        <> tagsField "tags" tags
        <> constField "ogType" "article"
        <> pageContext

descriptionField :: Item a -> Compiler String
descriptionField item = do
    value <- getMetadataField (itemIdentifier item) "description"
    pure $ fromMaybe defaultDescription value

canonicalField :: Item a -> Compiler String
canonicalField item = do
    itemRoute <- getRoute (itemIdentifier item)
    pure $ siteRoot ++ prettyPath itemRoute

prettyPath :: Maybe FilePath -> String
prettyPath Nothing = "/"
prettyPath (Just path)
    | path == "index.html" = "/"
    | takeFileName path == "index.html" =
        let dir = takeDirectory path
         in if dir == "." then "/" else "/" ++ dir ++ "/"
    | otherwise = "/" ++ path

-- ---------------------------------------------------------------------------
-- Logs system (static Hakyll equivalent of melqtx live logs)
-- ---------------------------------------------------------------------------

data LogEntry = LogEntry
    { leTime :: LocalTime
    , leDisplay :: String
    , leISO :: String
    , leMessage :: String
    }
    deriving (Eq, Show)

-- Load and parse logs.txt, sorted newest-first. Stable for equal timestamps.
loadLogPairs :: Compiler [(Identifier, LogEntry)]
loadLogPairs = do
    raw <- loadBody "content/logs.txt" :: Compiler String
    let entries = parseLogs raw
        sorted = sortBy (comparing (Down . leTime)) entries
        pairs = zipWith (\idx e -> (fromFilePath $ "virtual/log-" ++ show idx, e)) [0 :: Int ..] sorted
    -- Warn about malformed lines (if any) via unsafeCompiler side-effect.
    _ <- unsafeCompiler $ mapM_ putStrLn (parseWarnings raw)
    pure pairs

logPairsToItems :: [(Identifier, LogEntry)] -> [Item String]
logPairsToItems pairs = [Item ident (leMessage e) | (ident, e) <- pairs]

logContext :: [(Identifier, LogEntry)] -> Context String
logContext pairs =
    field "displayTime" (\item -> pure $ maybe "" leDisplay (lookup (itemIdentifier item) pairs))
        <> field "isoTime" (\item -> pure $ maybe "" leISO (lookup (itemIdentifier item) pairs))
        <> field "message" (\item -> pure $ maybe "" (htmlEscape . leMessage) (lookup (itemIdentifier item) pairs))

parseLogs :: String -> [LogEntry]
parseLogs content = [e | Just e <- map parseLogLine (lines content)]

parseWarnings :: String -> [String]
parseWarnings content =
    [ "log warning: malformed line ignored: " ++ l
    | l <- lines content
    , let t = trim l
    , not (null t)
    , not ("#" `isPrefixOf` t)
    , parseLogLine l == Nothing
    ]

parseLogLine :: String -> Maybe LogEntry
parseLogLine rawLine =
    let stripped = trim rawLine
     in if null stripped || "#" `isPrefixOf` stripped
            then Nothing
            else case break (== '|') rawLine of
                (_, "") -> Nothing -- no pipe found
                (timePart, '|' : msgPart) ->
                    let ts = trim timePart
                        msg = trim msgPart
                     in if null msg
                            then Nothing
                            else case parseLogTime ts of
                                Nothing -> Nothing
                                Just lt ->
                                    Just $
                                        LogEntry
                                            { leTime = lt
                                            , leDisplay = formatTime defaultTimeLocale "%Y.%m.%d %H:%M" lt
                                            , leISO = formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:00" lt
                                            , leMessage = msg
                                            }
                _ -> Nothing

parseLogTime :: String -> Maybe LocalTime
parseLogTime s =
    tryFormats ["%Y.%m.%d %H:%M", "%Y-%m-%d %H:%M", "%Y/%m/%d %H:%M", "%Y.%m.%d", "%Y-%m-%d"] s
  where
    tryFormats [] _ = Nothing
    tryFormats (f : fs) str = case parseTimeM True defaultTimeLocale f str of
        Just t -> Just t
        Nothing -> tryFormats fs str

trim :: String -> String
trim = f . f
  where
    f = reverse . dropWhile isSpace

htmlEscape :: String -> String
htmlEscape = concatMap esc
  where
    esc '&' = "&amp;"
    esc '<' = "&lt;"
    esc '>' = "&gt;"
    esc '"' = "&quot;"
    esc c = [c]

-- ---------------------------------------------------------------------------
-- Journey timeline
-- ---------------------------------------------------------------------------

data JourneyNote = JourneyNote
    { jnYear :: String
    , jnText :: String
    , jnShowYear :: Bool
    }
    deriving (Eq, Show)

loadJourneyPairs :: Compiler [(Identifier, JourneyNote)]
loadJourneyPairs = do
    raw <- loadBody "content/journey.txt" :: Compiler String
    let notes = markYears (parseJourney raw)
        pairs = zipWith (\idx n -> (fromFilePath $ "virtual/journey-" ++ show idx, n)) [0 :: Int ..] notes
    pure pairs

markYears :: [(String, String)] -> [JourneyNote]
markYears = go Nothing
  where
    go _ [] = []
    go prev ((year, text) : rest) =
        JourneyNote year text (prev /= Just year) : go (Just year) rest

parseJourney :: String -> [(String, String)]
parseJourney = mapMaybe parseJourneyLine . lines

parseJourneyLine :: String -> Maybe (String, String)
parseJourneyLine rawLine =
    let stripped = trim rawLine
     in if null stripped || "#" `isPrefixOf` stripped
            then Nothing
            else case break (== '|') rawLine of
                (yearPart, '|' : textPart) ->
                    let year = trim yearPart
                        text = trim textPart
                     in if null year || null text then Nothing else Just (year, text)
                _ -> Nothing

journeyPairsToItems :: [(Identifier, JourneyNote)] -> [Item String]
journeyPairsToItems pairs = [Item ident (jnText n) | (ident, n) <- pairs]

journeyContext :: [(Identifier, JourneyNote)] -> Context String
journeyContext pairs =
    field "year" (\item -> pure $ maybe "" jnYear (lookup (itemIdentifier item) pairs))
        <> field "text" (\item -> pure $ maybe "" (htmlEscape . jnText) (lookup (itemIdentifier item) pairs))
        <> boolField "showYear" (\item -> maybe False jnShowYear (lookup (itemIdentifier item) pairs))

-- ---------------------------------------------------------------------------
-- robots.txt + sitemap.xml
-- ---------------------------------------------------------------------------

robotsTxt :: String
robotsTxt =
    unlines
        [ "User-agent: *"
        , "Allow: /"
        , ""
        , "Sitemap: " ++ siteRoot ++ "/sitemap.xml"
        ]

staticSitemapPaths :: [String]
staticSitemapPaths =
    [ "/"
    , "/blog.html"
    , "/projects.html"
    , "/library.html"
    , "/about.html"
    , "/donate/"
    , "/domains/"
    , "/journey/"
    , "/logs/"
    ]

makeSitemap :: Compiler (Item String)
makeSitemap = do
    posts <- loadRecentPosts postsPattern
    routes <- mapM (getRoute . itemIdentifier) posts
    let postPaths = map prettyPath routes
        urls = map (siteRoot ++) (staticSitemapPaths ++ postPaths)
    makeItem $ sitemapXml urls

sitemapXml :: [String] -> String
sitemapXml urls =
    unlines $
        [ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        , "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
        ]
            ++ map (\u -> "  <url><loc>" ++ u ++ "</loc></url>") urls
            ++ ["</urlset>"]

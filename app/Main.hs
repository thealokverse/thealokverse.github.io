{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Hakyll
import System.FilePath (takeBaseName)

main :: IO ()
main = hakyll $ do
    tags <- buildTags postsPattern tagRoute

    -- Copy files that should be served exactly as they appear in source.
    match "assets/**" $ do
        route idRoute
        compile copyFileCompiler

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

    -- Create a tag archive for every tag declared in post front matter.
    tagsRules tags $ \tag pattern -> do
        route idRoute
        compile $ do
            posts <- loadRecentPosts pattern
            let context =
                    constField "title" ("Posts tagged “" <> tag <> "”")
                        <> listField "posts" (postContext tags) (pure posts)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Build the home page with the three most recent posts.
    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- take 3 <$> loadRecentPosts postsPattern
            let context =
                    listField "posts" (postContext tags) (pure posts)
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
                    constField "title" "Blog"
                        <> listField "posts" (postContext tags) (pure posts)
                        <> pageContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    -- Give GitHub Pages a useful page when a requested path does not exist.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let context = constField "title" "Page not found" <> pageContext
            makeItem "<section class=\"page-intro\"><p class=\"eyebrow\">404</p><h1>page not found</h1><p>The page you requested does not exist.</p></section>"
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

postsPattern :: Pattern
postsPattern = "content/posts/*"

-- Keep published page URLs independent of the source directory layout.
pageRoute :: Routes
pageRoute = customRoute $ \identifier -> takeBaseName (toFilePath identifier) <> ".html"

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

-- Context shared by pages that do not need post-specific metadata.
pageContext :: Context String
pageContext = defaultContext

-- Context available to a post itself and to every item in a post list.
postContext :: Tags -> Context String
postContext tags =
    dateField "date" "%B %e, %Y"
        <> dateField "isoDate" "%F"
        <> teaserField "excerpt" "content"
        <> tagsField "tags" tags
        <> pageContext

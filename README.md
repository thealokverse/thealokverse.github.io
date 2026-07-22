# thealokverse

A quiet, static personal website built with [Hakyll](https://jaspervdj.be/hakyll/) and intended for GitHub Pages.

## Project layout

```text
app/Main.hs          Hakyll generator: routes and compilation rules
assets/              CSS and browser JavaScript copied unchanged to the site
content/             Page and blog-post source content
templates/           Shared HTML layouts
my-site.cabal        Haskell package and dependency definition
```

`_site/`, `_cache/`, and `dist-newstyle/` are generated locally and are intentionally ignored by Git.

## First setup

Install GHC and Cabal through [GHCup](https://www.haskell.org/ghcup/). Then, from this folder, run:

```sh
cabal build
```

The first build downloads and compiles Hakyll and its dependencies. It can take a while on an older computer; later builds use the local cache and are much faster.

## Everyday use

Preview the site during writing or design work:

```sh
cabal run my-site -- watch
```

Open `http://localhost:8000`. Hakyll rebuilds after you save a content, template, CSS, or generator file.

Create the deployment output:

```sh
cabal run my-site -- build
```

The finished static files are written to `_site/`. Deploy the *contents* of that folder to GitHub Pages; do not commit `_site/` to the source branch unless your deployment approach explicitly requires it.

## Adding a post

Create a Markdown file in `content/posts/` named `YYYY-MM-DD-slug.md`. Keep the metadata block and the `<!--more-->` separator; the separator supplies the excerpt on the blog page.

```markdown
---
title: A useful note
date: 2026-07-22
reading: 3 min read
tags: notes, web
---

The opening paragraph appears in the blog archive.

<!--more-->

The rest appears on the post page.
```

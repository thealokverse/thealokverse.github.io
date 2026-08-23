# thealokverse.com

Personal site for Light. Built with [Hakyll](https://jaspervdj.be/hakyll/), hosted on GitHub Pages.

**Edit source files. Never edit `_site/`.**

## Architecture

| Path | Role |
| --- | --- |
| `app/Main.hs` | Hakyll rules, routes, logs/journey parsers, SEO helpers |
| `templates/` | HTML wrappers (`default.html` is the shell) |
| `content/*.md` | Root pages → `/about.html`, `/projects.html`, `/library.html`, `/404.html` |
| `content/pages/*.md` | Directory pages → `/donate/`, `/domains/` |
| `content/posts/` | Blog posts → `/posts/<slug>.html` |
| `content/logs.txt` | Homepage + `/logs/` source |
| `content/journey.txt` | `/journey/` source |
| `assets/` | CSS, JS, images (copied as-is) |
| `.github/workflows/deploy.yml` | Build + deploy `_site` to GitHub Pages |

Routes worth knowing:

- `/` — home (`create ["index.html"]`)
- `/blog.html` — archive
- `/logs/` — full log list (`create ["logs/index.html"]`)
- `/logs.txt` — raw log file
- `/journey/` — timeline
- `/donate/`, `/domains/` — markdown directory pages
- `/robots.txt`, `/sitemap.xml` — generated

## Day-to-day

### Add a log

Append one line to `content/logs.txt`:

```
2026.08.23 13:42|spent an hour fixing a stupid CSS bug
```

- Format: `YYYY.MM.DD HH:MM|message` (dots preferred; `YYYY-MM-DD HH:MM` also works)
- Split on the **first** `|` only, so the message may contain `|`
- `#` comments and blank lines are ignored
- Newest first (sorted at build from the timestamp you wrote, not build time)
- Homepage shows the 8 newest inside a short scroll box
- `/logs/` shows every valid entry
- Bad timestamps / missing `|` / empty messages are skipped; the build still succeeds and prints `log warning: malformed line ignored: ...`

### Add a blog post

Create `content/posts/YYYY-MM-DD-slug.md`:

```
---
title: the title
date: 2026-08-23
reading: 5 min read
tags: linux, notes
---

**opening line used as the teaser.**

<!--more-->

the rest of the post.
```

### Edit pages

- About: `content/about.md`
- Donate: `content/pages/donate.md`
- Domains: add another `<li>` in `content/pages/domains.md`
- Journey: append `YYYY|note` in `content/journey.txt` (same year may repeat)
- Images: put the file in `assets/` and reference `/assets/filename`

### Metadata

`title` and optional `description` live in markdown front matter. Home, blog, logs, and journey set description in `Main.hs`. Canonical, Open Graph, Twitter, and JSON-LD are filled in `templates/default.html` from those fields.

## Local commands

```bash
cabal run my-site -- watch   # rebuild on change, serve http://127.0.0.1:8000
cabal run my-site -- build   # write _site/
cabal run my-site -- clean   # delete _site/ and _cache/
```

`watch` is for writing. `build` is what CI runs. `clean` is only needed after rule changes if the store looks stale.

## Deployment

Push `main`. `.github/workflows/deploy.yml` runs `cabal run my-site -- build` and publishes `_site` with GitHub Pages.

## Do not hand-edit

`_site/`, `_cache/`, `dist-newstyle/`. Those are generated.

## Troubleshooting

If you see:

```
Hakyll.Core.Compiler.Require.load:
templates/default.html (snapshot _final) was not found in the cache
```

the store is out of date relative to the rules (usually after adding a `match`/`create`). Run `cabal run my-site -- clean && cabal run my-site -- build`. 404 is a real page (`content/404.md`), not a virtual `create`, so a clean build is enough to recover.

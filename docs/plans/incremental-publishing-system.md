# Incremental Publishing System

## 1. Purpose and scope

This plan defines an incremental build model for a Scribere site where the filesystem remains the source of truth and derived outputs are rebuilt only when needed. It replaces the earlier change journal proposal with a lighter approach that uses file system change events and a disposable cache during local development, while keeping CI deterministic by building from the commit tree.

The goal is to make local editing responsive even with very large archives, while keeping the production build predictable and auditable. The system must preserve Scribere's core rules: templates stay pure HTML, queries stay declarative, and content remains Markdown-first.

## 2. Core principles

The system rests on three principles that keep behaviour simple and observable. Each principle is stated here because it drives the rest of the implementation choices.

- The filesystem is the source of truth. Articles live in Markdown, and nothing in the build process is allowed to supersede what is on disk.
- The cache is derived and disposable. It can be deleted at any time without losing content, and it must be cheap to regenerate.
- Local and CI flows are different by design. Local development optimises for immediacy and visibility; CI optimises for determinism.

## 3. Local development workflow

Local development uses a watcher to detect edits and a cache to avoid re-reading the entire archive. Nodemon already provides the watcher signal; the build script handles the incremental logic. When a change is detected, the build compares file metadata against the cache, re-parses only the articles that changed, updates affected indexes, and re-renders only the outputs that depend on those articles.

Drafts and lint-failing articles must be visible in dev output, with a clear visual marker and lint report. The dev server is a feedback loop, not a gate. This is important when a large archive exists because the developer must trust that they are seeing what actually exists on disk, even when it is not ready to publish.

## 4. CI workflow

CI builds from the commit tree and produces a clean, published-only output. It does not need a watcher or a cache and can rebuild everything if that is simplest. If we want incremental CI later, it should use git diffs between commits to decide which articles are dirty and which index pages need regeneration. The CI build must remain deterministic and should never depend on untracked or unstaged changes.

## 5. Incremental rebuild rules

Incremental builds remain safe only if the dependency rules are explicit. For each changed article, the build must re-render the article page itself and any derived pages that include it. That includes feeds and index pages produced by queries. This does not require a change journal; it requires a dependency map based on the article's frontmatter and the set of queries.

Concretely, when an article changes, the build updates the article page and recalculates any tag, series, year, or archive pages that contain it. If the article's metadata changes, its membership in those lists changes and the rebuild must reflect that. If only the body changes, index membership stays stable but the article page must still be rebuilt.

## 6. Cache design

The cache should live in a disposable file such as `temp/index.json`. It needs to store only what the build uses to decide whether a file is dirty and which derived pages it touches. A minimal per-article record includes the path, size, mtime, hash, status, tags, series, and a lint summary. This is a derived snapshot that makes rebuild decisions fast but never replaces the source content.

If the cache is missing or invalid, the build performs a full scan once to rebuild it. This is acceptable because it happens only on a cold start or after a deliberate cache clear.

## 7. Failure and recovery

The build must degrade safely when data is missing or malformed. If a frontmatter field is missing, the build should apply defaults and log a warning rather than crashing. If an article folder is malformed, it should be skipped with a visible warning and included in the dev lint report. If the cache appears out of sync, the build should fall back to a full scan and regenerate it.

The most important recovery rule is that content should not be lost and output should remain stable. When in doubt, prefer a full rebuild to an incorrect incremental update.

## 8. Implementation plan

Stage 1 establishes a safe cache and incremental detection without changing the watcher. The build reads or writes `temp/index.json`, compares mtimes and sizes, and re-parses only changed articles. It rebuilds affected pages using the existing query system. Nodemon continues to trigger full build runs, but the work inside each run becomes incremental.

Stage 2 introduces explicit file-path awareness. Instead of relying only on mtime comparisons, a small watcher wrapper can pass changed paths into the build. This reduces scanning and makes the incremental logic more precise, while keeping behaviour identical. If a path cannot be mapped to an article, the build falls back to an incremental scan or full rebuild for safety.

Stage 3 adds CI-specific incremental options. If desired, CI can pass a list of changed files derived from `git diff` so the build only touches affected outputs. This remains optional; full builds remain the default for simplicity.

Stage 4 hardens edge cases. This includes stricter logging, better lint reporting, and tests around cache regeneration and dependency mapping so that large archives remain reliable.

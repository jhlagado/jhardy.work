# AI-Driven Blogging Setup: Initial Spec Outline

This document defines product requirements for an AI-assisted blog that serves as both a documentation tool and a workflow testbed. The platform prioritizes semantic HTML, accessibility, minimal JavaScript, and durable, portable content.

## Table of Contents
- [1. Introduction](#1-introduction)
- [2. Design Foundations](#2-design-foundations)
- [3. Content Creation Workflow](#3-content-creation-workflow)
- [4. Draft Lifecycle](#4-draft-lifecycle)
- [5. Metadata and Tagging Rules](#5-metadata-and-tagging-rules)
- [6. Internal Linking Conventions](#6-internal-linking-conventions)
- [7. Asset Management](#7-asset-management)
- [8. Review Gate](#8-review-gate)
- [9. AI Vocabulary](#9-ai-vocabulary)
- [10. CI and Publishing Process](#10-ci-and-publishing-process)
- [11. CSS and Styling](#11-css-and-styling)
- [12. Conclusion](#12-conclusion)

## 1. Introduction
This blog has two roles: a primary record of technical work and a testbed for AI-assisted authoring. It should feel timeless, fast, and easy to maintain.

Goals:
- Capture technical processes, decisions, and experiments.
- Reduce mechanical authoring tasks through AI assistance.
- Preserve classic web values: semantic HTML, accessibility, and minimal JavaScript.

## 2. Design Foundations
- **Semantic HTML**: structural tags that read well for humans and machines.
- **Accessibility**: keyboard navigation, alt text, ARIA roles, and contrast checks.
- **Minimal JavaScript**: progressive enhancement only; no heavy frameworks.
- **Performance and SEO**: fast pages, optimized images, crawlable structure.
- **Mobile-first**: design for small screens, then expand.

## 3. Content Creation Workflow
- **Conversational drafting**: AI helps shape title, summary, tags, and status.
- **Folder-based output**: each post lives in `/blog/YYYY/MM/DD/slug/` with a markdown file and co-located assets.
- **Linking and references**: internal links are relative; external links are curated during drafting.
- **Script evolution**: repeated actions become scripts stored in `/scripts/`.
- **Pre-publish step**: commit and push to trigger CI publishing.

## 4. Draft Lifecycle
- States: `draft`, `review`, `published`, `archived`.
- Visibility is driven by status only; no deletion required.
- Indexes and listings respect status metadata.

## 5. Metadata and Tagging Rules
- Frontmatter fields: `title`, `date`, `status`, `summary`, `tags`.
- Tags are case-insensitive and normalized to a canonical form.
- Normalize punctuation variants (e.g., `z80`, `Z-80`, `Z_80`).

## 6. Internal Linking Conventions
- Use stable, relative paths.
- Allow forward references; unresolved links are warnings, not errors.

## 7. Asset Management
- Assets live beside the article they belong to.
- Assets are durable and not auto-deleted.
- Shared assets are a manual decision, not automatic.

## 8. Review Gate
- Confirm summary accuracy and metadata completeness.
- Validate internal/external links and asset references.
- Optional AI checks for link integrity and missing fields.

## 9. AI Vocabulary
- Core verbs: `create`, `revise`, `tag`, `link`, `attach`, `status`.
- Verbs map to simple, scriptable actions.

## 10. CI and Publishing Process
- CI converts markdown to HTML and deploys to `gh-pages`.
- Templates generate article pages and index pages (tag/date).
- The build copies assets and flags missing metadata or unresolved links.
- Tooling should remain lean; prefer lightweight tools and small custom scripts.

## 11. CSS and Styling
- Minimal CSS toolchain: variables, grid/flex, and a clear naming scheme.
- Mobile-first layout with responsive typography and spacing.
- Support light/dark themes and high-contrast modes.
- Keep CSS lightweight for fast loads.

## 12. Conclusion
The platform should be a durable, low-friction place to document technical work while evolving a practical, AI-assisted publishing workflow.

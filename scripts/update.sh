#!/usr/bin/env bash
set -e

git remote get-url upstream >/dev/null 2>&1 || git remote add upstream https://github.com/jhlagado/scribere.git
git fetch upstream
git merge --no-edit upstream/main

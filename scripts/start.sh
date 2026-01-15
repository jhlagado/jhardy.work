#!/usr/bin/env bash
set -e

bash scripts/dev-build.sh

HOST=${HOST:-127.0.0.1} node scripts/serve.js & srv_pid=$!
trap 'if [ -n "$srv_pid" ]; then kill "$srv_pid" 2>/dev/null; fi' EXIT

echo "[dev] watching for changes"
nodemon --quiet --on-change-only --exitcrash --legacy-watch --watch content --watch example --watch config --ignore build --ext md,html,css,js,json,svg --exec "bash scripts/dev-build.sh"

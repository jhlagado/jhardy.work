#!/usr/bin/env bash
set -e

npm run -s lint -- --all --report-path temp/lint-report.json || echo "[lint] issues (non-blocking)"
SOFT_FAIL=1 LINT_REPORT_PATH=temp/lint-report.json node scripts/build.js && echo "[build] ok"

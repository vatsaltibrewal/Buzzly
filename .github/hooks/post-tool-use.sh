#!/bin/sh
# PostToolUse: record that non-documentation files changed, so the Stop hook can check whether a
# documentation-impact review happened. The marker is local runtime state, never project knowledge.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

if git status --porcelain 2>/dev/null | cut -c4- | grep -qv -e '\.md$' -e '^docs/'; then
	mkdir -p .ai-runtime 2>/dev/null && : >.ai-runtime/docs-dirty
fi

exit 0

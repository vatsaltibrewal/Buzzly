#!/bin/sh
# Stop: warn when source or configuration changed but no documentation was touched.
# Non-blocking by design - it reminds, it does not decide. Exit code stays 0.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

[ -f .ai-runtime/docs-dirty ] || exit 0
rm -f .ai-runtime/docs-dirty

# Documentation was also touched in the working tree - assume the review happened.
if git status --porcelain 2>/dev/null | cut -c4- | grep -q -e '\.md$' -e '^docs/'; then
	exit 0
fi

printf '{"systemMessage":"%s"}\n' "Buzzly: source or configuration changed but no documentation was updated. Run /document-sync, then confirm whether docs/ai/CONTEXT.md and docs/PROJECT_STATE.md are still accurate."
exit 0

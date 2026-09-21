#!/bin/sh
# SessionStart: confirm the project's AI context files exist and remind the agent to bootstrap.
# Mechanical check only. Semantic documentation work is the agent's job, not this script's.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

missing=""
for f in AGENTS.md docs/ai/CONTEXT.md docs/PROJECT_STATE.md docs/ai/DOCUMENTATION_POLICY.md; do
	[ -f "$f" ] || missing="$missing $f"
done

if [ -n "$missing" ]; then
	msg="Buzzly context files are missing:$missing - restore them before trusting project context."
else
	msg="Buzzly: bootstrap from docs/ai/CONTEXT.md and docs/PROJECT_STATE.md before substantial work (or run /resume). This repository has no application code yet - verify on disk before claiming otherwise. Documentation sync is required before completing meaningful changes."
fi

printf '{"systemMessage":"%s"}\n' "$msg"
exit 0

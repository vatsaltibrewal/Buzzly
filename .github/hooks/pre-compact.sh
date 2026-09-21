#!/bin/sh
# PreCompact: warn that in-progress work should be checkpointed before conversation context is lost.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

if git status --porcelain 2>/dev/null | grep -q .; then
	printf '{"systemMessage":"%s"}\n' "Buzzly: context is about to be compacted and the working tree has uncommitted changes. Run /checkpoint to persist progress into docs/plans/active/ before detail is lost."
fi

exit 0

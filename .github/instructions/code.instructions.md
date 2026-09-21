---
description: "Use when writing, changing, or reviewing any Buzzly code. The lazy-senior discipline: exhaust reuse before writing, fix bugs at the root, keep the diff minimal, leave one runnable check. Also covers when NOT to be lazy - validation, security, accessibility."
applyTo: ["apps/**", "packages/**", "infra/**"]
---

# How to Write Code in Buzzly

Lazy means efficient, not careless. The best code is the code never written.

## Understand First

The ladder below runs **after** you understand the problem, never instead of it. Read the task, read
the code it touches, trace the real flow end to end. A small diff in the wrong place is not lazy —
it is a second bug.

## The Ladder

Stop at the first rung that holds:

1. **Does this need to exist at all?** (YAGNI)
2. **Does it already exist here?** Reuse the helper, util, or pattern already in the repo.
3. **Does the standard library do it?** Use it.
4. **Does a native platform feature cover it?** A browser API, a PostgreSQL feature, a Python
   builtin.
5. **Does an already-installed dependency solve it?** Use it. Read the manifest before adding
   anything.
6. **Can it be one line?** Make it one line.
7. **Only then** write the minimum code that works.

## Bug Fixes Go to the Root

A report names a symptom, not the cause. Grep every caller of the function you are about to touch,
then fix the shared function once. One guard in the shared function is a smaller diff than one guard
per caller — and patching only the path the ticket names leaves a sibling caller broken.

## Rules

- No abstraction that was not explicitly requested.
- No new dependency if it can be avoided. A major one is an ADR-level decision here.
- No boilerplate nobody asked for.
- Deletion over addition. Boring over clever. Fewest files possible.
- Shortest working diff wins — once you understand the problem.
- Question complex requests: "Do you actually need X, or does Y cover it?"
- When two standard-library approaches are the same size, take the edge-case-correct one. Lazy means
  less code, not the flimsier algorithm.

## Never Be Lazy About

- Understanding the problem.
- **Input validation at trust boundaries** — in Buzzly that means everything arriving from the
  browser, including reported test results.
- Error handling that prevents data loss.
- **Security** — especially anything touching untrusted learner code or the mentor guardrail. The
  invariants in [AGENTS.md](../../AGENTS.md) are not negotiable for brevity.
- Accessibility.
- **Real-world calibration** — the platform is never the spec ideal. Clocks drift, Pyodide start-up
  varies by machine, latency is real. Duel timing must not assume ideal conditions.
- Anything explicitly requested.

## Marking Deliberate Corners

When you knowingly cut a corner with a known ceiling — a global lock, an O(n²) scan, a naive
heuristic — leave one comment naming the ceiling and the upgrade path:

```python
# ponytail: O(n^2) over room members; fine under ~50, move to a Redis sorted set beyond that.
```

Only for real corners with a real ceiling. Not for ordinary code.

## The One-Check Rule

Non-trivial logic leaves **one runnable check** behind: the smallest thing that fails if the logic
breaks. An assert-based self-check or one small test file. No frameworks, no fixtures, no mocks
nobody asked for.

Trivial one-liners need no check.

Lazy code without its check is unfinished.

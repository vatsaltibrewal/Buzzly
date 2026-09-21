---
name: resume
description: "Recover full Buzzly project context at the start of a fresh chat. Use when beginning a new session, picking up unfinished work, asking what is currently happening, or when you need to reconstruct architecture, decisions, current state, and next steps from the repository instead of chat history."
argument-hint: "Optional: the task, issue, or area you are about to work on"
---

# Resume Buzzly Context

Rebuild a working model of the project from Git-tracked files. Chat history is not a source of
truth; this repository is.

## When to Use

- First message in a new conversation about this project.
- Continuing work started in an earlier session.
- Before any substantial change, when you do not already hold current context.

## Procedure

Read broadly first, then narrow to the task. Read files in parallel where possible.

1. **Contract** — [AGENTS.md](../../../AGENTS.md). The rules you are bound by, including the product
   invariants.
2. **Map** — [docs/ai/CONTEXT.md](../../../docs/ai/CONTEXT.md). Stack, repository layout, entry
   points, commands, invariants, where knowledge lives.
3. **Current truth** — [docs/PROJECT_STATE.md](../../../docs/PROJECT_STATE.md). What works, what is
   in flight, what is blocked, which decisions are still open.
4. **Git state** — run `git status` and `git branch --show-current`. Note uncommitted work and never
   discard it. Check recent commits for what changed last.
5. **Active plans** — list [docs/plans/active/](../../../docs/plans/active/). Read any plan relevant
   to the request, especially its **Current Checkpoint**.
6. **Decisions** — read the ADRs in [docs/adr/](../../../docs/adr/) that touch the area you will
   work in. The index is in [docs/adr/README.md](../../../docs/adr/README.md).
7. **Structure and product** — [ARCHITECTURE.md](../../../ARCHITECTURE.md) and
   [PRODUCT.md](../../../PRODUCT.md), when the task touches either.
8. **Actual implementation** — search the source and tests for the area in question. Documentation
   states intent; code states behaviour.
9. **GitHub context** — if the request references an issue or PR and the GitHub MCP server is
   available, fetch it.
10. **Reconcile** — where documentation and code disagree, investigate. Treat the code as current
    behaviour unless the document explicitly describes planned work. Report contradictions; do not
    silently pick one.

## Standing Fact to Verify, Not Assume

Buzzly currently has no application code. If you find `apps/`, manifests, or tests on disk, the
documentation is stale and fixing it is part of your task.

## Output

Before editing anything, state briefly:

- what this project is and how it is structured
- what is currently happening and what was already completed
- what remains, and any blockers
- which invariants constrain the requested work
- the next concrete action you recommend

Keep it short. If the request is substantial and no plan covers it, propose creating one from
[docs/plans/TEMPLATE.md](../../../docs/plans/TEMPLATE.md).

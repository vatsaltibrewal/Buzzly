---
name: document-sync
description: "Run the Buzzly documentation-impact pass so docs match the code. Use after meaningful repository changes, before declaring a task done, or when the user asks to sync docs, update documentation, or check whether documentation is stale."
argument-hint: "Optional: the area or change to review"
---

# Documentation Sync

Bring documentation back in line with what the repository actually contains. Run this before
declaring any meaningful change complete.

## When to Use

- After a batch of code, configuration, schema, or dependency changes.
- Before finishing a task.
- When documentation is suspected of being stale or contradictory.

## Procedure

1. **Look at the real diff.** `git status`, `git diff`, `git diff --staged`. Never guess what
   changed.
2. **Ask the impact questions.** Did this change alter behaviour, architecture, APIs, schema,
   dependencies, configuration, build/lint/test commands, deployment, security assumptions,
   repository layout, conventions, project state, or plan progress? Did it reveal durable knowledge
   missing from the docs?

   If every answer is no, stop and report no impact. **Do not edit documentation to look busy.**
3. **Find the owners.** Use
   [docs/ai/DOCUMENTATION_POLICY.md](../../../docs/ai/DOCUMENTATION_POLICY.md) to decide which file
   owns each affected fact. Update the owner; link from elsewhere rather than duplicating.
4. **Read before editing.** Open the current text so you correct it rather than bolt new prose onto
   contradictory old prose.
5. **Update only what is affected:**
   - [docs/ai/CONTEXT.md](../../../docs/ai/CONTEXT.md) — layout, stack, entry points, commands,
     invariants, active work
   - [docs/PROJECT_STATE.md](../../../docs/PROJECT_STATE.md) — stable functionality, WIP,
     limitations, debt, open decisions, runtime state
   - [ARCHITECTURE.md](../../../ARCHITECTURE.md) — components, boundaries, data flow, storage,
     invariants
   - [PRODUCT.md](../../../PRODUCT.md) — scope, product rules, domain vocabulary
   - [CONTRIBUTING.md](../../../CONTRIBUTING.md) — setup, development, lint, test workflow
   - [docs/adr/](../../../docs/adr/) — new or superseding ADR for a durable decision; update the
     index
   - [docs/plans/active/](../../../docs/plans/active/) — tasks and checkpoint, if work progressed
6. **Fix the tense.** Anything now implemented must stop being described as planned. Rewrite the
   section properly; removing the word "planned" is not enough.
7. **Kill contradictions.** Where two files disagree, verify against the code, correct the wrong
   one, and remove the duplicate rather than leaving both.
8. **Delete stale statements** instead of qualifying them. These documents describe the present.
9. **Verify every claim.** Commands must have been run. Paths must exist. Dependencies must appear
   in a manifest. Remove anything unverifiable.
10. **Check the links.** Relative Markdown links must resolve, including the ADR index.

## Quality Bar

- Human-readable prose, plain English, no emoji.
- No changelogs, chat transcripts, prompt logs, generated inventories, or pasted source.
- Concise: what exists, why, how the pieces interact, what constrains them.

## Output

End with either:

```
Documentation:
- updated <files>
- synchronized docs/ai/CONTEXT.md
```

or:

```
Documentation:
- no durable documentation impact
```

---
name: checkpoint
description: "Persist Buzzly work state so a fresh chat can continue safely. Use when pausing unfinished work, ending a session mid-task, before context runs out, or when the user says checkpoint, save progress, or wrap up for now."
argument-hint: "Optional: which plan or work stream to checkpoint"
---

# Checkpoint Buzzly Work

Write down enough that a new conversation with no history can pick the work up without breaking
anything.

## When to Use

- Stopping mid-task.
- Context is about to be compacted or lost.
- Handing work over.
- The user asks to save progress.

**Do not create a checkpoint when nothing changed.** A checkpoint that records no work is noise.
Say so and stop.

## Procedure

1. **Inspect reality.** Run `git status` and `git diff` (and `git diff --staged`). Work from the
   actual diff, not from memory of what you intended.
2. **Find the plan.** Locate the relevant file in
   [docs/plans/active/](../../../docs/plans/active/). If substantial work happened without a plan,
   create one now from [docs/plans/TEMPLATE.md](../../../docs/plans/TEMPLATE.md).
3. **Update the plan:**
   - tick completed tasks; add tasks discovered along the way
   - record durable decisions under *Decisions Made During Implementation*
   - rewrite **Current Checkpoint** in full: completed, remaining, exact current state, files
     touched, tests actually run and their results, failures and blockers, next recommended action
   - update `Status`
4. **Record tests honestly.** Only list commands you actually ran, with their real outcome. If you
   ran nothing, say so.
5. **Promote durable decisions.** Anything architectural belongs in an ADR
   ([docs/adr/README.md](../../../docs/adr/README.md)), not only in the plan. Update the ADR index.
6. **Update state** — [docs/PROJECT_STATE.md](../../../docs/PROJECT_STATE.md) if stable
   functionality, limitations, open decisions, or runtime state changed.
7. **Update architecture** — [ARCHITECTURE.md](../../../ARCHITECTURE.md) if components, boundaries,
   data flow, or invariants changed. Remove "planned" framing from anything now built.
8. **Update developer docs** — [CONTRIBUTING.md](../../../CONTRIBUTING.md) if setup, build, or test
   commands changed.
9. **Synchronize the map** — [docs/ai/CONTEXT.md](../../../docs/ai/CONTEXT.md) if layout, stack,
   entry points, commands, invariants, or active work changed. Rewrite stale sections; do not
   append.
10. **Verify against the code.** Re-read what you just wrote and confirm each claim matches the
    repository. Delete anything you cannot verify.
11. **Optional memory.** Save only small, durable, non-sensitive facts to repository memory. Never
    plans, requirements, architecture, task state, or secrets — those belong in `docs/`.
12. **Finish the work if it is complete.** Move the plan to `docs/plans/archive/` and reflect
    completion in `docs/PROJECT_STATE.md`.

## Do Not

- Fabricate progress, test results, or completion.
- Commit or push unless explicitly asked.
- Touch timestamps or files to make it look like something happened.

## Output

Report what changed, what remains, any blocker, and the exact next action a fresh chat should take.

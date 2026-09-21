# Plan Template

Copy this file to `docs/plans/active/NNNN-short-kebab-title.md` for work that spans multiple steps or
sessions. Delete the sections that genuinely do not apply. Trivial changes do not need a plan.

The **Current Checkpoint** is the most important section: a fresh chat with no history must be able
to read it and safely continue. Keep it accurate as you work, not only at the end.

When the work is done, move the file to `docs/plans/archive/`.

---

# <Feature or Task>

Status: Not started | In progress | Blocked | Complete
Related issue / PR: <link or "none">
Stage: <roadmap stage from README.md, if applicable>

## Objective

One paragraph. What this work achieves and why it matters now.

## Requirements

What must be true when this is finished.

## Non-goals

What this work deliberately does not do, so scope does not drift.

## Relevant Existing Architecture

What already exists that this work builds on or must not break. Link to `ARCHITECTURE.md` and any
relevant ADRs.

## Relevant Files

Files expected to be created or changed. Mark which exist today and which do not.

## Implementation Strategy

The approach, and the order of work with its reasoning. Note anything that must happen before
something else.

## Tasks

- [ ] Task
- [ ] Task

## Testing / Verification Plan

How correctness will actually be checked. Name real commands once they exist.

## Documentation Impact

Which documents this work will require updating, decided up front:

- [ ] `docs/ai/CONTEXT.md`
- [ ] `docs/PROJECT_STATE.md`
- [ ] `ARCHITECTURE.md`
- [ ] `CONTRIBUTING.md`
- [ ] `PRODUCT.md`
- [ ] New ADR(s)

## Decisions Made During Implementation

Decisions taken while building. Anything durable must also become an ADR — this section is a
scratchpad, not a source of truth.

## Current Checkpoint

Updated: YYYY-MM-DD

**Completed:**

**Remaining:**

**Exact current state:**

**Files touched so far:**

**Tests actually run, and their results:**

**Failures / blockers:**

**Next recommended action:**

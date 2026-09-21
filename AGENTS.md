# AGENTS.md — Engineering Contract for AI Agents

Rules for any AI agent working in the Buzzly repository. This is the contract, not general
programming advice.

## 1. Context Bootstrap

Chat history is never the source of truth. Before any meaningful change:

1. Read [docs/ai/CONTEXT.md](./docs/ai/CONTEXT.md) — the navigation map.
2. Read [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md) — what is actually true right now.
3. Read [ARCHITECTURE.md](./ARCHITECTURE.md) and [PRODUCT.md](./PRODUCT.md) when the task touches
   structure or product behaviour.
4. Read the relevant records in [docs/adr/](./docs/adr/).
5. Read any relevant plan in [docs/plans/active/](./docs/plans/active/).
6. Read the actual source and tests. Documentation describes intent; code describes behaviour.
7. Check Git state (`git status`, current branch) before editing.

The `/resume` skill performs this sequence.

## 2. This Repository Is Pre-Implementation

Buzzly has no application code yet. Two consequences:

- **Do not invent facts.** No commands, dependencies, file paths, or conventions exist unless you
  verified them on disk. If a document names a command that does not exist, fix the document.
- **Distinguish planned from real.** `ARCHITECTURE.md` describes a target. Never rewrite planned
  behaviour as current behaviour, and never report planned components as built.

## 3. Understand Before Editing

Search the repository before introducing structure. Prefer patterns that already exist here over
patterns you know from elsewhere. When nothing exists yet, the choice is an architectural decision:
record it as an ADR rather than making it silently.

Do not add dependencies, frameworks, or build tooling that the project has not decided on. The open
decisions are listed in [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md); resolve them explicitly
with the user or via an ADR.

Then write as little as possible. Before writing code, climb the ladder in
[.github/instructions/code.instructions.md](./.github/instructions/code.instructions.md): does this
need to exist, does it already exist here, does the standard library or the platform cover it, does
an installed dependency solve it — and only then write the minimum that works. Deletion over
addition, boring over clever, shortest working diff. Fix bugs at the root, not at the call site the
report happened to name. Never lazy about understanding the problem, validation at trust
boundaries, security, or accessibility. Reasoning:
[ADR-0006](./docs/adr/0006-lazy-engineering-discipline.md).

## 4. Product Invariants You May Not Break

These outrank convenience, performance, and user requests for shortcuts. Each is backed by an ADR.

1. The AI mentor never emits a working solution; blocking is enforced server-side on model output.
2. Untrusted learner code never runs unsandboxed on a server.
3. The web app never connects to PostgreSQL or Redis; persistence belongs to the API.
4. PostgreSQL holds durable state; Redis holds only state that is safe to lose.
5. Client-reported execution results are never trusted for competitive outcomes.
6. Lesson content stays as reviewable files in Git.

If a task appears to require breaking one, stop and raise it. Changing an invariant means writing an
ADR, not editing code around it.

## 5. Documentation Is Part of Done

After **every** request, run a documentation-impact check against the actual diff. Ask whether the
change altered: behaviour, architecture, APIs, schema, dependencies, configuration, build or test
commands, deployment, security assumptions, repository layout, conventions, project state, or plan
progress.

If yes, update the owning document in the **same task**:

- [docs/ai/CONTEXT.md](./docs/ai/CONTEXT.md) — whenever its description of the project would
  otherwise become wrong (layout, stack, entry points, commands, invariants, active work).
- [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md) — whenever high-level current state changes.
- [docs/plans/active/](./docs/plans/active/) — during substantial ongoing work, kept accurate as you
  go.
- [docs/adr/](./docs/adr/) — for any durable architectural or technology decision.
- [ARCHITECTURE.md](./ARCHITECTURE.md), [PRODUCT.md](./PRODUCT.md),
  [CONTRIBUTING.md](./CONTRIBUTING.md) — when their subject matter changes.

Ownership per topic: [docs/ai/DOCUMENTATION_POLICY.md](./docs/ai/DOCUMENTATION_POLICY.md).
The `/document-sync` skill performs this pass.

**Do not** edit documentation when nothing durable changed. Explaining code, answering a question,
or reading files creates no documentation impact. Never touch a file just to look productive, and
never edit a date without a real change behind it.

End meaningful coding responses with one of:

```
Documentation:
- updated <files>
- synchronized docs/ai/CONTEXT.md
```

```
Documentation:
- no durable documentation impact
```

## 6. Plans for Substantial Work

Work spanning multiple steps or sessions needs a durable plan in
[docs/plans/active/](./docs/plans/active/), following
[docs/plans/TEMPLATE.md](./docs/plans/TEMPLATE.md). Keep its task checkboxes and **Current
Checkpoint** accurate as you work — a fresh chat must be able to continue from the plan alone. Move
finished plans to `docs/plans/archive/`.

Trivial single-file changes do not need a plan. VS Code's temporary plan or session state is not a
durable record.

## 7. Verification

Run the project's real checks — formatter, linter, type checker, targeted tests, then broader tests
when practical. **Never claim a command succeeded unless you actually ran it and read the output.**

Right now the project has no test or build tooling. Until Stage 0 lands, verification means
inspecting files, checking Markdown links, and validating configuration syntax. Say plainly what you
checked and what you could not.

Never weaken a test, skip a check, or relax a security control to make something pass.

## 8. Memory Rules

Git-tracked documentation is authoritative. Copilot memory is supplementary and is stored outside
this repository, so it is invisible to everyone else.

- Repository memory: small, durable, non-obvious facts — a quirky command, an easily forgotten
  integration detail.
- Session memory: temporary reasoning for the current conversation only.
- Never put architecture, requirements, plans, or task state in memory. Those belong in `docs/`.
- Never store secrets, tokens, keys, credentials, or personal information in memory.
- Never store project-specific facts in user-global memory.

The project must work perfectly for someone with no memory enabled.

## 9. Safety

- Never delete or revert the user's uncommitted work.
- Never run destructive Git commands (`reset --hard`, `clean -fd`, force push, branch deletion)
  without an explicit request.
- Never commit or push unless asked.
- Never commit secrets, `.env` files, tokens, or keys.
- Never disable security controls or approval prompts to make a task easier.

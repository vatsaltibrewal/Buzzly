# ADR-0005: Git-tracked documentation is the durable AI context

Status: Accepted
Date: 2026-08-30

## Context

Buzzly is built largely with AI assistance across many separate chat sessions. Each session starts
with no memory of the last one. Without a deliberate system, project knowledge lives in chat
history: invisible to collaborators, unreviewable, and gone when the conversation ends.

AI assistants offer their own memory features, but that memory is stored per machine and per
workspace, outside the repository. It is not shared, not reviewed, and not versioned. Relying on it
would mean the project's understanding of itself depends on one developer's local machine.

## Decision

Version-controlled documentation is the project's durable memory. AI memory is supplementary only.

- Durable knowledge lives in Git-tracked files with a single owner per topic, defined in
  [docs/ai/DOCUMENTATION_POLICY.md](../ai/DOCUMENTATION_POLICY.md).
- [docs/ai/CONTEXT.md](../ai/CONTEXT.md) is the entry point a fresh agent reads to reconstruct the
  project.
- Multi-session work is checkpointed into [docs/plans/active/](../plans/) so any new session can
  continue it.
- Documentation synchronisation is part of finishing a task, enforced through
  [AGENTS.md](../../AGENTS.md), `.github/copilot-instructions.md`, and the `/document-sync` skill.
- Repository memory may hold small, non-obvious, non-sensitive facts. It may never hold
  architecture, requirements, plans, task state, or secrets.
- The project must remain fully workable for a contributor with AI memory disabled.

## Alternatives Considered

- **Rely on the assistant's repository memory.** Zero effort. Rejected: machine-local, invisible to
  review, unversioned, and unavailable to human contributors.
- **Documentation only when a feature is finished.** Conventional. Rejected because this project's
  work is routinely interrupted mid-task; a plan that is only accurate at completion cannot rescue
  an abandoned session.
- **Auto-generate context from the codebase on demand.** Attractive, but it cannot recover *why* a
  decision was made, which is the knowledge most expensive to lose.

## Consequences

### Positive

- Any fresh chat, or any human, can reconstruct the project from the repository alone.
- Decisions and their reasoning survive in reviewable, diffable form.
- Interrupted work can be resumed from a checkpoint rather than restarted.

### Negative

- Real ongoing effort: every meaningful change carries a documentation obligation.
- Documentation can drift and become confidently wrong, which is worse than absent — hence the
  standing requirement to verify claims against the filesystem.
- Some duplication between documents is unavoidable; the policy file exists to keep it minimal.

## Related Code / Documentation

- [AGENTS.md](../../AGENTS.md)
- [docs/ai/CONTEXT.md](../ai/CONTEXT.md)
- [docs/ai/DOCUMENTATION_POLICY.md](../ai/DOCUMENTATION_POLICY.md)
- [docs/ai/SETUP.md](../ai/SETUP.md)
- `.github/copilot-instructions.md`, `.github/skills/`, `.github/hooks/`

# Copilot Instructions — Buzzly

This is a **context router**. The details live in the linked files; read them rather than assuming.

## Source of Truth

Git-tracked documentation is this project's durable memory. Chat history and AI memory are not.
Follow the engineering contract in [AGENTS.md](../AGENTS.md).

## Before Substantial Work

1. [docs/ai/CONTEXT.md](../docs/ai/CONTEXT.md) — navigation map, stack, layout, invariants
2. [docs/PROJECT_STATE.md](../docs/PROJECT_STATE.md) — what is actually true right now
3. [ARCHITECTURE.md](../ARCHITECTURE.md) and [PRODUCT.md](../PRODUCT.md) — when touching structure
   or product behaviour
4. [docs/adr/](../docs/adr/) — relevant decisions and their reasoning
5. [docs/plans/active/](../docs/plans/active/) — in-flight work and its checkpoint

Then search the actual source and tests. Run `/resume` to do all of this at once.

## Critical Standing Facts

- **This repository has no application code yet.** No manifests, no build system, no tests. Verify
  on disk before claiming any command, path, or dependency exists.
- `ARCHITECTURE.md` describes a **planned** system. Never present planned work as built.
- Six product invariants must not be broken — see [AGENTS.md](../AGENTS.md) section 4. The most
  important: the AI mentor never emits a working solution, and untrusted code never runs unsandboxed
  on a server.

## Documentation Synchronization Is Mandatory

After every request, check the actual diff for documentation impact. If behaviour, architecture,
APIs, schema, dependencies, configuration, commands, deployment, security assumptions, layout,
conventions, project state, or plan progress changed, update the owning document **in the same
task** — see [docs/ai/DOCUMENTATION_POLICY.md](../docs/ai/DOCUMENTATION_POLICY.md).

[docs/ai/CONTEXT.md](../docs/ai/CONTEXT.md) must be updated whenever it would otherwise become
inaccurate. Run `/document-sync` to perform the pass, `/checkpoint` before ending unfinished work.

Do not edit documentation when nothing durable changed.

End meaningful coding responses with either `Documentation: updated <files>` or
`Documentation: no durable documentation impact`.

## Memory

Repository memory is supplementary only: small, non-obvious, non-sensitive facts. Architecture,
requirements, plans, and task state belong in `docs/`. Never store secrets or credentials.

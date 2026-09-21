# Architecture Decision Records

An ADR records a decision that future engineers would otherwise have to reverse-engineer — and, more
importantly, the reasoning and the alternatives that were rejected.

## When to Write One

Write an ADR for decisions that are expensive to reverse or easy to misunderstand later:

- choosing or replacing a database, cache, or queue
- choosing or replacing a framework, language, or runtime
- adding a major dependency the whole project leans on
- establishing or moving a module or service boundary
- changing the authentication or authorisation strategy
- changing how learner code is executed or sandboxed
- changing how the AI mentor is constrained
- changing the deployment architecture
- adopting a cross-cutting pattern that new code is expected to follow

Do **not** write an ADR for routine implementation choices, naming, refactors, or anything a code
comment explains adequately.

Every open decision listed in [../PROJECT_STATE.md](../PROJECT_STATE.md) becomes an ADR when it is
resolved.

## Process

1. Copy the template below to `docs/adr/NNNN-short-kebab-title.md`, using the next free number.
2. Open it as `Proposed` while it is under discussion.
3. Set it to `Accepted` once agreed. Record the date.
4. Never rewrite the history of an accepted ADR. To reverse a decision, write a new ADR and mark the
   old one `Superseded by ADR-NNNN`.
5. Link the ADR from the code or documentation it governs, and from
   [../PROJECT_STATE.md](../PROJECT_STATE.md) if it changes current state.

## Status Values

| Status | Meaning |
| --- | --- |
| `Proposed` | Under discussion, not binding |
| `Accepted` | Binding; code is expected to follow it |
| `Superseded` | Replaced by a later ADR, which must be named |
| `Deprecated` | No longer applies, with no direct replacement |

## Template

```markdown
# ADR-NNNN: Title

Status: Proposed | Accepted | Superseded | Deprecated
Date: YYYY-MM-DD

## Context
What forced a decision. Constraints, pressures, and what was true at the time.

## Decision
What was decided, stated plainly.

## Alternatives Considered
What else was on the table and why it lost.

## Consequences

### Positive

### Negative

## Related Code / Documentation
```

## Index

| ADR | Title | Status |
| --- | --- | --- |
| [0001](./0001-monorepo-next-web-fastapi-api.md) | Monorepo with a Next.js web app and a FastAPI API | Accepted |
| [0002](./0002-postgres-primary-redis-ephemeral.md) | PostgreSQL for durable state, Redis for ephemeral state | Accepted |
| [0003](./0003-browser-first-code-execution.md) | Run learner code in the browser first | Accepted |
| [0004](./0004-ai-mentor-never-emits-solutions.md) | The AI mentor never emits a working solution | Accepted |
| [0005](./0005-git-tracked-ai-context.md) | Git-tracked documentation is the durable AI context | Accepted |
| [0006](./0006-lazy-engineering-discipline.md) | Lazy-senior engineering discipline | Accepted |
| [0007](./0007-cognito-identity-stateless-jwt.md) | AWS Cognito owns identity, verified statelessly by the API | Accepted |
| [0008](./0008-stage-0-toolchain.md) | Stage 0 toolchain | Accepted |

Keep this index current when adding or superseding an ADR.

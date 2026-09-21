# ADR-0001: Monorepo with a Next.js web app and a FastAPI API

Status: Accepted
Date: 2026-08-30

## Context

Buzzly needs a rich interactive frontend (Monaco editor, live lesson player, realtime duel screens)
and a backend that will do content serving, progress tracking, AI mentor mediation, and WebSocket
game state.

The project is starting from an empty repository with a single maintainer. Two forces dominate:
frontend interactivity favours the React/Next.js ecosystem, while the AI, content-processing, and
future code-execution work sits more naturally in Python.

A boundary question follows immediately: Next.js can talk to a database directly from server
components and route handlers, so "where does persistence live" must be answered deliberately rather
than by accident.

## Decision

- One repository containing both applications: `apps/web` (Next.js, App Router, TypeScript) and
  `apps/api` (FastAPI).
- **`apps/api` is the sole owner of persistence.** It holds the only credentials for PostgreSQL and
  Redis.
- **`apps/web` never opens a database or cache connection**, from the browser or from its server
  runtime. Everything goes through the API over HTTP and WebSocket.

## Alternatives Considered

- **Next.js full-stack, no separate API.** Fewer moving parts and one language. Rejected because the
  AI mentor guardrails, content tooling, and the eventual sandboxed code runner are substantially
  better served by Python, and retrofitting a second backend later is more disruptive than starting
  with the split.
- **Two separate repositories.** Cleaner deployment isolation. Rejected because a single maintainer
  coordinating shared types, content formats, and lockstep changes across two repos pays a constant
  tax for a benefit that only matters at team scale.
- **Allowing the Next.js server layer to read the database for simple queries.** Tempting for
  latency. Rejected because two components owning the schema is the fastest way to lose control of
  it, and it would put database credentials in the app most exposed to the internet.

## Consequences

### Positive

- Each application uses the ecosystem it is strongest in.
- One schema owner means migrations, authorisation, and validation live in exactly one place.
- The web app can be deployed to an edge/static host without carrying database secrets.
- Shared code and content stay reviewable in one pull request.

### Negative

- Two runtimes and two package ecosystems to install, lint, test, and deploy.
- Every frontend data need requires an API endpoint; no shortcut for a one-off query.
- Type safety across the boundary is not automatic and needs deliberate effort.
- Monorepo tooling (task runner, package manager) is now an open decision.

## Related Code / Documentation

- [ARCHITECTURE.md](../../ARCHITECTURE.md)
- [docs/ai/CONTEXT.md](../ai/CONTEXT.md)
- [docs/plans/archive/0001-stage-0-foundation.md](../plans/archive/0001-stage-0-foundation.md)
- No code exists yet.

# Stage 0 — Foundation

Status: Complete
Related issue / PR: none
Stage: 0 (see [README.md](../../../README.md))

## Scope Change During Implementation

The original plan required implementing registration, login and sessions directly. Partway in, the
maintainer chose **AWS Cognito** as the identity provider, which makes that work unnecessary rather
than easier — see [ADR-0007](../../adr/0007-cognito-identity-stateless-jwt.md).

Authentication was therefore removed from Stage 0 and moved to its own follow-up plan. What Stage 0
kept is the part the decision depends on: a `users` table keyed on the Cognito `sub`, with no
credential columns.

## Objective

Turn an empty repository into a working development environment: a monorepo where a Next.js web app
and a FastAPI API both start, backed by PostgreSQL and Redis running locally, with database
migrations, working authentication, and CI. Stage 1 cannot begin until a developer can clone the
repository and run the whole system with a documented command.

## Requirements

- `apps/web` and `apps/api` both start locally from documented commands.
- PostgreSQL and Redis run locally via containers.
- A migration tool is in place with an initial schema.
- A user can register, log in, and hold a session.
- An authenticated user reaches an empty dashboard.
- CI runs lint, type check, and tests on every push.
- `CONTRIBUTING.md` and [docs/ai/CONTEXT.md](../../ai/CONTEXT.md) contain the real, verified
  commands.

## Non-goals

- No lesson content, code editor, or code execution — that is Stage 1.
- No AI mentor — Stage 2.
- No XP, streaks, or profiles — Stage 3.
- No multiplayer or server-side code execution — Stage 4.
- No production deployment; local development only.

## Relevant Existing Architecture

Nothing is implemented. The target is described in [ARCHITECTURE.md](../../../ARCHITECTURE.md).

Binding decisions:

- [ADR-0001](../../adr/0001-monorepo-next-web-fastapi-api.md) — the API is the sole owner of
  persistence; `apps/web` must never receive database or Redis credentials.
- [ADR-0002](../../adr/0002-postgres-primary-redis-ephemeral.md) — PostgreSQL for durable state,
  Redis only for state that is safe to lose.

## Blocking Decisions

All resolved. Recorded in [ADR-0008](../../adr/0008-stage-0-toolchain.md) and
[ADR-0007](../../adr/0007-cognito-identity-stateless-jwt.md).

- [x] JS package manager and monorepo task runner — npm workspaces, no task runner
- [x] Python dependency manager for `apps/api` — `venv` + `pip` on Python 3.14
- [x] Database migration tool — Alembic
- [x] Test framework for `apps/web` — deferred to Stage 1
- [x] Test framework for `apps/api` — deferred to Stage 1
- [x] Session strategy and password hashing approach — neither needed; Cognito owns identity

## Relevant Files

None of these exist yet.

- `apps/web/` — Next.js application
- `apps/api/` — FastAPI application
- `infra/docker-compose.yml` — PostgreSQL and Redis for local development
- `.env.example` — placeholder configuration values, tracked
- `.github/workflows/ci.yml` — lint, type check, tests

## Implementation Strategy

Resolve the blocking decisions first; each one changes the shape of everything after it. Then work
outward from the data layer, because auth depends on the schema and the dashboard depends on auth.

1. Decide tooling, record ADRs.
2. Scaffold the monorepo and both applications so they start with placeholder pages/routes.
3. Add containers for PostgreSQL and Redis, plus `.env.example`.
4. Add migrations and the initial user schema.
5. Implement registration, login, and sessions in the API.
6. Wire the web app to the API; add layout, navigation, and an empty dashboard behind auth.
7. Add CI.
8. Replace the placeholder command sections in `CONTRIBUTING.md` and `docs/ai/CONTEXT.md` with
   commands that were actually run.

## Tasks

- [x] Resolve tooling decisions, record ADRs
- [x] Scaffold the monorepo (`package.json` workspaces) and both applications
- [x] PostgreSQL 18 and Redis 8 via `infra/docker-compose.yml`, with health checks
- [x] `apps/api/.env.example` plus settings through pydantic-settings
- [x] Alembic wired to app settings and metadata; initial `users` migration applied
- [x] `/health` round-tripping PostgreSQL and Redis
- [x] Landing page reporting live API health
- [x] CI running lint, format and type checks for both applications
- [x] Replace placeholder command sections in `CONTRIBUTING.md` and `docs/ai/CONTEXT.md`
- [ ] ~~Registration, login, sessions~~ — moved to the Cognito plan
- [ ] ~~Empty dashboard behind auth~~ — moved to the Cognito plan

## Testing / Verification Plan

Executed on 2026-09-08, all from a running local environment:

- `npm run db:up` → both containers healthy; PostgreSQL 18.6 and Redis 8 reachable from the host
- `npm run db:revision -- "create users table"` → generated, ruff post-write hooks ran
- `npm run db:migrate` → applied; `\d users` shows the unique index on `cognito_sub`
- `npm run dev:api` → `GET /health` returned `{"status":"ok"}` with HTTP 200
- CORS preflight from `http://localhost:3000` → `access-control-allow-origin` returned
- `npm run dev:web` → page rendered "foundation running / API, PostgreSQL and Redis all reachable"
- `npm run lint`, `npm run typecheck`, `npm run build` → all pass

**Not verified:** the CI workflow has never executed on GitHub, because nothing has been pushed.

## Documentation Impact

- [x] `docs/ai/CONTEXT.md` — repository map, stack versions, entry points, development commands
- [x] `docs/PROJECT_STATE.md` — stable functionality, open decisions, debt, runtime state
- [x] `ARCHITECTURE.md` — status banner, Cognito in the diagram, authentication section
- [x] `CONTRIBUTING.md` — prerequisites, setup, development, database, lint sections
- [x] `README.md` — Stage 0 marked done, auth line points at Cognito
- [x] `.github/instructions/{api,web}.instructions.md` — real conventions instead of "does not exist"
- [x] New ADRs: [0007](../../adr/0007-cognito-identity-stateless-jwt.md),
      [0008](../../adr/0008-stage-0-toolchain.md)

## Decisions Made During Implementation

- **Auth moved out of Stage 0** once Cognito was chosen (ADR-0007).
- **PostgreSQL published on host port 55432.** 5432 and 5433 were both occupied on the development
  machine; a host Postgres silently wins `localhost` and produces misleading auth errors.
- **Postgres 18 volume mount** must be `/var/lib/postgresql`, not `/var/lib/postgresql/data`, or the
  container exits on start.
- **`fastapi[standard-no-fastapi-cloud-cli]`** instead of `[standard]`, to keep `fastapi-cloud-cli`,
  `sentry-sdk` and telemetry packages out of the tree.
- **Alembic post-write hooks** run ruff on generated migrations so they never fail our own lint.
- **ESLint stays on 9.** ESLint 10 breaks `eslint-plugin-react` in the Next config chain.
- **`agentRules: false`** in `next.config.ts`; Next 16 otherwise regenerates `apps/web/AGENTS.md`
  and `CLAUDE.md` on every dev start.
- **Removed** the generated `apps/web/.gitignore`, `README.md`, and unused template SVGs rather than
  keeping duplicated or dead files.

## Current Checkpoint

Updated: 2026-09-08

**Completed:** All of Stage 0 as re-scoped. Both applications build and run against local PostgreSQL
and Redis; migrations apply; lint, format and type checks pass on both sides; CI is defined.

**Remaining:** Nothing in this plan. Authentication continues in
[0002-aws-cognito-auth.md](./0002-aws-cognito-auth.md).

**Exact current state:** `apps/web` (Next 16.3.4) serves a landing page reporting API health.
`apps/api` (FastAPI 0.141.1, Python 3.14) serves `/health`. One Alembic revision
(`327740066352`) creates `users`. Datastores run from `infra/docker-compose.yml`.

**Tests actually run:** no test framework exists. Verification was the manual sequence above.

**Failures / blockers:** none. CI is unproven until a push happens.

**Next recommended action:** Archive this plan and begin the Cognito plan.


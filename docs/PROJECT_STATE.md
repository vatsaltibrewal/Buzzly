# Current Project State

Describes the project **as it is right now**. Not a changelog and not a roadmap — the roadmap lives
in [README.md](../README.md), history lives in Git.

Last verified against the repository: 2026-09-08.

## Stable Functionality

Stage 0 is complete. Verified working locally:

- **Monorepo** — npm workspaces with `apps/web` and `apps/api`; root scripts drive both.
- **Web** — Next.js 16.3.4 builds and serves a landing page that reports live API health.
- **API** — FastAPI 0.141.1 serves `/health`, which round-trips PostgreSQL and Redis and returns
  200.
- **Datastores** — PostgreSQL 18 and Redis 8 run via `infra/docker-compose.yml` with health checks.
- **Migrations** — Alembic applies one revision creating `users`, keyed on the Cognito `sub` with a
  unique index.
- **Quality gates** — ESLint (no warnings allowed), `tsc`, ruff (check + format), and mypy strict all
  pass. GitHub Actions runs them on push and pull request.

No product feature exists yet: no authentication, lessons, editor, mentor, or multiplayer.

## Work In Progress

Nothing in flight. The next task is AWS Cognito sign-up and login — decided in
[ADR-0007](./adr/0007-cognito-identity-stateless-jwt.md), not yet designed in detail or built.

## Open Decisions

| Decision | Why it matters |
| --- | --- |
| Cognito token type sent to the API (access vs ID), expiry, and JWKS caching | Shapes the auth dependency and its failure modes |
| Local-development story for Cognito | Whether contributors need a real user pool to run the app |
| Test frameworks for web and API | Must be resolved before Stage 1 logic lands |
| First language taught (Python or JavaScript) | Determines the Stage 1 module and browser runtime |
| LLM provider for the mentor | Affects cost, latency, and the guardrail layer |
| Hosting and deployment target | Nothing is deployed or containerised for production |

Resolved since the last update: JS package manager, monorepo task runner, Python dependency manager,
migration tool, and session strategy — see [ADR-0008](./adr/0008-stage-0-toolchain.md) and
[ADR-0007](./adr/0007-cognito-identity-stateless-jwt.md).

## Known Limitations

- No authentication. Every endpoint is currently public; there is exactly one, and it is a health
  check.
- No tests and no test framework.
- Nothing is containerised for production — Docker Compose covers datastores only.
- The web app talks to the API over a hard-coded default of `http://localhost:8000` unless
  `NEXT_PUBLIC_API_URL` is set.

## Known Technical Debt

- **ESLint 9 is past its supported life.** ESLint 10 was attempted and fails: `eslint-plugin-react`
  throws `contextOrFilename.getFilename is not a function` inside the Next config chain, even though
  `eslint-config-next@16.3.4` declares `eslint: ">=9.0.0"`. Revisit when that chain supports 10.
- **The venv path `.venv/bin/...` is hard-coded** in root npm scripts, so they assume macOS/Linux.
- **`app/db.py` builds its engine at import time**, so importing it without a valid `DATABASE_URL`
  raises. Fine today; worth revisiting when tests arrive.

## Current Deployment / Runtime State

Nothing is deployed. No staging or production environment, no production image, no infrastructure
beyond local Docker Compose.

Local runtime: PostgreSQL 18 on host port **55432** (not 5432 — that port is commonly taken), Redis 8
on 6379, API on 8000, web on 3000.

## Recently Accepted Decisions

- [ADR-0001](./adr/0001-monorepo-next-web-fastapi-api.md) — monorepo with a Next.js web app and a
  FastAPI API that solely owns persistence.
- [ADR-0002](./adr/0002-postgres-primary-redis-ephemeral.md) — PostgreSQL for durable state, Redis
  strictly for losable state.
- [ADR-0003](./adr/0003-browser-first-code-execution.md) — run learner code in the browser first;
  defer the sandboxed server runner to Stage 4.
- [ADR-0004](./adr/0004-ai-mentor-never-emits-solutions.md) — the mentor must never output a working
  solution, enforced server-side.
- [ADR-0005](./adr/0005-git-tracked-ai-context.md) — Git-tracked documentation is the project's
  durable AI memory.
- [ADR-0006](./adr/0006-lazy-engineering-discipline.md) — lazy-senior engineering discipline.
- [ADR-0007](./adr/0007-cognito-identity-stateless-jwt.md) — AWS Cognito owns identity; the API
  verifies its tokens statelessly.
- [ADR-0008](./adr/0008-stage-0-toolchain.md) — Stage 0 toolchain.

## Next Major Work

1. **AWS Cognito sign-up and login.** Create the user pool, add OIDC login to the web app, add a
   token-verification dependency to the API, and provision a `users` row on first sign-in.
2. **Stage 1** — Monaco editor, in-browser execution, the first lesson module, and the test
   framework that has been deferred until there is logic worth testing.

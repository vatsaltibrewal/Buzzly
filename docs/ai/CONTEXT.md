# Project Context

Navigation map for AI agents and new contributors. Read this before any substantial work, then
follow the links for depth. This file is a map, not an encyclopedia.

## Reality Check — read this first

**Stage 0 is complete.** Both applications build and run locally against PostgreSQL and Redis,
migrations apply, and lint plus type checking pass on both sides.

What does **not** exist yet: authentication, lessons, the code editor, the AI mentor, multiplayer,
and any test suite. The API serves only `/health`; the web app serves only a landing page that
reports API health.

Stages 1–5 in [README.md](../../README.md) are plans. [ARCHITECTURE.md](../../ARCHITECTURE.md)
still describes components that have not been built — the mentor guardrail, the sandboxed runner,
duels. Never describe planned work as if it exists; verify against the filesystem first.

## Project Summary

Buzzly is an interactive environment for **learning to code by writing code**. It combines guided
lesson modules, standalone challenges, and real-time multiplayer coding battles with an AI mentor
that deliberately refuses to write solutions for the learner.

The product exists for people learning programming who want to build real problem-solving ability
rather than copy answers. Full product definition: [PRODUCT.md](../../PRODUCT.md).

## Technology Stack

Installed and verified working. Versions come from the manifests and lock files.

| Layer | Technology | Status |
| --- | --- | --- |
| Web frontend | Next.js 16.3.4 (App Router, Turbopack), React 19.2.8, TypeScript 5, Tailwind 4 | running |
| Backend API | FastAPI 0.141.1 on Python 3.14, Uvicorn | running |
| Database | PostgreSQL 18 via Docker, SQLAlchemy 2.0 async + psycopg 3 | running |
| Migrations | Alembic 1.19.2 | one revision applied |
| Cache / ephemeral state | Redis 8 via Docker | running |
| Identity | AWS Cognito, verified statelessly by the API | decided, not built |
| Package management | npm workspaces (Node 24); `venv` + `pip` for Python | running |
| Lint / types | ESLint 9 + `tsc`; ruff 0.16 + mypy strict | passing |
| Code editor UI | Monaco | not installed (Stage 1) |
| AI mentor | LLM provider behind a project-owned guardrail layer | provider undecided |
| Tests | none | deferred to Stage 1 |

Decisions behind these: [ADR-0008](../adr/0008-stage-0-toolchain.md) and
[ADR-0007](../adr/0007-cognito-identity-stateless-jwt.md).

## Repository Map

- `apps/web/` — Next.js app. Source in `src/app/`, `@/*` aliases `src/*`
- `apps/api/` — FastAPI app. `app/` holds the code, `migrations/` holds Alembic, `.venv/` the
  environment
- `infra/` — `docker-compose.yml` for local PostgreSQL and Redis
- `docs/` — project documentation; the durable memory of the project
- `docs/ai/` — how the AI-assisted workflow itself is configured
- `docs/adr/` — architecture decision records
- `docs/plans/` — multi-session implementation plans (`active/`, `archive/`)
- `.github/` — Copilot instructions, skills, agents, hooks, and the CI workflow
- `.vscode/` — workspace editor and MCP configuration

Not created yet: `packages/` (shared code) and `content/` (lesson files), both arriving with Stage 1.

## Architecture Summary

Two deployable applications over one database, split so the browser never touches persistence
directly. Learner code will execute **in the browser** for Stages 1–3; a sandboxed server-side runner
arrives only in Stage 4 where multiplayer fairness requires it.

Details and data flow: [ARCHITECTURE.md](../../ARCHITECTURE.md).

## Important Entry Points

- `apps/api/app/main.py` — FastAPI app, lifespan, CORS, `/health`
- `apps/api/app/config.py` — settings from environment; the only place env vars are read
- `apps/api/app/db.py` — async engine and the `get_session` dependency
- `apps/api/app/models/` — SQLAlchemy models; new models must be exported from `__init__.py`
- `apps/api/migrations/env.py` — Alembic wiring, reads the URL from settings
- `apps/web/src/app/layout.tsx` and `page.tsx` — root layout and landing page
- `infra/docker-compose.yml` — local datastores

## Development Commands

Run from the repository root. All of these were executed and verified on 2026-09-08.

| Command | Purpose |
| --- | --- |
| `npm install` | Install web dependencies (npm workspaces) |
| `npm run db:up` | Start PostgreSQL and Redis, waiting for health |
| `npm run db:down` | Stop them |
| `npm run db:migrate` | Apply Alembic migrations |
| `npm run db:revision -- "message"` | Autogenerate a migration (ruff runs on it automatically) |
| `npm run dev:api` | FastAPI dev server on <http://127.0.0.1:8000> |
| `npm run dev:web` | Next.js dev server on <http://localhost:3000> |
| `npm run build` | Production build of the web app |
| `npm run lint` / `npm run typecheck` | Both applications |
| `npm run lint:api` / `npm run typecheck:api` | ruff / mypy only |
| `npm run lint:web` / `npm run typecheck:web` | ESLint / tsc only |

First-time API setup, from `apps/api`:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -e ".[dev]"
cp .env.example .env
```

There is **no test command** — no test framework is installed. Do not invent one.

**PostgreSQL is published on host port 55432, not 5432.** Developer machines commonly already run
Postgres on 5432, which silently wins `localhost` and produces confusing authentication errors.

## Important Engineering Invariants

These are durable rules for this project. Breaking one requires a new ADR, not a code review comment.

1. **The AI mentor never emits a working solution.** It may give syntax fragments, questions,
   analogies, and error explanations. Solution-blocking must be enforced server-side on model
   output, not only in the prompt. See [ADR-0004](../adr/0004-ai-mentor-never-emits-solutions.md).
2. **Untrusted learner code never runs unsandboxed on a server.** Browser execution through Stage 3;
   any server-side execution must be isolated with CPU, memory, network, and wall-clock limits. See
   [ADR-0003](../adr/0003-browser-first-code-execution.md).
3. **The web app never connects to PostgreSQL or Redis directly.** All persistence goes through the
   FastAPI API. See [ADR-0001](../adr/0001-monorepo-next-web-fastapi-api.md).
4. **PostgreSQL owns durable state; Redis holds only data that is safe to lose.** See
   [ADR-0002](../adr/0002-postgres-primary-redis-ephemeral.md).
5. **Lesson and challenge content lives as reviewable files in Git**, not as rows entered through an
   admin UI.
6. **Secrets are never committed.** Environment values belong in ignored `.env` files;
   `apps/api/.env.example` is the tracked template.
7. **Credentials never enter our database.** AWS Cognito owns identity; `users` keys on the Cognito
   `sub` and deliberately has no email or password column. See
   [ADR-0007](../adr/0007-cognito-identity-stateless-jwt.md).

## Where Knowledge Lives

| Knowledge | Source of truth |
| --- | --- |
| Product purpose, users, domain concepts | [PRODUCT.md](../../PRODUCT.md) |
| System architecture, boundaries, data flow | [ARCHITECTURE.md](../../ARCHITECTURE.md) |
| Durable decisions and their reasoning | [docs/adr/](../adr/) |
| Current development state | [docs/PROJECT_STATE.md](../PROJECT_STATE.md) |
| In-flight multi-session work | [docs/plans/active/](../plans/active/) |
| Roadmap and stage definitions | [README.md](../../README.md) |
| Setup, workflow, contribution rules | [CONTRIBUTING.md](../../CONTRIBUTING.md) |
| How code should be written here | [.github/instructions/code.instructions.md](../../.github/instructions/code.instructions.md) |
| Which document owns which fact | [DOCUMENTATION_POLICY.md](./DOCUMENTATION_POLICY.md) |
| Enabling the AI workflow locally | [SETUP.md](./SETUP.md) |
| Agent engineering contract | [AGENTS.md](../../AGENTS.md) |
| Actual behavior | source code and tests (none yet) |
| Issue and review discussion | GitHub `vatsaltibrewal/Buzzly` |
| History | Git |

## Current Work

Repository state: [docs/PROJECT_STATE.md](../PROJECT_STATE.md).

Stage 0 is finished. The next task is wiring **AWS Cognito sign-up and login**, then Stage 1 (the
lesson player and in-browser code execution). Active plan:
[docs/plans/active/](../plans/active/).

## Known Risks and Constraints

- **Documentation drift.** Most of `ARCHITECTURE.md` still describes unbuilt components. Correct any
  mismatch you find in the same task.
- **No tests exist.** `/health` is currently the only end-to-end check, and it must keep failing
  loudly. Stage 1 has to add a real test framework before meaningful logic lands.
- **ESLint 9 is past end-of-life.** ESLint 10 was tried and breaks `eslint-plugin-react` in the Next
  config chain. Tracked in [docs/PROJECT_STATE.md](../PROJECT_STATE.md).
- **Cognito is undesigned in detail.** Token type, expiry, JWKS caching, and local-development
  strategy are all still open.
- **Stage 4 raises the security bar sharply.** Server-side execution of untrusted code is the
  highest-risk component in the roadmap and must not be built ad hoc.
- **AI mentor cost and abuse** are unmodelled. Rate limiting and cost tracking are explicit Stage 2
  requirements.

## Documentation Synchronization Rule

This file must describe the repository as it actually is. Update it in the **same task** whenever
any of the following change: repository layout, technology stack, entry points, development
commands, engineering invariants, where knowledge lives, or what work is currently active.

Rewrite stale sections rather than appending to them. Do not let this file grow into a changelog.

---
description: "Use when working in apps/api, the Buzzly FastAPI backend: auth, lesson content, progress, submissions, the AI mentor guardrail layer, WebSockets, PostgreSQL and Redis access."
applyTo: "apps/api/**"
---

# Buzzly API (`apps/api`)

FastAPI on Python 3.14, SQLAlchemy 2 (async) with psycopg 3, Alembic, Redis. The virtual environment
lives at `apps/api/.venv`; dependencies are declared in `pyproject.toml`.

Run things from the repository root: `npm run dev:api`, `npm run lint:api`, `npm run typecheck:api`,
`npm run db:migrate`, `npm run db:revision -- "message"`.

Only `/health` exists so far. Test tooling is deliberately deferred to Stage 1 — do not assume
`pytest` is available.

## Hard Rules

**This application solely owns persistence.** It holds the only PostgreSQL and Redis credentials in
the system. See [ADR-0001](../../docs/adr/0001-monorepo-next-web-fastapi-api.md).

**Classify every new piece of state by loss tolerance.** If losing it would corrupt a learner's
history or a competitive result, it goes in PostgreSQL. Redis holds only what can be rebuilt:
caches, sessions, matchmaking queues, live room state, rate-limit counters. Never let durable state
exist in Redis alone. See [ADR-0002](../../docs/adr/0002-postgres-primary-redis-ephemeral.md).

**The mentor guardrail is server-side and authoritative.** Every mentor response is checked here
before it reaches the client, and the check considers conversation history — not just the current
response — because solutions can be extracted across turns. The prompt is a first line of defence,
never the only one. See [ADR-0004](../../docs/adr/0004-ai-mentor-never-emits-solutions.md).

**Everything from the client is untrusted**, including reported test results. Validate at the
boundary. From Stage 4, competitive outcomes must come from the sandboxed runner, never from a
client claim.

**Never run untrusted learner code in the API process.** Timeouts are not isolation. Server-side
execution requires the Stage 4 sandbox and its own ADR before it is built.

## Practical Notes

- Rate limiting and cost tracking on mentor endpoints are requirements, not optimisations — a paid
  model sits behind them.
- Keep the model provider behind a project-owned interface so it can be swapped without touching
  endpoint logic.
- Schema changes go through migrations, never manual edits to a running database.
- Never log learner code, prompts, or model responses in a way that captures personal data or
  credentials.
- Secrets come from the environment. No keys in source, and no `.env` file committed.

## Established Conventions

Follow what Stage 0 set up rather than inventing alternatives:

- Settings come from `app.config.get_settings()` (pydantic-settings, cached). Never read `os.environ`
  directly.
- Database sessions come from the `get_session` dependency in `app.db`.
- Models subclass `Base` from `app.models.base` and use `Mapped[...]` / `mapped_column(...)`.
- Every new model must be imported in `app/models/__init__.py`, or Alembic autogenerate will not see
  it and will silently propose dropping nothing.
- Schema changes go through `npm run db:revision -- "message"`, never a hand-written table edit.
- `mypy` runs in strict mode and `ruff` enforces the `S` (security) rules. Fix the cause rather than
  adding a blanket ignore.

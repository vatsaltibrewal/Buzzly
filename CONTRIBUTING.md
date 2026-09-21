# Contributing to Buzzly

## Current Reality

Stage 0 is complete: both applications run locally against PostgreSQL and Redis, migrations apply,
and lint plus type checking pass. There is **no authentication and no product feature yet** — the API
serves only `/health`.

There is also **no test framework**; it is deliberately deferred to Stage 1. Do not add commands to
this guide that you have not run yourself.

Current state: [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md).
Roadmap: [README.md](./README.md).

## Prerequisites

Verified with Node 24, npm 12, Python 3.14 and Docker 29. Anything materially older is untested.

## Getting the Repository

```bash
git clone git@github.com:vatsaltibrewal/Buzzly.git
cd Buzzly
```

Open the folder at its root in VS Code so that workspace instructions, skills, and hooks load.
AI-assisted workflow setup: [docs/ai/SETUP.md](./docs/ai/SETUP.md).

## Setup

```bash
# Web dependencies (npm workspaces)
npm install

# API environment
cd apps/api
python3 -m venv .venv
.venv/bin/python -m pip install -e ".[dev]"
cp .env.example .env
cd ../..

# Local PostgreSQL and Redis, then the schema
npm run db:up
npm run db:migrate
```

PostgreSQL is published on host port **55432**, not 5432, because a locally installed Postgres
commonly occupies 5432 and silently wins `localhost`.

## Development

Two terminals:

```bash
npm run dev:api   # http://127.0.0.1:8000  (docs at /docs)
npm run dev:web   # http://localhost:3000
```

The landing page shows green when the API, PostgreSQL and Redis are all reachable.

## Database

```bash
npm run db:up                        # start datastores, wait for health
npm run db:down                      # stop them
npm run db:migrate                   # apply migrations
npm run db:revision -- "add streaks" # autogenerate a migration
```

A new model is only picked up by autogenerate if it is imported in `apps/api/app/models/__init__.py`.
Generated migrations are linted and formatted automatically, then **must be read before committing**
— autogenerate guesses, it does not think.

## Lint, Format, Type Check

```bash
npm run lint        # ESLint + ruff
npm run typecheck   # tsc + mypy (strict)
npm run format:api  # ruff format
npm run build       # production build of the web app
```

CI runs exactly these on every push and pull request. ESLint runs with `--max-warnings 0`.

## Tests

None yet, by decision — see [ADR-0008](./docs/adr/0008-stage-0-toolchain.md). Stage 1 introduces a
test framework before any real logic lands. Until then, the project's one-check rule is served by
`/health`, which fails loudly if a datastore is unreachable.

## Before You Start Non-Trivial Work

1. Read [docs/ai/CONTEXT.md](./docs/ai/CONTEXT.md) and
   [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md).
2. Check whether a plan already exists in [docs/plans/active/](./docs/plans/active/).
3. If the work spans multiple sessions, create a plan from
   [docs/plans/TEMPLATE.md](./docs/plans/TEMPLATE.md) and keep it updated as you go.

## Making Architectural Decisions

Choosing a database, a framework, an auth strategy, a module boundary, a deployment model, or any
major dependency requires an Architecture Decision Record. Process and template:
[docs/adr/README.md](./docs/adr/README.md).

Do not resolve one of the open decisions in
[docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md) inside a pull request without an accompanying ADR.

## Documentation Expectations

Documentation is part of the change, not a follow-up. If your change affects behaviour,
architecture, APIs, schema, dependencies, configuration, commands, deployment, security assumptions,
repository layout, or project state, update the owning document in the same pull request.

Which document owns which fact:
[docs/ai/DOCUMENTATION_POLICY.md](./docs/ai/DOCUMENTATION_POLICY.md).

A pull request that changes how the project is built, run, or tested and leaves `CONTRIBUTING.md`
or [docs/ai/CONTEXT.md](./docs/ai/CONTEXT.md) stale is incomplete.

## Product Rules That Constrain Contributions

Some features are permanently out of scope because they defeat the point of the product — most
importantly, anything that gives a learner a working solution. Read the invariants in
[AGENTS.md](./AGENTS.md) and the product rules in [PRODUCT.md](./PRODUCT.md) before proposing
mentor, execution, or multiplayer features.

## Pull Requests

- Keep changes focused; separate refactors from behaviour changes.
- Explain *why*, not just *what*.
- Link the ADR or plan the change belongs to.
- Prefer the smallest change that works: reuse what exists, lean on the standard library, and delete
  rather than add. The full discipline is in
  [.github/instructions/code.instructions.md](./.github/instructions/code.instructions.md).
- Never commit secrets or `.env` files. Configuration examples belong in tracked `.env.example`
  files with placeholder values only.

## Security

Report anything that looks like a leaked credential in the repository history rather than quietly
deleting it — rotation matters more than removal. Do not weaken sandboxing, rate limiting, or
authentication to unblock a feature.

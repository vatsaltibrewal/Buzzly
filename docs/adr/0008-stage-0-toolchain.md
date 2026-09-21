# ADR-0008: Stage 0 toolchain

Status: Accepted
Date: 2026-09-08

## Context

Stage 0 could not begin until six tooling questions were settled: the JavaScript package manager,
whether to add a monorepo task runner, the Python dependency manager, the migration tool, the test
frameworks, and the session strategy. Each shapes the repository layout and every command that
follows, so guessing would have caused rework across both applications.

## Decision

| Concern | Choice |
| --- | --- |
| JS package manager | **npm workspaces** (npm 12, Node 24) |
| Monorepo task runner | **none** — root npm scripts are the single entry point |
| Python environment | **`venv` + `pip`** on **Python 3.14**, at `apps/api/.venv` |
| Python manifest | **`pyproject.toml`** with a setuptools backend, installed editable |
| ORM and migrations | **SQLAlchemy 2 async** with **psycopg 3** and **Alembic** |
| Python lint / format / types | **ruff** and **mypy strict** |
| Web lint / types | **ESLint 9** with `eslint-config-next`, and `tsc --noEmit` |
| Test frameworks | **deferred** to Stage 1 |
| Local datastores | **Docker Compose**: Postgres 18, Redis 8 |

Supporting details worth keeping:

- Root `package.json` scripts wrap the Python commands too, so `npm run …` is the one interface for
  both applications.
- FastAPI is installed via the `standard-no-fastapi-cloud-cli` extra, which keeps `fastapi-cloud-cli`,
  `sentry-sdk` and telemetry packages out of the dependency tree.
- Alembic runs `ruff check --fix` and `ruff format` as post-write hooks, so generated migrations
  never fail the repository's own lint step.
- Postgres is published on host port **55432**, not 5432. See the note in
  `infra/docker-compose.yml`.

## Alternatives Considered

- **pnpm instead of npm.** Faster and stricter, and already installed. The maintainer chose npm;
  with two workspaces the difference is small.
- **`uv` instead of `venv` + `pip`.** FastAPI's own documentation now leads with `uv`, and it is
  considerably faster. Rejected because it is another tool to install; `venv` ships with Python.
  Worth revisiting if install time becomes painful.
- **Turborepo.** Caching and task orchestration. Rejected as premature: two apps in two languages
  with fast builds gain almost nothing today, and it can be added later without restructuring.
- **Test frameworks now.** Rejected because Stage 0 is configuration, not logic. The project's
  one-check rule asks for a check when there is logic to protect; `/health` currently serves that
  role by failing loudly.
- **ESLint 10.** Verified as broken: `eslint-plugin-react` in the Next config chain throws
  `contextOrFilename.getFilename is not a function`, despite `eslint-config-next` declaring
  `eslint: ">=9.0.0"`. Staying on 9 until the plugin chain catches up.

## Consequences

### Positive

- One command surface (`npm run …`) across two language ecosystems.
- No tool needs installing beyond Node, Python and Docker.
- Generated migrations are lint-clean automatically.
- Strict typing on both sides from the first commit, while the codebase is small enough to keep it.

### Negative

- ESLint 9 is past its supported life; this is tracked debt, not a preference.
- `pip` resolution is slower than `uv`, and the venv path is hard-coded in root scripts.
- Wrapping Python commands in `package.json` is unusual and mildly surprising.
- Postgres on a non-default port will occasionally confuse tooling that assumes 5432.
- Deferring tests means Stage 1 must add them before real logic lands.

## Related Code / Documentation

- `package.json`, `apps/api/pyproject.toml`, `apps/web/package.json`
- `infra/docker-compose.yml`, `.github/workflows/ci.yml`
- [CONTRIBUTING.md](../../CONTRIBUTING.md) — the resulting commands
- [docs/plans/archive/0001-stage-0-foundation.md](../plans/archive/0001-stage-0-foundation.md)

# ADR-0002: PostgreSQL for durable state, Redis for ephemeral state

Status: Accepted
Date: 2026-08-30

## Context

Buzzly stores two very different kinds of data.

Some of it must never be lost: accounts, lesson progress, submissions, XP, streaks, duel results and
ratings. This data is relational — learners have submissions, submissions belong to lessons, duels
reference two players — and correctness matters more than raw speed.

The rest is short-lived and high-churn: matchmaking queues, live room membership, per-request rate
limit counters, cached content. Losing it costs a player one interrupted match, not their account.

Storing both in the same system means either paying durability costs for throwaway data or risking
durable data in a store that was not chosen for it.

## Decision

- **PostgreSQL is the single source of truth** for all durable state.
- **Redis holds only data that can be lost without harm**: caches, sessions, matchmaking queues,
  live room state, and rate-limit counters.
- Nothing may live in Redis alone if its loss would corrupt a learner's history or a competitive
  outcome. If it matters, it is written to PostgreSQL.

## Alternatives Considered

- **PostgreSQL only, no Redis.** One fewer service to run. Rejected for Stage 4: matchmaking and
  live room state are high-frequency, short-lived writes that would add avoidable load to the
  primary database. Redis is not needed before then, so it may be introduced late.
- **A document database as the primary store.** Rejected because the core domain is plainly
  relational and the schema is expected to change often early on, which is exactly where
  migrations and constraints earn their keep.
- **Redis as a durable store with persistence enabled.** Rejected: durability configuration is easy
  to get subtly wrong, and it would blur the line this ADR exists to draw.

## Consequences

### Positive

- One obvious answer to "where does this belong", decided by loss tolerance.
- A Redis outage degrades multiplayer and caching without endangering learner data.
- Relational integrity for the domain that needs it.

### Negative

- Two datastores to run, monitor, and back up.
- Some state must be written twice (live duel state in Redis, final result in PostgreSQL).
- Developers must consciously classify every new piece of state.

## Related Code / Documentation

- [ARCHITECTURE.md](../../ARCHITECTURE.md) — storage table and invariants
- [ADR-0001](./0001-monorepo-next-web-fastapi-api.md) — the API owns both connections
- No schema or migrations exist yet; the migration tool is an open decision in
  [docs/PROJECT_STATE.md](../PROJECT_STATE.md).

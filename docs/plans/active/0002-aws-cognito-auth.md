# AWS Cognito sign-up and login

Status: Not started
Related issue / PR: none
Stage: 0.5 — bridges Stage 0 and Stage 1

## Objective

Let a person create a Buzzly account and sign in, using AWS Cognito as the identity provider, so
that Stage 1 has a real learner to attach progress to. Buzzly must never store credentials.

## Requirements

- A Cognito user pool with an app client configured for Authorization Code + PKCE.
- Sign-up, sign-in and sign-out working from the web app.
- The API verifies Cognito tokens against the pool's JWKS and rejects invalid, expired, or
  wrong-audience tokens.
- A `users` row is created on first successful sign-in, keyed on the `sub` claim.
- A `GET /me` endpoint returning the current learner, usable as the auth smoke test.
- A route in the web app that is only reachable when signed in.

## Non-goals

- No roles, permissions, or admin users yet.
- No social/federated identity providers.
- No custom-built login form if Managed Login is adequate.
- No lesson or progress features — that is Stage 1.

## Relevant Existing Architecture

- [ADR-0007](../../adr/0007-cognito-identity-stateless-jwt.md) — the binding decision.
- `apps/api/app/models/user.py` already keys on `cognito_sub` with no credential columns. Keep it
  that way: email and profile data stay in Cognito.
- [ADR-0001](../../adr/0001-monorepo-next-web-fastapi-api.md) — the web app must not gain database
  access as part of this work.

## Open Questions

Resolve these before writing code; each changes the implementation.

- [ ] Send the **access token** or the **ID token** to the API? Access token is the usual answer for
      authorising an API; the ID token is for describing the user to the client.
- [ ] Token lifetime, and whether the web app refreshes silently.
- [ ] Where the token lives in the browser — memory, cookie, or Next.js server-side session.
- [ ] How local development authenticates: a shared dev user pool, or per-developer pools?
- [ ] Which library verifies JWTs in Python. `PyJWT` with `PyJWKClient` is the boring candidate; it
      is **not currently a dependency**, so adding it needs justification.

## Implementation Strategy

1. Create the user pool and app client; record the non-secret configuration in `.env.example`.
2. Add the token-verification dependency in the API, with JWKS caching, and `GET /me`.
3. Add sign-in/sign-out to the web app and a protected route.
4. Provision the `users` row on first sign-in.

## Testing / Verification Plan

A test framework must be chosen here or in Stage 1 — auth is the first logic worth protecting, and
the project's one-check rule applies. At minimum, verify by hand:

- an unauthenticated request to `/me` is rejected
- a valid token returns the learner and creates exactly one `users` row
- a tampered or expired token is rejected

## Documentation Impact

- [ ] `ARCHITECTURE.md` — replace "decided, not built" in the authentication section
- [ ] `docs/PROJECT_STATE.md` — stable functionality, open decisions
- [ ] `docs/ai/CONTEXT.md` — entry points, invariants, commands if any change
- [ ] `CONTRIBUTING.md` — how a contributor authenticates locally
- [ ] A new ADR if any open question above is answered in a durable way

## Decisions Made During Implementation

None yet.

## Current Checkpoint

Updated: 2026-09-08

**Completed:** Nothing. The schema groundwork landed in Stage 0.

**Remaining:** All of it.

**Exact current state:** No authentication code exists. No AWS resources have been created. The
`aws` CLI is not installed on the development machine.

**Tests actually run:** none.

**Failures / blockers:** the open questions above, and the fact that no Cognito user pool exists
yet. Creating AWS resources needs the maintainer.

**Next recommended action:** Settle the open questions with the maintainer, then create the user
pool before writing code.

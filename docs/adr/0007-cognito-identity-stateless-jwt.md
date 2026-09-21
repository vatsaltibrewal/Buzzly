# ADR-0007: AWS Cognito owns identity, verified statelessly by the API

Status: Accepted
Date: 2026-09-08

Implementation status: **decided, not yet built.** No authentication code exists. The `users` table
created in Stage 0 already reflects this decision.

## Context

Buzzly needs sign-up and login. Building that in-house means owning password hashing, reset flows,
email verification, MFA, lockout policy, session rotation, and breach response — a large amount of
security-critical work that is not what this product is about.

Stage 0 originally planned to implement registration, login and sessions directly. Adopting a
managed identity provider makes that work unnecessary rather than merely easier, so the decision had
to be taken before the schema was written.

Two integration shapes were available once Cognito was chosen: let the API verify Cognito's tokens
on each request, or exchange a Cognito token once for a session the API itself owns.

## Decision

- **AWS Cognito is the identity provider.** It owns credentials, sign-up, login, and account
  recovery. Buzzly stores no passwords.
- **The browser performs OIDC Authorization Code with PKCE** against Cognito Managed Login and sends
  the resulting token to the API on each request.
- **The API verifies tokens statelessly** against Cognito's JWKS. No server-side session store, no
  refresh-token rotation owned by us.
- **`users` keys on the Cognito `sub` claim** and stores only application data. It deliberately has
  no email or password column, so the application database never becomes a credential or PII target.
- The web app never calls Cognito's admin APIs and holds no Cognito secrets beyond public client
  configuration.

## Alternatives Considered

- **Own the whole auth stack.** Full control, no vendor coupling. Rejected: it is the highest
  security risk per unit of product value in the entire roadmap, and a single mistake is a breach.
- **API issues its own session cookie after a Cognito login.** Gives cookie-based sessions and easy
  revocation. Rejected for now: it reintroduces session storage, expiry and rotation — the exact
  work Cognito was adopted to avoid. Revisit if instant revocation becomes a requirement.
- **A different managed provider (Auth0, Clerk, Supabase Auth).** Comparable and in some cases
  nicer to integrate. Cognito was chosen by the maintainer; the verification layer is standard OIDC
  so a change would be contained.

## Consequences

### Positive

- No password, reset, or MFA code to write, review, or breach.
- No session table and no refresh rotation logic.
- Stateless verification scales horizontally with no shared session state.
- Minimal PII in our database.

### Negative

- A hard dependency on AWS availability and pricing for login.
- Stateless tokens cannot be revoked before expiry; short token lifetimes are the mitigation.
- Local development needs a real Cognito user pool or a deliberate stand-in.
- Cognito's hosted UI constrains branding compared with a fully custom login screen.
- Every request pays JWKS verification, so the key set must be cached.

## Related Code / Documentation

- [ARCHITECTURE.md](../../ARCHITECTURE.md) — authentication section
- `apps/api/app/models/user.py` — `cognito_sub`, no credential columns
- `apps/api/migrations/versions/327740066352_create_users_table.py`
- [docs/plans/archive/0001-stage-0-foundation.md](../plans/archive/0001-stage-0-foundation.md)
- No authentication code exists yet.

# Buzzly

An interactive place to **learn coding by actually coding** — with lessons, games, multiplayer battles, and an AI mentor that guides you instead of solving things for you.

---

## The Idea

Most learning sites either show you videos or hand you the answer. Buzzly does neither.

- **You write the code.** Always. The AI never writes the solution for you.
- **The AI asks, you think.** It nudges with questions, hints at syntax, points out what you missed, and helps you break a problem into steps.
- **Learning feels like play.** Modules, challenges, streaks, and live battles against other people.

**Core rule of the product:** the AI is a *helping hand*, not a *ghostwriter*. Logic, structure, and thinking stay with the user.

---

## Tech Stack

| Layer | Choice |
| --- | --- |
| Frontend | Next.js 16 (App Router) + TypeScript + Tailwind 4 |
| Editor | Monaco (the same editor as VS Code) |
| Backend | FastAPI (Python 3.14) |
| Database | PostgreSQL 18 |
| Cache / realtime state | Redis 8 |
| Realtime | WebSockets (FastAPI) |
| Auth | AWS Cognito, verified as JWTs by the API |
| AI | LLM API behind our own prompt layer |
| Repo | Monorepo (this repo), npm workspaces |

---

## Planned Structure

```
buzzly/
├─ apps/
│  ├─ web/          # Next.js app (UI, editor, lessons, game rooms)
│  └─ api/          # FastAPI app (auth, content, progress, AI, realtime)
├─ packages/
│  ├─ ui/           # shared React components
│  └─ shared/       # shared types, API client, constants
├─ content/         # lessons and challenges as files, versioned in git
├─ infra/           # docker-compose, Dockerfiles, deploy config
└─ docs/            # notes and decisions
```

---

## Stages

Each stage should be **finished and usable** before the next one starts. No stage needs a future stage to be useful.

### Stage 0 — Foundation ✅

Get the skeleton running so everything else has a place to live.

- Monorepo set up; `apps/web` and `apps/api` both boot
- `docker-compose` with Postgres + Redis
- Database migrations and a base schema
- CI: lint, type-check on every push
- Basic layout and theme

**Done.** A developer can clone the repo, start both apps, and see the stack report healthy.
Setup steps are in [CONTRIBUTING.md](./CONTRIBUTING.md).

### Stage 0.5 — Accounts

- AWS Cognito user pool for sign-up and login
- The API verifies Cognito tokens; Buzzly never stores passwords

**Done when:** you can create an account, sign in, and reach a page that only works when signed in.

### Stage 1 — Learn & Run Code (the MVP)

The smallest version that is genuinely useful.

- Monaco editor in the browser
- **Code runs in the browser** (Pyodide for Python, Web Worker for JavaScript) — nothing to secure, instant feedback
- Lesson format: short explanation → task → starter code → hidden tests
- One complete module, start to finish (for example *Python Basics*, ~15 lessons)
- Test runner shows pass/fail per test with a readable message
- Progress saved per user: lessons completed, attempts, last saved code

**Done when:** a beginner can open Buzzly and finish a real module on their own.

### Stage 2 — The AI Mentor

The part that makes Buzzly different.

- Chat panel beside the editor, aware of the lesson, the user's code, and the failing tests
- **Guardrails:** the model may never output a working solution. It can give syntax, a single-line pattern, an analogy, or a question — nothing more
- Hint levels the user picks: *Ask me a question* → *Nudge me* → *Show me the syntax*
- "Explain my error" — turns a stack trace into plain English
- Rate limits and cost tracking per user

**Done when:** a stuck user can get unstuck without being handed the answer.

### Stage 3 — Progress & Motivation

Reasons to come back tomorrow.

- XP, levels, daily streaks
- Badges for modules completed and milestones hit
- Public profile with skills and solved challenges
- A skill map showing what to learn next
- Standalone challenge library, separate from lessons

**Done when:** a user has a profile worth showing off.

### Stage 4 — Multiplayer & Battles

The fun part.

- **Secure server-side code execution** — sandboxed containers with CPU, memory, network, and time limits. Required here, because we can no longer trust the browser
- Lobby, rooms, and matchmaking backed by Redis
- **1v1 Code Duel:** same problem, first correct answer wins
- Live spectating: you see the opponent's progress bar, not their code
- Rating and leaderboards
- Rematch, invite by link, private rooms with friends

**Done when:** two strangers can queue up and play a full match.

### Stage 5 — Grow

Once the loop works, widen it.

- More languages (JS/TS, SQL, maybe Go)
- Team battles and tournaments
- Community-written lessons with a review process
- Responsive, mobile-friendly editor experience
- Analytics on where learners get stuck, used to improve the content

---

## Key Decisions

Each of these is recorded with its full reasoning in [docs/adr/](./docs/adr/).

- **Browser execution first, server sandbox later.** Running code in the browser costs nothing and cannot be abused. We take on the hard security work in Stage 4, where fairness demands it. ([ADR-0003](./docs/adr/0003-browser-first-code-execution.md))
- **Lessons live as files in git.** Easy to review, diff, and contribute to. A CMS can come later if we need one.
- **The AI is constrained by design, not by luck.** Solution-blocking lives in the prompt layer *and* in a server-side output check, so a clever user message cannot break it. ([ADR-0004](./docs/adr/0004-ai-mentor-never-emits-solutions.md))
- **The API owns the database.** The web app never connects to Postgres or Redis directly. ([ADR-0001](./docs/adr/0001-monorepo-next-web-fastapi-api.md), [ADR-0002](./docs/adr/0002-postgres-primary-redis-ephemeral.md))
- **Ship stage by stage.** Every stage ends with something a real person can use.

---

## Open Questions

To decide as we go:

1. Which language do we teach first — Python or JavaScript?
2. Who is the main audience — complete beginners, or people who already know a little?
3. Which LLM provider, and is self-hosting worth it for cost control?
4. Where do we deploy — Vercel plus a managed backend, or one VPS running everything?
5. Free forever, or a free tier with a paid tier later?

Tooling decisions that block Stage 0 are tracked in
[docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md).

---

## Documentation

This repository's documentation is its memory. Start here:

| Question | File |
| --- | --- |
| What is the product, and what must it never do? | [PRODUCT.md](./PRODUCT.md) |
| How is the system meant to fit together? | [ARCHITECTURE.md](./ARCHITECTURE.md) |
| What is actually true right now? | [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md) |
| Why was something decided this way? | [docs/adr/](./docs/adr/) |
| What work is in flight? | [docs/plans/active/](./docs/plans/active/) |
| How do I contribute? | [CONTRIBUTING.md](./CONTRIBUTING.md) |
| How does the AI-assisted workflow work? | [docs/ai/SETUP.md](./docs/ai/SETUP.md) |

AI agents working in this repository follow [AGENTS.md](./AGENTS.md) and bootstrap from
[docs/ai/CONTEXT.md](./docs/ai/CONTEXT.md).

---

## Status

**Stage 0 complete.** Both apps run locally against Postgres and Redis, migrations apply, and CI
checks pass. No product features yet — accounts are next.

Current detail: [docs/PROJECT_STATE.md](./docs/PROJECT_STATE.md).
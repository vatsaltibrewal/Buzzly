---
description: "Use when working in apps/web, the Buzzly Next.js frontend: UI, Monaco editor, lesson player, mentor chat panel, duel screens, and in-browser code execution."
applyTo: "apps/web/**"
---

# Buzzly Web App (`apps/web`)

Next.js 16 (App Router, Turbopack), React 19, TypeScript, Tailwind 4, ESLint 9. Source lives under
`src/`, with the `@/*` import alias pointing at it.

Run things from the repository root: `npm run dev:web`, `npm run lint:web`, `npm run typecheck:web`,
`npm run build`.

Only the landing page exists so far. Monaco and the lesson player arrive in Stage 1. No test
framework is installed yet — do not assume one.

## Hard Rules

**No direct data access.** The web app never opens a PostgreSQL or Redis connection, from the
browser or from its own server runtime, and never holds database credentials. Every read and write
goes through the FastAPI API. See
[ADR-0001](../../docs/adr/0001-monorepo-next-web-fastapi-api.md).

**Never call the model provider directly.** Mentor requests go to the API, which owns the prompt and
guardrail layer. An LLM API key must never reach this application.
See [ADR-0004](../../docs/adr/0004-ai-mentor-never-emits-solutions.md).

**Never render a solution.** No "show solution" affordance, no autocompleting the answer, no
pre-filled correct code. Hint escalation stops at syntax fragments. This is a product rule, not a UX
preference — see [PRODUCT.md](../../PRODUCT.md).

**Learner code executes in an isolated context**: Pyodide or a Web Worker, never on the main thread
and never `eval`'d in the page. See
[ADR-0003](../../docs/adr/0003-browser-first-code-execution.md).

**Client-side results are advisory.** They may drive lesson feedback and progress, never competitive
outcomes. Do not build UI that implies the browser's verdict is authoritative in a duel.

**In duels, opponents' code is never sent to the client.** Progress signals only.

## Practical Notes

- Pyodide's first load is heavy; treat runtime loading as a deliberate UX problem, not an
  afterthought.
- Long-running or infinite learner code must not freeze the UI — that is what the worker boundary is
  for, along with a timeout and a kill path.
- Error messages shown to learners are teaching material. Write them for someone who does not yet
  know programming vocabulary.
- Treat everything from the API as untrusted for rendering purposes; never inject learner-authored
  content as raw HTML.

## Established Conventions

Follow what Stage 0 set up rather than inventing alternatives:

- App Router server components by default; add `"use client"` only where interactivity requires it.
- The API base URL comes from `process.env.NEXT_PUBLIC_API_URL`, defaulting to
  `http://localhost:8000`.
- Requests that must not run at build time pass `{ cache: "no-store" }`, keeping the route dynamic
  and avoiding a build-time dependency on a running API.
- Tailwind utility classes; no CSS-in-JS library is installed.
- `next.config.ts` sets `agentRules: false`. Leave it off — Next otherwise regenerates
  `apps/web/AGENTS.md` and `CLAUDE.md` on every dev start, competing with the root agent contract.
- Lint runs with `--max-warnings 0`, so warnings fail the build. Fix them rather than lowering the
  bar.

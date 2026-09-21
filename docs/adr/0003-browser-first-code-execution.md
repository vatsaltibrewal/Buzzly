# ADR-0003: Run learner code in the browser first

Status: Accepted
Date: 2026-08-30

## Context

A coding-education platform must execute code that strangers write. That is, by definition, running
untrusted code — the single most dangerous thing a web application can do.

Doing it safely on a server requires container isolation, syscall filtering, CPU and memory caps,
network egress blocking, filesystem restrictions, wall-clock timeouts, and defence against fork
bombs and resource exhaustion. That is a serious piece of infrastructure and an ongoing operational
burden.

Meanwhile, the project's first goal (Stage 1) is simply to let a beginner finish a lesson module.
That goal does not require trusted results — nobody is competing, and a learner who cheats their own
lesson has only cheated themselves.

Modern browsers can run Python via Pyodide (CPython compiled to WebAssembly) and JavaScript in a Web
Worker, both inside the browser's existing sandbox.

## Decision

- **Stages 1–3: learner code executes in the browser.** Pyodide for Python, a Web Worker for
  JavaScript. No server-side execution exists.
- Results reported by the browser are treated as **advisory**. They may drive lesson progress and
  XP; they may never drive anything competitive.
- **Stage 4 introduces a sandboxed server-side runner**, because duels require results the platform
  can trust. Its isolation model requires its own ADR before implementation.

## Alternatives Considered

- **Build the sandboxed runner immediately.** Correct for the long term, wrong for now: it would
  consume the project's earliest effort on infrastructure rather than on proving the learning
  experience works at all.
- **Use a hosted execution API (for example Judge0 or a similar service).** Fast to integrate and
  removes the security burden. Rejected for early stages because it adds per-execution cost and
  network latency to the tightest feedback loop in the product, where the loop's speed *is* the
  experience. Remains a legitimate candidate for Stage 4.
- **Run untrusted code in a plain server process with timeouts.** Rejected outright. Timeouts are
  not isolation.

## Consequences

### Positive

- Stage 1 needs no execution infrastructure and carries no sandbox-escape risk.
- Feedback is instant — no network round trip between edit and result.
- Execution cost is zero and scales with the number of browsers, not servers.
- Works offline once loaded.

### Negative

- Learners can trivially fake lesson completion. Accepted for Stages 1–3.
- Pyodide's initial download is large; first-load performance needs attention.
- Only languages with a browser runtime are supported early.
- Two execution paths will exist from Stage 4, with a real risk of behavioural drift between them.
  Lesson tests must be written so that both paths agree.

## Related Code / Documentation

- [README.md](../../README.md) — stage definitions
- [ARCHITECTURE.md](../../ARCHITECTURE.md) — in-browser runtime and Stage 4 runner
- [PRODUCT.md](../../PRODUCT.md) — "competition never rewards cheating"
- No execution code exists yet.

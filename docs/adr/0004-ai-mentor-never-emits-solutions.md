# ADR-0004: The AI mentor never emits a working solution

Status: Accepted
Date: 2026-08-30

## Context

The AI mentor is the reason Buzzly exists. It is also the fastest way to destroy the product.

A general-purpose language model asked "how do I solve this?" will produce the answer. If Buzzly
ships that, it becomes a slower way to get code that the learner did not write, and every lesson,
badge, and rating becomes meaningless.

Prompt instructions alone are not sufficient protection. Learners are motivated and inventive:
role-play framing, "just show me an example", incremental extraction line by line, and asking for
"a similar problem" all defeat a prompt-only rule. A constraint this important cannot depend on the
model choosing to comply.

## Decision

The mentor must never return a complete working solution to the learner's current task.

- **Allowed:** questions that provoke thinking, isolated syntax fragments, analogies, plain-English
  explanations of errors and stack traces, help decomposing a problem into steps, pointing out what
  the learner has missed.
- **Not allowed:** the solution, a near-solution, or the solution assembled across turns.
- **Enforcement is two-layered.** A project-owned prompt layer sets the constraint, and a
  **server-side check on the model's output** runs before any response reaches the client. The
  output check is authoritative; the prompt is not trusted to hold on its own.
- The mentor is reached only through the API. The web app never calls the model provider directly.
- Help escalates only at the learner's request through explicit hint levels: *ask me a question* →
  *nudge me* → *show me the syntax*. Even the highest level stops short of a solution.

## Alternatives Considered

- **Prompt instructions only.** Simplest. Rejected: trivially bypassed, and the failure is silent —
  nobody notices until the product's value has already leaked away.
- **A "show solution" button after N failed attempts.** Common in the market and good for
  short-term completion metrics. Rejected because it directly contradicts the product's purpose;
  the moment it exists it becomes the shortest path for every stuck learner.
- **A model fine-tuned to refuse.** Better adherence, but expensive, provider-locking, and still
  probabilistic. Does not remove the need for an output check.

## Consequences

### Positive

- The product's core promise is protected by code, not by hope.
- The guardrail layer is provider-agnostic, so the model can be swapped.
- A single, testable place to verify the most important behaviour in the system.

### Negative

- The output check will sometimes block a legitimately helpful response; false positives must be
  tuned and monitored.
- Extra latency and complexity on every mentor request.
- "Complete working solution" is fuzzy for small tasks, where a syntax hint may be nearly the whole
  answer. Short lessons need care.
- Cross-turn extraction requires the check to consider conversation history, not just one response.

## Related Code / Documentation

- [PRODUCT.md](../../PRODUCT.md) — core product rules
- [ARCHITECTURE.md](../../ARCHITECTURE.md) — mentor request flow
- [README.md](../../README.md) — Stage 2
- No mentor code exists yet.

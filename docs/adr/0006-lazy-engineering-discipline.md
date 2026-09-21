# ADR-0006: Lazy-senior engineering discipline

Status: Accepted
Date: 2026-08-30

## Context

Buzzly is being built largely with AI assistance, starting from an empty repository. AI agents have
a strong default bias toward producing code: they add abstraction layers nobody asked for, write
helpers that duplicate the standard library, introduce dependencies to solve one-line problems, and
patch the specific call site named in a bug report rather than the shared function underneath.

On a greenfield codebase with no existing patterns to imitate, that bias compounds fast. Every
unnecessary file becomes a pattern the next session copies. Within weeks a project can carry a
framework's worth of structure supporting a handful of real behaviour.

The cost is not only volume. Code that exists must be read, maintained, tested, and understood by
every future session — human or AI — and this project's entire context system is built around
keeping that understanding cheap.

## Decision

Adopt an explicit "lazy senior developer" discipline for all code in this repository, where lazy
means efficient rather than careless.

- Before writing code, climb a fixed ladder and stop at the first rung that holds: does it need to
  exist, does it already exist here, does the standard library cover it, does a native platform
  feature cover it, does an installed dependency solve it, can it be one line — and only then write
  the minimum that works.
- The ladder runs after understanding the problem, never instead of it.
- Bug fixes address the root cause in the shared function, after checking every caller.
- Deliberate corners with a known ceiling are marked with a `ponytail:` comment naming the ceiling
  and the upgrade path.
- Non-trivial logic leaves one runnable check behind — framework-free, no fixtures.
- The discipline explicitly does **not** apply to understanding, input validation at trust
  boundaries, error handling that prevents data loss, security, accessibility, real-world
  calibration, or anything explicitly requested.

The operational rules live in `.github/instructions/code.instructions.md`, scoped to code paths and
discoverable on demand, so they load when code is being written rather than in every conversation.

## Alternatives Considered

- **Say nothing and rely on review.** Rejected: with AI writing most of the code and sessions
  starting without memory, the bias reappears every session. A rule that is not written down does
  not survive a fresh chat — the same reasoning as
  [ADR-0005](./0005-git-tracked-ai-context.md).
- **Put it in `AGENTS.md` in full.** Rejected: `AGENTS.md` is always loaded, and roughly seventy
  lines of code discipline would be carried into documentation-only conversations. A short pointer
  sits there instead.
- **Adopt a named external style guide.** Rejected: style guides govern formatting and naming. The
  problem here is *volume and necessity*, which they do not address.
- **Enforce it with a hook or a lint rule.** Rejected: "should this exist at all" is a judgement, not
  a pattern a script can match.

## Consequences

### Positive

- Less code to read, test, maintain, and re-explain to every new session.
- Reuse is checked before invention, so the codebase converges on its own patterns.
- Root-cause fixes prevent the same bug reappearing through a sibling caller.
- Marked corners make known limitations visible instead of forgotten.
- The one-check rule keeps verification proportional, which matters while the project still has no
  test framework.

### Negative

- Slower starts: understanding and searching before writing feels less productive than typing.
- Judgement-based, so it cannot be automated or objectively enforced.
- Genuine over-application risk — someone may skip a needed abstraction and call it laziness. The
  "never be lazy about" list exists to bound this, and it outranks brevity.
- A tension will recur between "shortest diff" and "correct at the boundary". Correctness wins.

## Related Code / Documentation

- `.github/instructions/code.instructions.md` — the operational rules
- [AGENTS.md](../../AGENTS.md) — section 3, the always-on pointer
- [docs/adr/0005-git-tracked-ai-context.md](./0005-git-tracked-ai-context.md) — why the rule is
  written down at all
- No code exists yet to apply it to.

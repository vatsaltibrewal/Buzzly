# Documentation Policy

One fact, one owner. This file decides which document owns which knowledge, so that updates land in
the right place and the same fact does not get maintained in three files with three different
answers.

## Sources of Truth

| Knowledge | Owner |
| --- | --- |
| What the product is, who it serves, domain vocabulary, product rules | [PRODUCT.md](../../PRODUCT.md) |
| System shape, components, boundaries, data flow, storage, invariants | [ARCHITECTURE.md](../../ARCHITECTURE.md) |
| Why a durable decision was made, and what was rejected | [docs/adr/](../adr/) |
| What is true about the project right now | [docs/PROJECT_STATE.md](../PROJECT_STATE.md) |
| In-flight multi-session work and its checkpoint | [docs/plans/active/](../plans/active/) |
| Stage roadmap and completion criteria | [README.md](../../README.md) |
| Setup, build, test, and contribution workflow | [CONTRIBUTING.md](../../CONTRIBUTING.md) |
| Navigation map for AI agents | [docs/ai/CONTEXT.md](./CONTEXT.md) |
| Rules AI agents must follow | [AGENTS.md](../../AGENTS.md) |
| Enabling the AI workflow locally | [docs/ai/SETUP.md](./SETUP.md) |
| Actual current behaviour | source code and tests |
| Exact dependency versions and scripts | manifests and lock files |
| Discussion, review, and rationale in flight | GitHub issues and pull requests |
| Chronological history | Git |
| Small, non-obvious, supplementary facts | repository memory (never authoritative) |

## When to Update

| Trigger | Update |
| --- | --- |
| Behaviour, API, or schema changed | source docs for that area, plus `ARCHITECTURE.md` if a boundary moved |
| Repository layout changed | `docs/ai/CONTEXT.md` (repository map) |
| Setup, build, lint, or test commands changed | `CONTRIBUTING.md` and `docs/ai/CONTEXT.md` |
| A dependency, framework, or datastore was chosen or replaced | a new ADR, plus `docs/ai/CONTEXT.md` stack table |
| An engineering invariant changed | a new ADR, plus `AGENTS.md` and `ARCHITECTURE.md` |
| High-level project state changed | `docs/PROJECT_STATE.md` |
| Substantial work progressed | the active plan's tasks and **Current Checkpoint** |
| Work finished | move the plan to `docs/plans/archive/`, update `docs/PROJECT_STATE.md` |
| An open decision was resolved | a new ADR, and remove it from the open-decisions table |
| Product scope or a product rule changed | `PRODUCT.md` |

## When Not to Update

Do not touch documentation when the work produced no durable knowledge. Explaining code, answering a
question, reading files, formatting, or a trivial rename creates no documentation impact.

Never edit a file, a date, or a "last verified" line to create the appearance of maintenance. An
unchanged document is the correct outcome when nothing changed.

## Rules

**Describe reality, not intentions.** Documentation states what the code does. Where a document
describes something not yet built, it must say so explicitly — `ARCHITECTURE.md` currently carries a
`Status: planned` banner for exactly this reason.

**Separate the four tenses.** Current behaviour, planned behaviour, historical decisions, and
speculation must never blur together. A plan becoming code is an event that requires the
documentation to be rewritten, not relabelled.

**Do not duplicate.** Link instead. If a fact appears in two files, one of them is wrong — usually
the one nobody remembered to update. Deep detail belongs in the owning document; other files link to
it.

**Rewrite, do not append.** Especially in `docs/ai/CONTEXT.md` and `docs/PROJECT_STATE.md`. These
describe the present. Delete statements that stopped being true instead of adding qualifications
beside them.

**Write for humans.** No chat transcripts, prompt logs, generated file inventories, or duplicated
source code. Explain what exists, why it exists, how the pieces interact, and what constrains them.

**Verify before writing.** Derive facts from source, configuration, manifests, tests, and Git — not
from memory or plausibility. When documentation and code disagree, the code describes current
behaviour; investigate before "fixing" either one.

## Keeping Context Files Small

`docs/ai/CONTEXT.md`, `AGENTS.md`, and `.github/copilot-instructions.md` are loaded frequently and
must stay lean. `copilot-instructions.md` is a router and should point outward rather than explain.
When one of them grows, move the detail into the owning document and leave a link behind.

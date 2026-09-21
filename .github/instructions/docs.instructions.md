---
description: "Use when writing or editing Buzzly documentation: README, PRODUCT, ARCHITECTURE, CONTRIBUTING, docs/, ADRs, and plans. Covers tense discipline, ownership of facts, and avoiding drift."
applyTo: ["*.md", "docs/**/*.md", ".github/**/*.md"]
---

# Writing Buzzly Documentation

## Ownership

One fact, one owner. Before writing, check
[docs/ai/DOCUMENTATION_POLICY.md](../../docs/ai/DOCUMENTATION_POLICY.md) for which file owns the
knowledge you are about to record. If it belongs elsewhere, put it there and link.

## Tense Discipline

This repository has no application code, so almost everything is planned. Keeping the tenses
separate is the main job here.

- **Current** — write plainly, only for things verified on disk.
- **Planned** — label it. `ARCHITECTURE.md` carries a `Status: planned` banner; keep it until the
  thing exists.
- **Historical** — belongs in an ADR, in past tense, never rewritten.
- **Speculation** — mark it as open, or leave it out.

When a plan becomes real, rewrite the section. Do not simply delete the word "planned".

## Rules

- **Verify before writing.** Never document a command, path, dependency, or behaviour you have not
  confirmed. An invented command is worse than a missing one.
- **Rewrite, do not append.** `docs/ai/CONTEXT.md` and `docs/PROJECT_STATE.md` describe the present.
  Delete what stopped being true instead of qualifying it.
- **No changelogs.** History is in Git. `PROJECT_STATE.md` is not a log.
- **Link instead of duplicating.** A fact in two files becomes two conflicting facts.
- **Plain English.** Short sentences. Explain why something exists, not what the next line of code
  does.
- **No AI artefacts.** No chat transcripts, prompt logs, generated inventories, or pasted source.

## Style

- Sentence case headings; no emoji.
- Wrap prose at roughly 100 characters.
- Relative Markdown links; verify every link resolves.
- Tables for enumerable facts, prose for reasoning.

## ADRs

Follow the template and process in [docs/adr/README.md](../../docs/adr/README.md). Number
sequentially, record the alternatives that lost and why, and update the index table. Never edit an
accepted ADR's decision — supersede it with a new one.

## Plans

Use [docs/plans/TEMPLATE.md](../../docs/plans/TEMPLATE.md). Keep the **Current Checkpoint** accurate
while working, not just at the end: a fresh chat must be able to resume from it alone. Move finished
plans to `docs/plans/archive/`.

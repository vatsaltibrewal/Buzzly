# AI Development Environment Setup

How to enable Buzzly's AI-assisted workflow. Everything described here is committed to the
repository — the manual steps below are the few things that cannot be.

Verified against VS Code 1.135.0 on macOS.

## Requirements

- **VS Code 1.135 or newer.** Earlier versions may not support `AGENTS.md`, workspace agent skills,
  or workspace hooks.
- **GitHub Copilot** signed in, with chat available.
- **The repository opened at its root.** Workspace instructions, skills, agents, and hooks are
  discovered relative to the folder root. Opening a subfolder silently disables all of it.

## What Is Already Configured

Committed to the repository, active as soon as you open it:

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | The engineering contract every agent follows |
| `.github/copilot-instructions.md` | Always-on context router |
| `.github/instructions/*.instructions.md` | Path-scoped rules for docs, code discipline, `apps/web`, `apps/api` |
| `.github/skills/` | `/resume`, `/checkpoint`, `/document-sync` |
| `.github/agents/buzzly-engineer.agent.md` | Optional agent that enforces the full lifecycle |
| `.github/hooks/docs-sync.json` | Lifecycle reminders (see below) |
| `.vscode/settings.json` | Enables `AGENTS.md`, skills, hooks; keeps default approvals |
| `.vscode/mcp.json` | GitHub MCP server, OAuth, no credentials stored |

## Hooks

`.github/hooks/docs-sync.json` registers four small POSIX shell scripts that use only `git` and
standard utilities:

- **SessionStart** — checks the context files exist and reminds the agent to bootstrap.
- **PostToolUse** — writes a local marker when non-documentation files change.
- **PreCompact** — warns to run `/checkpoint` before context is lost.
- **Stop** — warns if source changed but no documentation was touched.

They are guardrails only. They never write documentation; that is the agent's job.

Scripts must stay executable. If hooks stop firing after a fresh clone:

```bash
chmod +x .github/hooks/*.sh
```

The marker lives in `.ai-runtime/`, which is git-ignored and must never become project knowledge.

## Copilot Memory

No setting is required in this VS Code build — the memory tool ships with Copilot Chat. Two things
matter:

- **Repository memory is stored outside this repository**, under VS Code's per-workspace storage. It
  is machine-local, unversioned, and invisible to collaborators and to CI.
- **It is therefore supplementary only.** Git-tracked documentation is authoritative — see
  [ADR-0005](../adr/0005-git-tracked-ai-context.md). Everything in this project must work for a
  contributor with no memory at all.

Store only small, durable, non-sensitive facts there. Never architecture, requirements, plans, task
state, or secrets.

## GitHub MCP

`.vscode/mcp.json` points at the official GitHub remote MCP server
(`https://api.githubcopilot.com/mcp/`). It lets agents read issues, pull requests, review comments,
and workflow state for `vatsaltibrewal/Buzzly`.

To enable it:

1. Open the repository in VS Code and trust the workspace when prompted.
2. Start the `github` server from the MCP entry in `.vscode/mcp.json` (or the MCP view).
3. Complete the OAuth sign-in in the browser.

**No token is stored in the repository, and none should ever be added.** If you are asked to paste a
personal access token into a tracked file, stop.

MCP is optional. The project must remain fully workable without it.

## Daily Workflow

**Starting a fresh chat**

```
/resume <task or issue>
```

Reconstructs the project from Git-tracked files: contract, context map, current state, Git status,
active plans, relevant ADRs, then the real source.

**Finishing significant work**

```
/checkpoint
```

Persists progress into the active plan so another session can continue safely.

**Synchronizing documentation**

```
/document-sync
```

Runs the documentation-impact pass. Normal instructions should trigger this automatically; the
command is for when you want it explicitly.

## Security

- Keep `chat.permissions.default` set to `"default"`. Do not switch the workspace to a bypass or
  auto-approve mode — that setting exists so a human stays in the loop for terminal commands and
  edits.
- Never commit secrets, tokens, or `.env` files. `.gitignore` covers `.env*` while keeping
  `.env.example` trackable.
- For highly autonomous agent runs, consider VS Code's agent sandboxing or a Dev Container so that
  commands cannot reach the rest of your machine. Neither is configured here, and neither is
  required.

## If Something Is Not Working

| Symptom | Check |
| --- | --- |
| Skills missing from `/` | Repository opened at root; `chat.useAgentSkills` is true; folder name matches the `name` in `SKILL.md` |
| `AGENTS.md` ignored | `chat.useAgentsMdFile` is true |
| Hooks never fire | `chat.useHooks` is true; scripts are executable |
| MCP tools unavailable | Server started and OAuth completed; workspace trusted |
| Agent claims code exists | It does not. Point it at `docs/PROJECT_STATE.md` and have it verify on disk |

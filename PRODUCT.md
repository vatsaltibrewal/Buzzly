# Product

What Buzzly is, who it is for, and the rules the product must not break. Implementation details
belong in [ARCHITECTURE.md](./ARCHITECTURE.md).

## Purpose

Buzzly teaches programming by making people write code, get stuck, and think their way out — with a
mentor that guides instead of answering.

Most learning products fail in one of two ways: they show passive content, or they hand over the
answer the moment a learner struggles. Both produce people who recognise code but cannot write it.
Buzzly is built to produce the opposite outcome.

## Users

- **Primary:** people learning to program who want genuine problem-solving ability, not completion
  certificates. The precise skill level of the primary audience is still open — see
  [README.md](./README.md).
- **Secondary:** self-taught developers who want deliberate practice through challenges and
  competitive play.
- **Later:** content authors contributing lessons and challenges (Stage 5).

## Core Product Rules

Non-negotiable. Any feature that violates one of these is out of scope regardless of how popular it
would be.

1. **The learner writes the code.** Buzzly never fills in a solution, never autocompletes an answer,
   and never offers a "show solution" button that bypasses thinking.
2. **The AI is a mentor, not a ghostwriter.** It asks questions, offers syntax fragments, explains
   errors in plain language, and helps decompose a problem. It does not produce working answers.
   Enforcement is technical, not merely instructional — see
   [ADR-0004](./docs/adr/0004-ai-mentor-never-emits-solutions.md).
3. **Struggle is the product, frustration is not.** Hints escalate at the learner's request:
   *ask me a question* → *nudge me* → *show me the syntax*. The learner chooses how much help
   arrives.
4. **Competition never rewards cheating.** In multiplayer, opponents see progress, never each
   other's code, and results must be produced by an execution path the platform trusts.
5. **Learning content is reviewable.** Lessons live as files in Git so that quality is inspectable
   and changes are diffable.

## Main Functionality

Delivered in stages (see [README.md](./README.md) for stage boundaries and completion criteria).

- **Lesson modules** — a short explanation, a task, starter code, and hidden tests. Progress is
  tracked per learner.
- **In-app code editor and runner** — write and execute code with immediate, readable pass/fail
  feedback per test.
- **AI mentor** — context-aware guidance beside the editor, constrained by the rules above.
- **Progress and motivation** — XP, levels, streaks, badges, public profiles, a skill map.
- **Challenges** — standalone problems outside the lesson path.
- **Multiplayer battles** — 1v1 duels on a shared problem, live progress spectating, ratings and
  leaderboards, private rooms.

## Domain Concepts

Shared vocabulary. Use these terms consistently in code, schema, and documentation.

| Term | Meaning |
| --- | --- |
| **Module** | An ordered collection of lessons covering one skill area. |
| **Lesson** | One teaching unit: explanation, task, starter code, hidden tests. |
| **Challenge** | A standalone problem not attached to a module. |
| **Submission** | One execution of a learner's code against a lesson or challenge's tests. |
| **Hint level** | How much help the learner has asked for, from a question to a syntax fragment. |
| **Mentor** | The AI guidance system, subject to the solution-blocking rule. |
| **Duel** | A 1v1 timed battle where both players solve the same problem. |
| **Room** | A multiplayer session containing players and, optionally, spectators. |
| **Streak** | Consecutive days with at least one completed activity. |

## Product Constraints

- **Beginners are the default audience for the first module**, so error messages, hints, and copy
  must be readable without prior programming vocabulary.
- **A learner must be able to finish a full module unaided** before any social or competitive
  feature is worth building. Stage 1 gates everything after it.
- **Cost per learner must stay bounded.** The mentor calls a paid model; rate limiting and cost
  tracking are product requirements, not optimisations.
- **Competitive integrity depends on trusted execution**, which is why multiplayer is deliberately
  scheduled after a sandboxed runner exists rather than before.

## Out of Scope

- Generating complete solutions, in any surface, for any reason.
- Video-first or reading-first course content.
- Being a general-purpose online IDE or code hosting service.

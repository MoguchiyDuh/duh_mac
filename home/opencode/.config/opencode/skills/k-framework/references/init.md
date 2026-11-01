---
name: k:init
description: Initialize a new project — scaffold .k/, gather context, brownfield adopt path (intent → docs-first audit → baseline), gitignore entry, optional research and codemap
argument-hint: ""
allowed-tools:
    - Read
    - Write
    - Bash
    - Glob
    - Grep
    - Agent
    - WebSearch
    - WebFetch
---

<objective>
Initialize a new project. Gather context through iterative questions, optionally research topics or
map existing infra/codebase, then scaffold `.k/`. An existing working codebase → adopt path
(section 3): intent before code, docs before code, audit, baseline.

Never scaffold until all questions are resolved and research/codemap (if requested) is complete.
</objective>

<process>

## 1. Guard

```bash
test -f .k/STATE.md && echo "exists" || echo "ok"
```

If exists: stop. Project already initialized — use `/k:start`.
A legacy `.k-framework/` dir does not block init and is never touched.

## 2. Gather context (plain chat, iterative)

Ask in rounds, wait for reply between rounds. Skip anything confidently inferable — read the
codebase instead of asking. Never fill gaps with assumptions.

**Round 1 — always ask (one message):**

- Project name
- Vision: what is this and why
- Desired result: what does "done" look like concretely
- Stack / tech (languages, frameworks, infra)
- Constraints (budget, timeline, existing systems to preserve)

**Round 2 — ask if not clear from round 1:**

- Existing infra or codebase? (running server, existing repo, partial setup)
- Rough phases — major chunks of work, 2–6 words each (feeds ROADMAP.md)

**Round 3+** — only if still ambiguous.

## 3. Adopt mode (existing codebase)

If round 2 revealed an existing, working codebase, run the brownfield path:

1. **Confirm:** "Existing codebase — run the adopt path (intent → docs-first audit)? Plain init
   skips the audit."
2. **Intent (before reading any code):** what should change — declared rewrites (e.g. oneshot CLI
   → persistent daemon), what must *not* change, where docs/specs/references live. Lands in
   PROJECT.md (Result/Constraints) and feeds the audit.
3. **Docs before code:** read all named docs/specs *first*; extract documented claims (behavior,
   contracts, architecture) as a list. No source file is opened before this is done.
4. **Codemap** — step 4 below.
5. **Audit** — run the k:audit workflow (audit.md) in init mode over full scope: verdicts grilled
   and signed off. Hands back findings, crutch FACTS, baseline status — seeded at scaffold.
6. **Baseline** — run by the audit, recorded in AUDIT.md Baseline (command, pass count, commit).
   Status `none` → record as a constraint/risk in PROJECT.md.
7. **Round 2 revisited** — seed ROADMAP stabilization-first: baseline/fixes → declared rewrites →
   new features.

## 4. Codemap (if existing infra mentioned)

Ask: "Want me to map what's already there into CODEMAP.md?"

If yes: spawn read-only agent (Read, Bash, Grep, Glob):

```
Map the existing infrastructure/codebase. User described: {what they said}.
Explore files, run read-only commands (ls, cat, docker ps, etc.) to understand what exists.
Output concise CODEMAP.md: what's running, where things live, key paths, gotchas.
No writes — return the markdown content only.
```

Write output to `.k/CODEMAP.md`.

## 5. Research (if needed)

Ask: "Any topics to research before starting? (libraries, approaches, tradeoffs) — or skip."

If topics: research each into `.k/RESEARCH/{topic}.md` per the k:research rules (sources mandatory),
add INDEX entries.

## 6. Scaffold

```bash
mkdir -p .k/RESEARCH .k/quick .k/phases
```

**`.k/STATE.md`**

```markdown
# {project name}

**Status:** initialized
**Active phase:** none
**Progress:** 0/{N} phases complete
**Next:** define phase 1 with /k:phase
```

**`.k/PROJECT.md`**

```markdown
# {project name}

## Vision

{vision}

## Result

{desired result}

## Stack

{stack}

## Constraints

{constraints}
```

**`.k/ROADMAP.md`**

```markdown
# Roadmap

| # | Phase | Status |
| - | ----- | ------ |
| {one row per phase, status = pending} | | |
```

**`.k/DECISIONS.md`**

```markdown
# Decisions

<!-- settled by the human. append-only. supersede = new entry referencing the old -->
```

**`.k/FACTS.md`**

```markdown
# Facts

<!-- learned truths. every entry needs a source -->
```

**`.k/TODO.md`**

```markdown
# Backlog

<!-- open items; remove when done -->
```

Write `.k/CODEMAP.md` and `.k/RESEARCH/` files only if produced above. `.k/AUDIT.md` is written by
the audit step itself; its handback (findings, crutch FACTS, baseline risk) is seeded into TODO.md,
FACTS.md, PROJECT.md here.

## 7. Gitignore

Ensure `.k/` is ignored — agent-owned state, never committed:

```bash
grep -qxF '.k/' .gitignore 2>/dev/null || echo '.k/' >> .gitignore
```

Create `.gitignore` if missing. If the cwd is not a git repo, skip silently.

## 8. Done

One line: what was created, where. Next: `/k:phase "name"`.

</process>

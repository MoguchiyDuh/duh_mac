---
name: k:audit
description: Brownfield audit — docs-first; per-module verdicts (keep/fix/rewrite) grilled and signed off, demonstrated findings, parked suspicions, baseline run
argument-hint: "[scope, e.g. src/net | module name]"
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
Judge an existing codebase against intent and docs before anything changes it. Output
`.k/AUDIT.md`: signed-off verdicts per module, demonstrated findings, parked suspicions, baseline.
Source is read-only — no fixes, no refactors. The only writes are `.k/` state.
</objective>

<process>

## 1. Mode and scope

- **Init mode** — invoked from k:init adopt path. Intent and doc claims already gathered, `.k/` not
  scaffolded yet: `mkdir -p .k`, write only AUDIT.md, hand the rest back to init (step 9).
- **Standalone** — requires `.k/STATE.md`, else stop: `/k:init`.

$ARGUMENTS narrows scope to modules/paths. No args = full scope. If AUDIT.md exists, read it first
and refresh only the scoped modules. Settled verdicts stand; changing one is a new dated entry with
`Supersedes:`, never an in-place edit.

## 2. Intent

Init mode: from the adopt-path interview. Standalone: read PROJECT.md (Result/Constraints) and
DECISIONS.md; interview only for gaps — declared rewrites, what must not change, where docs live.

Intent outranks quality: a module that is a declared rewrite target is `rewrite` however clean it is.

## 3. Docs before code

Reference set, read before any source file is opened:

- **Repo docs** — README, docs/, specs, ADRs, anything named in intent
- **Framework/library docs** — for the stack in use; Context7 first, else official docs
- **Language standard patterns** — idioms of the edition/standard the code targets

Extract claims as a list: behavior, contracts, architecture, conventions — each with its source.
Init mode: reuse the claims from adopt step 3, add framework/language claims.

## 4. Modules

Module list from CODEMAP.md. Missing and scope is full → run k:codemap first. Present the list;
user confirms the grouping before any verdict work.

## 5. Baseline

Build/run the app, run existing tests. Record: command, result (pass count, failing tests), commit
(`git rev-parse --short HEAD`), date. Do not fix anything to make it pass.

- **pass** — satisfies the k:phase baseline gate
- **fail** — each failure is a finding candidate for step 6
- **none** — nothing runnable; record why. Becomes a constraint/risk in PROJECT.md (init mode:
  handed back)

Only `pass` satisfies the gate. Otherwise rewrite phases need a waiver in DECISIONS.md.

## 6. Audit (read-only subagent)

Subagent allowed-tools: Read, Glob, Grep, Bash — no Write, no Edit. One spawn per module or small
batch:

```
Audit these modules. Read-only — do not modify, fix, or refactor anything.

Intent: {declared rewrites, must-not-change}
Claims: {claims relevant to these modules, with sources}
Baseline: {command + result}
Modules: {name → paths}

Per module:
- Behavior vs claims: matches / deviates / undocumented
- Proposed verdict: keep | fix | rewrite — one-line why
- Findings: only with evidence — a command and its output, a failing test, or a citation
  (file:line vs claim source). Reproduce where cheap.
- Suspicions: anything without evidence — state what check would demonstrate it
- Intentional crutches: code that looks wrong but exists on purpose — with the source proving
  intent (commit, issue, doc)

Output per module: verdict proposal, findings with evidence, suspicions, crutches. No fluff.
```

Verdicts:

- **keep** — works, matches claims. Extend, don't rewrite; follow its patterns
- **fix** — structure sound, specific findings to repair
- **rewrite** — structure is the problem, or a declared rewrite target

k:phase Code rules map `keep` → keep, `fix`/`rewrite` → fair game.

## 7. Grill verdicts

One module at a time: proposed verdict, evidence, findings, crutches, recommendation. User
confirms or overrides; an override records the user's rationale. Nothing becomes a verdict without
sign-off.

Re-check every finding's evidence before presenting it — anything not demonstrable drops to
Suspicions. A suspicion is promoted only when a later run demonstrates or cites it: it moves to
Findings with a new ID, the suspicion entry is marked `→ F{n} {YYYY-MM-DD}`. Assertion never
promotes.

Confirmed crutches become FACTS entries (k:note fact format, Source = the evidence).

## 8. Write AUDIT.md

`.k/AUDIT.md`:

```markdown
# Audit

**Updated:** {YYYY-MM-DD}
**Scope:** {full | scope}

## Baseline

**Status:** {pass | fail | none}
**Command:** `{cmd}`
**Result:** {N passed, M failed — or why none}
**Commit:** {sha} · {YYYY-MM-DD}

## Claims

{source → claims, one line each}

## Verdicts

### {YYYY-MM-DD} — {module}

**Verdict:** {keep | fix | rewrite}
Paths: {paths}
Why: {rationale, user's on override}
{Supersedes: {date} — {module}, if replacing}

## Findings

- [ ] F{n} {module} — {issue}. Evidence: {command/output or file:line vs source}

## Suspicions

- S{n} {module} — {claim}. Would demonstrate: {check}
```

Findings get checked off when fixed, never deleted. IDs never reused.

## 9. Persist

Standalone:

- Append each new finding to TODO.md: `- [ ] audit F{n}: {module} — {issue}`
- Append crutch FACTS to FACTS.md
- Baseline `none` → add the constraint/risk to PROJECT.md

Init mode — return to init, which seeds them at scaffold: TODO lines, crutch FACTS, baseline status
(and the PROJECT.md risk if `none`).

## 10. Report

One line per module: `{module} — {verdict}`. Then counts (findings, suspicions), baseline status.
Next: baseline not `pass` and rewrites declared → a stabilization phase or a waiver via
`/k:note decision`.

</process>

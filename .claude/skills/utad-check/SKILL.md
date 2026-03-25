---
name: utad-check
description: >
  Verify that coverage requirements are met before implementation begins.
  Enforces the coverage gate: every User Task must have all three Test Instance
  streams (happy path, failure, experience quality) before its implementation
  can start. Also re-anchors the agent to the User Task tree when context drift
  is suspected. Triggers: before starting any implementation sprint, when the
  pre-edit hook fires a coverage warning, when the user runs /utad-check
  explicitly, or when an agent has been working for a long session and needs
  re-grounding.
---

# UTAD Check — Coverage Gate & Context Re-Anchor

You are running a coverage audit and context re-anchor. This skill has two
modes depending on context:

1. **Pre-implementation gate** — verify coverage before coding starts
2. **Drift recovery** — re-anchor after a long session or suspected drift

---

## Mode 1: Pre-Implementation Coverage Gate

### Step 1: Read the Coverage Matrix

Read `.utad/coverage-matrix.md` in full.

### Step 2: Identify the Target

Ask the user (or infer from context): "Which User Task(s) are we about to implement?"

### Step 3: Run Coverage Check

For each target User Task, verify:

```
Coverage Checklist for UT-[XXX]: [Task Name]
─────────────────────────────────────────────
Stream A — Happy Path
  File: .utad/test-instances/TI-[XXX]-A.md
  Status: [ ] EXISTS  [ ] DOMAIN LANGUAGE CLEAN  [ ] ACCEPTANCE CRITERIA COMPLETE

Stream B — Failure Scenario(s)
  File(s): .utad/test-instances/TI-[XXX]-B*.md
  Count: [N found]
  Status: [ ] AT LEAST 1 EXISTS  [ ] COVERS MOST LIKELY FAILURE MODE

Stream C — Experience Quality
  File: .utad/test-instances/TI-[XXX]-C.md
  Status: [ ] EXISTS  [ ] HAS PERFORMANCE TARGETS  [ ] HAS COGNITIVE LOAD CRITERIA

Overall: [ ] READY TO IMPLEMENT  [ ] BLOCKED — missing coverage
```

### Step 4: Gate Decision

**If all three streams are present and clean:**
> "Coverage gate PASSED for UT-XXX. You may proceed with implementation.
> Run `/utad-impl` to start with these Test Instances as your anchor."

**If any stream is missing:**
> "Coverage gate BLOCKED for UT-XXX.
> Missing: [list what's missing]
> Run `/utad-test` for UT-XXX to write the missing Test Instances before
> implementation can proceed."

Do not allow the user to bypass this gate. If they ask to proceed anyway,
explain: "The Test Instances are what prevent scope drift during implementation.
Skipping them is the leading cause of re-work. It is faster to write them now."

### Step 5: UTAD Debt Audit

Scan all files in the project's implementation directories (src/, app/, lib/, etc.)
and compare against `.utad/coverage-matrix.md`.

Flag any code that:
- Implements logic not covered by any Test Instance
- Belongs to a feature with status `PENDING` or no status entry

Report these as UTAD Debt in `.utad/utad-debt.md`.

---

## Mode 2: Context Drift Recovery

Trigger this mode when: the session has been running for a long time, the
agent seems to be implementing features beyond the current Test Instance scope,
or the user says "wait, are we still on track?"

### Step 1: Re-Read the Constitution

Read `CLAUDE.md` in full. Confirm the Iron Laws are active.

### Step 2: Re-Read the Active User Task

Read the current UT-XXX from `.utad/user-task-tree.md`.

### Step 3: Re-Read Active Test Instances

Read all TI files for the current UT-XXX.

### Step 4: Scope Audit

Review the code written in the current session and check:

```
□ Does all new code serve the current UT-XXX and its Test Instances?
□ Has any code been added for features not covered by a Test Instance?
□ Do variable and function names use domain language from the Test Instances?
□ Are we still at the correct task granularity?
```

### Step 5: Re-Anchor Report

Produce a brief summary:

> "Context re-anchor complete.
> Current anchor: UT-XXX — [Task Name]
> Active Test Instances: TI-XXX-A, TI-XXX-B1, TI-XXX-C
> Scope status: [ON TRACK / DRIFT DETECTED]
> [If drift: describe what was found and what to do about it]"

---

## Coverage Matrix Format Reference

`.utad/coverage-matrix.md` should always look like:

```markdown
# UTAD Coverage Matrix
Last updated: [date]

| Task ID | Task Name | Happy Path | Failure | Exp. Quality | Status |
|---|---|---|---|---|---|
| UT-001 | [name] | TI-001-A | TI-001-B1 | TI-001-C | IMPLEMENTED |
| UT-002 | [name] | TI-002-A | — | — | PENDING |
| UT-003 | [name] | TI-003-A | TI-003-B1, TI-003-B2 | TI-003-C | READY |

## Status Key
- PENDING — no Test Instances written yet
- READY — all three streams written, implementation not started
- IN_PROGRESS — implementation underway
- IMPLEMENTED — code written, not yet verified against Test Instances
- VERIFIED — all Acceptance Criteria confirmed passing
- DEPRECATED — Task no longer relevant, Test Instances archived

## UTAD Coverage
- Total Tasks: [N]
- Fully covered (all 3 streams): [N] ([%])
- Partially covered: [N]
- Uncovered (PENDING): [N]
- Overall coverage: [%]
```

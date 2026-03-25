---
name: utad-impl
description: >
  Begin implementing a User Task with Test Instances as the anchor.
  This skill enforces the three-boundary agent system (always/ask/never),
  loads the correct Test Instances into working memory before any code is
  written, and runs acceptance criteria after each implementation step.
  Triggers when the user says "implement UT-XXX", "start coding", "build
  this feature", or after /utad-check passes the coverage gate.
---

# UTAD Impl — Anchored Implementation Protocol

You are beginning implementation of a User Task. The Test Instances for
this Task are your contract. Every line of code you write must serve at
least one Acceptance Criterion in these Test Instances.

---

## Step 1: Load the Anchor

Identify the target UT-XXX (ask if unclear).

Read and confirm understanding of:
1. The User Task metadata from `.utad/user-task-tree.md`
2. ALL Test Instances for this Task from `.utad/test-instances/`

Print a brief anchor summary:
```
Anchor loaded for UT-XXX: [Task Name]
Persona: [persona]
Success signal: [from Task metadata]
Active Test Instances:
  → TI-XXX-A (happy path): [one-line summary of WHEN clause]
  → TI-XXX-B1 (failure: [type]): [one-line summary]
  → TI-XXX-C (experience quality): [key performance target]
```

Do not proceed until this anchor is confirmed.

---

## Step 2: Run the Pre-Implementation Coverage Gate

Confirm that `/utad-check` has passed for this Task, or run it now.

If coverage gate is BLOCKED: stop and run `/utad-test` for this Task.

---

## Step 3: Write a Minimal Implementation Plan

Before writing any code, produce a plan. The plan must:
- Reference each Test Instance's Acceptance Criteria explicitly
- Identify the minimum code required to make the happy path pass
- Identify the additional code required to handle failure scenarios
- Identify any experience quality implementations needed

Format:
```
Implementation Plan for UT-XXX
───────────────────────────────
To satisfy TI-XXX-A (happy path):
  1. [what needs to be built]
  2. [what needs to be built]

To satisfy TI-XXX-B1 (failure):
  1. [error handling needed]

To satisfy TI-XXX-C (experience quality):
  1. [performance / UX implementation]

Out of scope (not covered by any Test Instance — do not build):
  - [explicitly list things you will NOT build in this step]
```

Show this plan to the user. Do not begin coding until confirmed.

---

## Step 4: Implement in Test-First Cycles

For each item in the plan, follow this micro-cycle:

```
1. State which Acceptance Criterion you are about to satisfy
2. Write the minimal code to satisfy it (and nothing more)
3. Verify the criterion is met
4. Move to the next criterion
```

### Scope discipline
After each coding step, ask yourself:
> "Am I still inside the boundary of the current Test Instance?"

If you find yourself writing code for something not covered by any
Test Instance for this Task, STOP. Either:
- It belongs to a different User Task → defer it
- It is genuinely missing coverage → run `/utad-test` to add a Test Instance first

### Naming discipline
Use the domain vocabulary from the Test Instances when naming:
- Functions and methods
- Variables holding user-facing data
- UI component names
- Error messages

If the Test Instance says "the user saves their work", your function should
be named `saveWork()` or `save_work()`, not `submitDocument()` or `persistEntity()`.

---

## Step 5: Run Acceptance Criteria Verification

After completing the implementation for each Test Instance stream, verify:

**Stream A (Happy Path):**
```
□ [Acceptance Criterion 1 from TI-XXX-A] — PASS / FAIL
□ [Acceptance Criterion 2] — PASS / FAIL
```

**Stream B (Failure):**
```
□ Failure is communicated clearly — PASS / FAIL
□ User is not left in a dead end — PASS / FAIL
□ [Other criteria] — PASS / FAIL
```

**Stream C (Experience Quality):**
```
□ Performance targets met — PASS / FAIL
□ Maximum step count not exceeded — PASS / FAIL
□ [Other criteria] — PASS / FAIL
```

If any criterion FAILS: fix the code before marking the Task complete.
Never mark a criterion as PASS by re-interpreting it more loosely.

---

## Step 6: Update Coverage Matrix

Open `.utad/coverage-matrix.md` and update UT-XXX status:
- If all Acceptance Criteria pass: `VERIFIED`
- If implementation is done but not yet run against real test harness: `IMPLEMENTED`

---

## Step 7: UTAD Debt Check

Run a quick scan: does the code you just wrote introduce any paths not
covered by a Test Instance? If yes, add an entry to `.utad/utad-debt.md`:

```markdown
## UTAD Debt Entry
- Date: [date]
- File: [file path]
- Uncovered path: [description]
- Recommended action: add Test Instance for [scenario]
- Priority: high / medium / low
```

---

## Boundary System Reminder

These are active during the entire implementation session:

### ✅ Always (no confirmation needed)
- Read the Test Instance before writing each code unit
- Name code constructs using domain language from Test Instances
- Run Acceptance Criteria after each implementation step
- Stay within the scope of the current Test Instance

### ⚠️ Ask first
- Implementing something with no corresponding Test Instance
- Changing a data structure that affects other User Tasks
- Adding error handling not described in any Stream B Test Instance

### 🚫 Never
- Write code for features not covered by a Test Instance
- Modify a Test Instance to resolve a failing criterion
- Mark Acceptance Criteria as PASS without verifying them
- Add scope creep (extras "while we're in there")

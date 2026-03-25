---
name: utad-sync
description: >
  Synchronise living documentation, audit UTAD debt, and run the feedback loop
  from real user behaviour back into the User Task tree. Triggers: at the end
  of a sprint or release cycle, when the user says "sync docs" or "audit debt",
  after receiving user feedback or analytics data, or on a scheduled cadence
  (weekly recommended). Keeps the User Task tree, Test Instances, and coverage
  matrix aligned with reality.
---

# UTAD Sync — Living Documentation & Debt Management

The User Task tree and Test Instances are living documents. They must evolve
with the product. This skill keeps them aligned with:
- What was actually built
- What real users are actually doing
- What has changed since the last sync

---

## Step 1: Coverage Matrix Reconciliation

Read `.utad/coverage-matrix.md` and `.utad/user-task-tree.md`.

For every User Task in the tree:
1. Confirm its status in the coverage matrix is accurate
2. Flag any Task marked `IMPLEMENTED` that has no code referencing its domain
3. Flag any code paths that have no corresponding User Task

Produce a reconciliation diff:
```
Coverage Matrix Reconciliation
───────────────────────────────
✅ Accurate: [N] Tasks
⚠️ Status mismatch: [list any Tasks whose status seems wrong]
🆕 New code paths with no Task: [list files/functions]
❓ Tasks with no code yet: [list]
```

---

## Step 2: Test Instance Freshness Audit

For each Test Instance in `.utad/test-instances/`, check:

### Staleness signals
- The User Task metadata has changed since the Test Instance was written
- The product now behaves differently than what the Test Instance describes
- The Acceptance Criteria reference UI elements that no longer exist
- An entire stream (A, B, or C) is missing for a Task that's now IMPLEMENTED

### Vitality score

Assign each Test Instance one of:
- **CURRENT** — accurately reflects current product behaviour
- **STALE** — product has diverged; needs update
- **DEPRECATED** — Task has been removed; archive this Test Instance
- **MISSING** — a stream that should exist but doesn't

For STALE Test Instances, produce a brief diff:
```
TI-XXX-A: STALE
Was: [what it said]
Now: [what the product actually does]
Action: Update or flag for user decision
```

---

## Step 3: UTAD Debt Review

Read `.utad/utad-debt.md`.

For each debt entry:
1. Is it still unresolved?
2. How much code is now affected?
3. Assign priority: critical / high / medium / low

Produce a debt summary:
```
UTAD Debt Summary
───────────────────
Critical: [N entries] — [brief list]
High: [N entries]
Medium / Low: [N entries]
Total uncovered code paths: [N]

Recommended next: [top 2-3 debt items to address]
```

---

## Step 4: User Feedback Integration (when data is available)

If the user provides any of the following, integrate them:

**Analytics data:**
- Tasks that are never triggered → consider DEPRECATED status
- Tasks with very high failure rates → add Stream B Test Instances
- Unexpected user flows → may indicate missing User Tasks

**Support tickets / user complaints:**
- Map each complaint to a User Task
- If no Task covers it → add to User Task tree via `/utad-map`
- If a Task covers it but the Test Instance did not catch the failure → update Stream B

**User research:**
- New personas discovered → run `/utad-discover` for the new persona
- Existing persona behaviour has changed → update Task metadata and Test Instances

---

## Step 5: Task Tree Pruning

Check for User Tasks that should be removed or archived:
- Features that have been sunset
- Tasks for personas that no longer exist
- Duplicate Tasks that were discovered

For each candidate for removal:
1. Confirm with the user
2. Move the Task to a `## Archived Tasks` section (never delete)
3. Update Test Instance status to `DEPRECATED`
4. Update coverage matrix entry to `DEPRECATED`

---

## Step 6: Produce Sync Report

Write a brief sync report (can be shown to the user or logged):

```markdown
# UTAD Sync Report — [date]

## Coverage
- Tasks fully covered: [N] / [total] ([%])
- Tasks partially covered: [N]
- Tasks with no coverage: [N]

## Changes This Sync
- Test Instances updated: [N]
- Test Instances deprecated: [N]
- New User Tasks added: [N]
- UTAD Debt resolved: [N] entries
- UTAD Debt added: [N] entries

## Health Status
[GREEN / AMBER / RED]

GREEN: Coverage ≥ 80%, no critical debt, no stale Tests
AMBER: Coverage 50–79%, or low-priority debt items
RED: Coverage < 50%, or critical debt, or stale tests on IMPLEMENTED Tasks

## Recommended Actions
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```

---

## Step 7: Commit Documentation

If the project uses git, suggest committing the updated `.utad/` directory:

```bash
git add .utad/
git commit -m "docs(utad): sync living documentation — [date]

Coverage: [N]% ([N]/[total] Tasks fully covered)
Changes: [brief summary]"
```

Living documentation is only valuable if it is versioned alongside the code.

---
name: utad-discover
description: >
  Discover and document the complete User Task landscape for a project.
  Triggers when: starting a new project, when the user says "we might be
  missing something", after user research sessions, or when the team suspects
  scope gaps. Uses JTBD (Jobs To Be Done) three-layer scanning, Switch Moment
  analysis, and a structured completeness audit to ensure no critical user
  scenarios are missed before any code is written.
---

# UTAD Discover — User Task Landscape Mapping

You are running the UTAD discovery protocol. Your goal is to produce a
**complete, user-centred task landscape** before any User Task tree or
Test Instance is written.

Work through every step in order. Do not skip steps.

---

## Step 1: Context Intake

Ask the user (or read from existing project files):

1. What is the product? One sentence.
2. Who are the primary user personas? List them.
3. What problem exists today that this product solves?
4. Are there any existing user research artefacts (interviews, surveys,
   analytics, support tickets)? If yes, ask the user to share them.

Record answers before proceeding.

---

## Step 2: JTBD Three-Layer Scan

For **each user persona**, explore all three levels:

### Job Layer (Why do they hire this product?)
Prompt the user with:
> "Complete this sentence: A [persona] hires this product when they want to
> _____, so they can _____."

Push for the *emotional* and *social* dimension, not just functional:
- Functional: "manage their tasks efficiently"
- Emotional: "feel in control of their workload"
- Social: "appear organised to their team"

A good Job statement captures all three.

### Task Layer (What do they need to accomplish?)
For each Job, ask:
> "What are the distinct things the user needs to *do* in order to
> accomplish this Job? Each thing should have a clear start state,
> end state, and a definition of success."

List every Task. Do not filter yet.

### Action Layer (What are the actual operations?)
For the highest-priority Tasks only, ask:
> "Walk me through exactly what the user does, step by step, the first
> time they complete this Task. What do they click, type, or decide?"

This layer feeds Sub-Tasks in Phase 2 (utad-map), not the Task tree itself.

---

## Step 3: Switch Moment Analysis

For **each persona**, ask these four questions:

1. **Switch In:** "In what specific situation does a user *start* using
   this product for the first time? What triggered the switch?"

2. **Switch Out:** "When would a user *stop* using this product and look
   for an alternative? What has gone wrong, or what are they still missing?"

3. **First Success:** "What is the first moment a user feels the product
   has genuinely worked for them? What did they just accomplish?"

4. **Failure Recovery:** "When something goes wrong during a Task, what
   does the user most want the product to do? What would restore their trust?"

Switch Moments often reveal critical Tasks that the team never thought to
document because they seemed obvious.

---

## Step 4: Completeness Audit

Work through this checklist. For every item marked ❌, ask the user to
describe the scenario, then add it to the emerging task list.

```
Scenario Category          | Covered? | Notes
───────────────────────────|──────────|──────
First-time use / onboarding |          |
Core repeated use (daily)  |          |
Error / failure recovery   |          |
Settings / preferences     |          |
Account / identity         |          |
Collaboration / sharing    |          |
Notification / alerts      |          |
Data export / portability  |          |
Offboarding / deletion     |          |
Low connectivity / offline |          |
Mobile / small screen      |          |
Accessibility needs        |          |
High-volume / power user   |          |
```

---

## Step 5: Write Discovery Output

Create or update `.utad/user-task-tree.md` with a raw task list:

```markdown
# User Task Discovery — [Project Name]
Last updated: [date]

## Personas
- [Persona 1]: [one-line description]
- [Persona 2]: [one-line description]

## Raw Task List

### [Persona 1]
- JTBD: [Job statement]
- Tasks discovered:
  - [ ] [Task description] — priority: high/medium/low
  - [ ] [Task description]
  ...

### [Persona 2]
...

## Switch Moments
- Switch In: [description]
- First Success: [description]
- Switch Out triggers: [list]
- Failure recovery expectations: [list]

## Completeness Audit Gaps
- [Any gaps found and the tasks added to address them]
```

---

## Step 6: Handoff

Tell the user:
> "Discovery is complete. The raw task list is in `.utad/user-task-tree.md`.
> Run `/utad-map` to convert this list into a structured three-tier
> User Task tree with granularity checks."

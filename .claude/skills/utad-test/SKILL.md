---
name: utad-test
description: >
  Write Test Instances for a User Task before any implementation begins.
  This is the core skill of UTAD. Triggers before implementing any new feature,
  when the user says "write tests for UT-XXX", or when the pre-edit hook blocks
  an implementation attempt due to missing Test Instances. Produces structured
  Test Instance files in .utad/test-instances/ using three mandatory streams:
  Happy Path, Failure Scenarios, and Experience Quality.
---

# UTAD Test — Test Instance Writer

You are writing Test Instances for a User Task. A Test Instance is NOT a
unit test or an integration test in the traditional sense. It is a
**structured scenario written entirely in domain language** that describes
what a real user does, what happens, and what success or failure looks like.

Test Instances exist to keep you anchored to user reality throughout
implementation. They are the "ticket" an agent must hold before writing code.

---

## Step 1: Identify the Target User Task

Ask the user: "Which User Task are we writing Test Instances for?"
Accept: a UT-XXX ID, or a description you can match to a UT-XXX ID.

Read the full metadata for that User Task from `.utad/user-task-tree.md`.

---

## Step 2: Domain Language Contract

Before writing anything, establish the domain vocabulary:

> "We will only use terms that a non-technical user would recognise.
> For example: 'the user saves their work' not 'POST /api/documents'.
> If I use a technical term, flag it and rephrase."

Prohibited in ALL Test Instances:
- HTTP methods (GET, POST, PUT, DELETE)
- API endpoint paths (/api/v1/...)
- Database table names (users, orders, ...)
- Class names (UserService, OrderRepository, ...)
- Internal function names
- Framework names (React, Rails, ...)

---

## Step 3: Write Three Mandatory Streams

For each User Task, you must produce exactly THREE types of Test Instances.
Write all three before stopping.

---

### Stream A — Happy Path

The primary scenario where everything works and the user succeeds.

```markdown
---
id: TI-[XXX]-A
user-task: UT-[XXX]
stream: happy-path
persona: [persona name]
created: [date]
status: ACTIVE
---

## Context
[Describe the realistic situation that brings the user to this Task.
2-3 sentences. Include relevant emotional context — are they in a hurry?
Is this their first time? Are they experienced?]

## GIVEN
- The user is [describe their state / what they have already done]
- [Any other preconditions, written as user-observable facts]
- [Data state, if relevant: "The user has 3 existing items"]

## WHEN
[The user] [does something specific, in plain language]

## THEN

### Functional result
- [What the user sees or receives — observable outcomes only]
- [What has changed in their world]

### Experience quality
- The user receives confirmation within [time expectation, e.g. 2 seconds]
- The next obvious action is clear without additional instruction
- [Any other UX expectations]

### Emotional result
- The user feels [confident / relieved / in control / etc.] because [reason]

## Acceptance Criteria
- [ ] [Specific, binary, testable statement — passes or fails]
- [ ] [Another criterion]
- [ ] [Another criterion]
```

---

### Stream B — Failure Scenarios

At least one scenario where the Task fails and the user must recover.
Write one Test Instance per *distinct type* of failure.

```markdown
---
id: TI-[XXX]-B1
user-task: UT-[XXX]
stream: failure
failure-type: [e.g. invalid-input / system-error / permission / timeout]
persona: [persona name]
created: [date]
status: ACTIVE
---

## Context
[Same realistic setup as Happy Path, but leading to failure]

## GIVEN
- [Preconditions, same format]
- [Include the specific condition that will cause failure, from user's perspective]

## WHEN
[The user] [does the same action as the happy path]

## THEN

### What the user sees
- [Description of the failure state the user experiences]
- The error or problem is communicated in [plain language / specific message quality]

### Recovery path
- The user is offered [specific next step or guidance]
- The user's previous work is [preserved / lost — specify expected behaviour]
- The user knows exactly what to do next because [reason]

### Emotional result
- The user feels [frustrated but not panicked / confused / etc.]
- The user's trust in the product is [maintained / damaged] because [reason]

## Acceptance Criteria
- [ ] The failure is communicated clearly without technical jargon
- [ ] The user is not left in a dead end
- [ ] [Other specific criteria]
```

---

### Stream C — Experience Quality

Tests that the Task meets non-functional expectations critical to user experience.
These are the tests most likely to be skipped by an agent — enforce them.

```markdown
---
id: TI-[XXX]-C
user-task: UT-[XXX]
stream: experience-quality
persona: [persona name]
created: [date]
status: ACTIVE
---

## Context
[Normal usage context]

## GIVEN
[Standard preconditions]

## WHEN
The user performs [the Task] under [normal / stressed / edge conditions]

## THEN

### Performance
- The user receives initial feedback within [X seconds]
- The full result is available within [Y seconds]
- The user is never left staring at a blank screen for more than [Z seconds]

### Cognitive load
- The user completes the Task in no more than [N] distinct decisions
- No step requires external knowledge not provided in the interface
- The user does not need to consult documentation or support

### Trust signals
- [What the interface does to communicate reliability to the user]
- [What state is preserved if the user navigates away and returns]

### Accessibility
- The Task is completable using keyboard navigation only
- [Any screen-reader or contrast requirements specific to this Task]

## Acceptance Criteria
- [ ] Performance targets met (specified above)
- [ ] Maximum step count not exceeded
- [ ] [Other specific criteria]
```

---

## Step 4: File Naming and Registration

Save each Test Instance as:
```
.utad/test-instances/TI-[XXX]-[stream-letter][index].md
```

Example:
```
.utad/test-instances/TI-001-A.md    ← happy path
.utad/test-instances/TI-001-B1.md   ← failure: invalid input
.utad/test-instances/TI-001-B2.md   ← failure: system error
.utad/test-instances/TI-001-C.md    ← experience quality
```

---

## Step 5: Update Coverage Matrix

Open `.utad/coverage-matrix.md` and update the row for UT-XXX:

```markdown
| UT-XXX | [Task Name] | TI-XXX-A | TI-XXX-B1 | TI-XXX-C | READY |
```

Status values: `PENDING` → `READY` → `IN_PROGRESS` → `IMPLEMENTED` → `VERIFIED`

---

## Step 6: Domain Language Audit

Before handing off, re-read every Test Instance you just wrote and check:

```
□ Zero HTTP methods
□ Zero API paths
□ Zero class or function names
□ Zero database table names
□ Every action described as a user would describe it
□ Every outcome described as a user would observe it
```

If any fail, rewrite the offending line before saving.

---

## Step 7: Handoff

Tell the user:
> "[N] Test Instances written for UT-XXX.
> Stream A (happy path): TI-XXX-A
> Stream B (failure): TI-XXX-B1 [, TI-XXX-B2, ...]
> Stream C (experience quality): TI-XXX-C
>
> Coverage matrix updated. UT-XXX status: READY.
> Run `/utad-impl` to begin implementation with these Test Instances as your anchor."

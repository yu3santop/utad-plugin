---
name: utad-map
description: >
  Convert the raw task list from utad-discover into a structured, granularity-
  checked three-tier User Task tree (Epic Job → User Task → Sub-Task/Action).
  Triggers after /utad-discover completes, or whenever the User Task tree needs
  restructuring. Enforces granularity rules and writes the canonical tree to
  .utad/user-task-tree.md.
---

# UTAD Map — User Task Tree Builder

You are converting the raw discovery output into a structured, canonical
User Task tree. Every node in this tree will be the anchor for Test Instances.
Precision here determines the quality of everything downstream.

---

## Step 1: Read Discovery Output

Read `.utad/user-task-tree.md`. If it does not exist or has no raw task list,
tell the user to run `/utad-discover` first.

---

## Step 2: Apply Three-Tier Structure

Organise every task into this hierarchy:

```
Epic Job
  └── User Task
        └── Sub-Task (optional, only when Action-level detail is needed)
```

### Tier Definitions

**Epic Job**
The reason a user persona engages with the product at all.
One or two per persona in most products.
Example: "Manage my team's work without losing track of anything"

**User Task**
A discrete, completable unit of work a user does to serve an Epic Job.
This is the PRIMARY unit of UTAD. Test Instances are written at this level.
Example: "Assign a task to a team member"

**Sub-Task / Action**
A single interface operation within a User Task.
Only document these when a Task has complex branching that needs
separate coverage in a Test Instance.
Example: "Select assignee from member dropdown"

---

## Step 3: Run Granularity Check on Every User Task

For each proposed User Task, verify ALL of the following:

### It IS a valid User Task if:
- [ ] The user can complete it independently (no other Task required)
- [ ] It has a clear start state and end state
- [ ] It can be completed in a single session
- [ ] You can write at least 3 distinct Test Instances for it (happy path,
      failure, and experience quality)
- [ ] It has exactly one definition of "success"

### It is TOO COARSE (split it) if:
- It contains two independent "success" states
- A user could fail at the beginning but succeed at the end, and these
  feel like separate experiences
- Different user personas would approach it very differently

### It is TOO FINE (merge it up) if:
- The user cannot skip it and accomplish the parent Epic Job
- It has no meaningful failure mode of its own
- It is always done as part of another Task and never alone

### Granularity Self-Test (ask for each Task):
> "If this Task fails completely, what is the specific user feeling?"
If you cannot answer precisely, the Task is probably too coarse.

> "Could a user ever have reason to do this Task without doing any
> related Tasks before or after?"
If no, it is probably a Sub-Task, not a User Task.

---

## Step 4: Add Task Metadata

For each User Task, record:

```markdown
### UT-[ID]: [Task Name]
- Epic Job: [parent Epic Job name]
- Persona: [who performs this task]
- Trigger: [what situation causes the user to start this task]
- Start state: [what must be true before the user begins]
- End state: [what is true when the user successfully completes it]
- Success signal: [how the user knows they are done]
- Frequency: daily / weekly / monthly / one-time
- Priority: critical / high / medium / low
- Emotional stakes: [what the user feels if this goes well / badly]
- Known failure modes: [list of ways this task can go wrong]
```

---

## Step 5: Write Canonical Tree

Overwrite `.utad/user-task-tree.md` with the structured tree:

```markdown
# User Task Tree — [Project Name]
Last updated: [date]
Version: [increment each time tree is updated]

## Personas
- [Persona ID]: [description]

---

## [Persona 1 Name]

### Epic Job 1: [Job Statement]

#### UT-001: [Task Name]
- Epic Job: Epic Job 1
- Persona: [Persona 1]
- Trigger: [...]
- Start state: [...]
- End state: [...]
- Success signal: [...]
- Frequency: [...]
- Priority: [...]
- Emotional stakes: [...]
- Known failure modes:
  - [failure mode 1]
  - [failure mode 2]

#### UT-002: [Task Name]
[...]

### Epic Job 2: [...]
[...]

---

## [Persona 2 Name]
[...]

---

## Tree Statistics
- Total Epic Jobs: [N]
- Total User Tasks: [N]
- Tasks with Test Instances: 0 / [N]   ← updated by /utad-check
- Coverage: 0%                          ← updated by /utad-check
```

---

## Step 6: Update Coverage Matrix

Add every UT-XXX to `.utad/coverage-matrix.md` with status `PENDING`.

---

## Step 7: Handoff

Tell the user:
> "The User Task tree is complete in `.utad/user-task-tree.md`.
> [N] User Tasks defined across [N] Epic Jobs.
> Run `/utad-test` for each User Task to write its Test Instances
> before any implementation begins."

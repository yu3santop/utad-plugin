---
id: TI-[XXX]-[stream]
user-task: UT-[XXX]
stream: happy-path | failure | experience-quality
failure-type: [only for stream B — e.g. invalid-input / system-error / permission / timeout]
persona: [persona name]
created: [YYYY-MM-DD]
status: ACTIVE | DRAFT | DEPRECATED
---

## Context

[2–3 sentences describing the realistic situation that brings the user to this
Task. Include relevant emotional context.]

## GIVEN

- The user is [describe their current state]
- [Precondition 2, written as a user-observable fact]
- [Precondition 3]

## WHEN

[The user] [does something specific, described in plain language]

## THEN

### Functional result
- [What the user sees or receives — observable outcomes only, no technical detail]
- [What has changed in their world]

### Experience quality
- The user receives initial feedback within [time expectation]
- [Other UX expectations]

### Emotional result
- The user feels [emotion] because [reason]

## Acceptance Criteria

- [ ] [Specific, binary, testable — passes or fails with no ambiguity]
- [ ] [Another criterion]
- [ ] [Another criterion]

---

<!--
DOMAIN LANGUAGE AUDIT (delete this block before saving)

Before saving this file, verify:
□ Zero HTTP methods (GET, POST, PUT, DELETE, PATCH)
□ Zero API endpoint paths (/api/v1/...)
□ Zero class names (UserService, OrderRepo...)
□ Zero database table names
□ Zero internal function names
□ Every action is how a user would describe it
□ Every outcome is what a user would observe

If any fail: rewrite before saving.
-->

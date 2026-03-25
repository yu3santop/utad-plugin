# Agent Boundary Rules — UTAD Impl

Quick reference card for agent boundaries during implementation sessions.
This file is referenced by UTAD Impl and by the pre-edit hook.

---

## ✅ ALWAYS (act without confirmation)

| Situation | Action |
|---|---|
| Starting work on any feature | Read `.utad/test-instances/TI-XXX-*.md` first |
| Writing a new function/method | Check: does its name use domain language? |
| Completing a code unit | Verify against the relevant Acceptance Criterion |
| Finishing a Task | Update `coverage-matrix.md` |
| Finding uncovered code | Log in `utad-debt.md` |

---

## ⚠️ ASK BEFORE DOING

| Situation | Question to ask the user |
|---|---|
| No Test Instance exists for what you're about to build | "I don't see a Test Instance for [feature]. Should I run /utad-test first?" |
| Two Test Instances appear to conflict | "TI-XXX and TI-YYY describe contradictory behaviour for [scenario]. Which should take precedence?" |
| A Test Instance seems outdated | "TI-XXX describes behaviour that no longer matches the current User Task. Should I update the Test Instance or revert the code?" |
| Implementation will affect another User Task | "This change will also affect UT-YYY. Should I check its Test Instances before proceeding?" |
| Tempted to add something "while we're in there" | "I noticed [opportunity]. That's outside the current Test Instance scope. Should I add it as a new User Task?" |

---

## 🚫 NEVER

| Prohibited action | Why |
|---|---|
| Write implementation code with no corresponding Test Instance | Violates Iron Law 1 |
| Modify a Test Instance to resolve a failing Acceptance Criterion | Violates Iron Law 2 |
| Use class names, API paths, or DB tables in a Test Instance | Violates Iron Law 3 |
| Mark Acceptance Criteria as passing without verifying | Creates invisible technical debt |
| Add features beyond current Test Instance scope | Causes scope creep and unmaintainable coverage matrix |
| Skip the plan step in utad-impl | Removes the human approval checkpoint |
| Close a Task as VERIFIED with failing criteria | Makes the coverage matrix untrustworthy |

---

## Scope Creep Disposal Protocol

When you notice something that should be built but is outside current scope:

1. Do NOT build it now
2. Say: "I noticed [X]. This isn't covered by the current Test Instance.
   I'll note it for later."
3. Add a brief note to `.utad/utad-debt.md` or ask the user if they want
   to add a new User Task to the tree
4. Continue with the current Task

This keeps the coverage matrix clean and prevents invisible scope growth.

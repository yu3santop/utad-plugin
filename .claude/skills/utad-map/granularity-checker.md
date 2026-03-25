# Granularity Checker — Quick Reference

Use this file as a fast lookup when uncertain about a User Task's correct tier.

---

## The Core Question

> "If I showed this Task description to the user, would they say
> 'Yes, that's a thing I consciously set out to do' — or would they say
> 'that's just part of doing [something else]'?"

If they would say "yes, that's a goal I pursue on its own" → User Task.
If they would say "that's just a step" → Sub-Task.
If they would say "that's basically the whole product" → Epic Job.

---

## Coarseness Signals (split the task)

| Signal | Example |
|---|---|
| Contains "and" between two independent goals | "Create a project **and** invite team members" |
| Two different user types would have different experiences | Admins see settings; members don't |
| Success can happen at two different points | Saved draft = success? Or sent = success? |
| Failure at step 2 and failure at step 7 feel completely different | |

---

## Fineness Signals (merge up to parent Task)

| Signal | Example |
|---|---|
| Cannot be triggered independently | "Click the confirm button" — never done alone |
| No emotional stakes of its own | User does not *feel* anything specific |
| Always preceded by the same parent Task without exception | |
| Failure is indistinguishable from the parent Task failing | |

---

## Common Mistakes

**Mistake: Feature-based naming**
- ❌ "Use the search bar"
- ✅ "Find a specific item in a large collection"

**Mistake: Technical flow as Task**
- ❌ "Submit the form and receive a 200 response"
- ✅ "Complete registration for the first time"

**Mistake: Admin / system Tasks mixed with User Tasks**
- Admin tasks (e.g. "manage user permissions") are valid User Tasks
  but belong to the Admin persona, not the end user persona.

**Mistake: Onboarding treated as one Task**
- Onboarding is almost always 3–5 distinct User Tasks
  (create account, verify identity, complete profile, etc.)

---

## Ideal Task Size

A well-scoped User Task should produce:
- 1 happy path Test Instance
- 1–2 failure scenario Test Instances
- 1 experience quality Test Instance

If you cannot think of a failure scenario, the Task is probably too small.
If you have more than 6 Test Instance ideas, the Task is probably too large.

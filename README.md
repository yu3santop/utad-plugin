# UTAD — User Task Anchored Development

> A Claude Code plugin that keeps your AI agent anchored to real user needs throughout the entire development lifecycle.

## Why UTAD?

AI coding agents drift. Without a structural anchor, they optimise for code correctness and lose sight of what users actually need to accomplish. UTAD solves this by making **User Tasks** the immovable source of truth — every line of code must be traceable back to a Test Instance, and every Test Instance must be traceable back to a User Task.

```
User Task Tree → Test Instances → Coverage Gate → Implementation
       ↑                                                  |
       └──────────── Feedback Loop ←────────────────────┘
```

## Five Phases, Five Skills

| Skill | Command | Purpose |
|---|---|---|
| utad-discover | `/utad-discover` | Map the complete user task landscape |
| utad-map | `/utad-map` | Build the 3-tier User Task tree |
| utad-test | `/utad-test` | Write Test Instances before any code |
| utad-check | `/utad-check` | Enforce coverage gates |
| utad-impl | `/utad-impl` | Anchor agent implementation to tests |
| utad-sync | `/utad-sync` | Maintain living documentation |

## Quick Start

```bash
# 1. Clone into your project's .claude directory
git clone https://github.com/YOUR_USERNAME/utad-plugin .claude-utad

# 2. Run the installer (copies skills + hooks into your project)
bash .claude-utad/install.sh

# 3. Start a new project
# Open Claude Code and run:
# /utad-discover
```

## The Three Iron Laws

1. **No Test Instance → No Implementation.** The pre-edit hook enforces this automatically.
2. **Never modify a Test Instance to make code pass.** Only code changes are allowed.
3. **Test Instances use domain language only.** No class names, API endpoints, or DB table names.

## File Structure After Installation

```
your-project/
├── CLAUDE.md                    ← UTAD constitution (auto-generated)
├── .claude/
│   ├── skills/                  ← All 6 UTAD skills
│   ├── hooks/
│   │   ├── pre-edit-guard.sh    ← Blocks implementation without Test Instance
│   │   └── post-edit-check.sh  ← Audits coverage after each edit
│   └── agents/
│       ├── task-discoverer.md
│       └── coverage-auditor.md
└── .utad/
    ├── user-task-tree.md        ← Living User Task tree
    ├── test-instances/          ← All Test Instance files
    ├── coverage-matrix.md       ← Real-time coverage matrix
    └── utad-debt.md             ← Uncovered code registry
```

## Theoretical Foundations

UTAD synthesises and extends:
- **JTBD (Jobs To Be Done)** — for user task discovery depth
- **ATDD / BDD** — for Given/When/Then test language
- **Spec-Driven Development** — for spec-as-source-of-truth architecture
- **RIPER workflow** — for agent phase discipline
- **TDD Guard** — for enforcement mechanics

## License

MIT

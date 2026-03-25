# Contributing to UTAD

Thank you for your interest in improving UTAD.

## What Can Be Improved

### Skills (`/.claude/skills/`)
Each skill is a single `SKILL.md` file. Improvements include:
- Clearer step-by-step instructions for the agent
- Additional protocol steps that prevent known failure modes
- Better examples that illustrate correct vs incorrect behaviour
- Tighter boundary definitions

### Hooks (`/.claude/hooks/`)
The shell scripts are intentionally simple. Improvements include:
- Better file-type detection logic
- More intelligent coverage inference
- Performance improvements for large projects

### Templates (`/templates/`)
The starter files installed into new projects. Improvements include:
- Clearer placeholder guidance
- Additional example Test Instances covering different domains
- Better CLAUDE.md constitution language

### Documentation
- Real-world usage examples
- Integration guides for specific frameworks or tech stacks
- Worked examples for different product types (SaaS, mobile, CLI, API)

## Principles for Changes

1. **User-centricity first.** Every change should bring agent behaviour
   closer to user reality, not closer to technical elegance.

2. **Domain language is sacred.** No skill, template, or example should
   ever encourage putting technical terms into Test Instances.

3. **Enforcement over suggestion.** Where a rule can be enforced
   mechanically (hook, gate, template), prefer enforcement over
   documenting it and hoping it is followed.

4. **Simplicity scales.** The skills should work on a solo project and
   a 10-person team. Avoid adding complexity that only helps at scale.

## How to Submit Changes

1. Fork the repository
2. Create a branch: `git checkout -b improve/skill-name-description`
3. Make your changes
4. Test with a real project (install using `install.sh` into a test project)
5. Open a pull request with:
   - What you changed and why
   - Which failure mode or gap it addresses
   - How you tested it

## Reporting Issues

Open a GitHub Issue describing:
- Which skill or hook had the problem
- What you expected to happen
- What actually happened
- The project type (full-stack web, mobile, API-only, etc.)

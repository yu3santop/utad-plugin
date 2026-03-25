#!/usr/bin/env bash
# ============================================================
# UTAD Plugin Installer
# Copies skills, hooks, and templates into your project.
# Run from your project root: bash .claude-utad/install.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      UTAD Plugin Installer                   ║"
echo "║  User Task Anchored Development              ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ── 1. Create directories ──────────────────────────────────
echo -e "${YELLOW}Creating project structure...${NC}"
mkdir -p "$PROJECT_DIR/.claude/skills"
mkdir -p "$PROJECT_DIR/.claude/hooks"
mkdir -p "$PROJECT_DIR/.claude/agents"
mkdir -p "$PROJECT_DIR/.utad/test-instances"

# ── 2. Copy skills ─────────────────────────────────────────
echo -e "${YELLOW}Installing skills...${NC}"
for skill in utad-discover utad-map utad-test utad-check utad-impl utad-sync; do
  if [ -d "$SCRIPT_DIR/.claude/skills/$skill" ]; then
    cp -r "$SCRIPT_DIR/.claude/skills/$skill" "$PROJECT_DIR/.claude/skills/"
    echo -e "  ${GREEN}✓${NC} $skill"
  fi
done

# ── 3. Copy hooks ──────────────────────────────────────────
echo -e "${YELLOW}Installing hooks...${NC}"
cp "$SCRIPT_DIR/.claude/hooks/"*.sh "$PROJECT_DIR/.claude/hooks/"
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh
echo -e "  ${GREEN}✓${NC} pre-edit-guard.sh"
echo -e "  ${GREEN}✓${NC} post-edit-check.sh"

# ── 4. Copy agents ─────────────────────────────────────────
echo -e "${YELLOW}Installing agents...${NC}"
cp "$SCRIPT_DIR/.claude/agents/"*.md "$PROJECT_DIR/.claude/agents/"
echo -e "  ${GREEN}✓${NC} task-discoverer.md"
echo -e "  ${GREEN}✓${NC} coverage-auditor.md"

# ── 5. Initialise .utad memory bank ───────────────────────
echo -e "${YELLOW}Initialising UTAD memory bank...${NC}"
if [ ! -f "$PROJECT_DIR/.utad/user-task-tree.md" ]; then
  cp "$SCRIPT_DIR/templates/.utad/user-task-tree.md" "$PROJECT_DIR/.utad/"
  echo -e "  ${GREEN}✓${NC} user-task-tree.md"
fi
if [ ! -f "$PROJECT_DIR/.utad/coverage-matrix.md" ]; then
  cp "$SCRIPT_DIR/templates/.utad/coverage-matrix.md" "$PROJECT_DIR/.utad/"
  echo -e "  ${GREEN}✓${NC} coverage-matrix.md"
fi
if [ ! -f "$PROJECT_DIR/.utad/utad-debt.md" ]; then
  cp "$SCRIPT_DIR/templates/.utad/utad-debt.md" "$PROJECT_DIR/.utad/"
  echo -e "  ${GREEN}✓${NC} utad-debt.md"
fi

# ── 6. Generate CLAUDE.md if absent ───────────────────────
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
  echo -e "${YELLOW}Generating CLAUDE.md constitution...${NC}"
  PROJECT_NAME=$(basename "$PROJECT_DIR")
  sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    "$SCRIPT_DIR/templates/CLAUDE.md.template" > "$PROJECT_DIR/CLAUDE.md"
  echo -e "  ${GREEN}✓${NC} CLAUDE.md generated"
else
  echo -e "${YELLOW}CLAUDE.md already exists — skipping (manual merge may be needed)${NC}"
  echo -e "  Refer to: $SCRIPT_DIR/templates/CLAUDE.md.template"
fi

# ── 7. Add .utad to .gitignore entries (optional) ─────────
if [ -f "$PROJECT_DIR/.gitignore" ]; then
  if ! grep -q ".utad/test-instances" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
    echo -e "${YELLOW}Note: Consider whether to commit .utad/ to version control.${NC}"
    echo -e "  UTAD recommends committing it — it is your living documentation."
  fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  UTAD installed successfully!                ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Next step: open Claude Code and run ${CYAN}/utad-discover${NC}"
echo ""

#!/usr/bin/env bash
# ============================================================
# UTAD Plugin Installer
# Copies skills, hooks, and templates into your project.
# Supports both global and project-wise installation.
# Run from your project root: bash .claude-utad/install.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"

# Ask user for installation scope
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      UTAD Plugin Installer                   ║"
echo "║  User Task Anchored Development              ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
echo "Select installation scope:"
echo "  1) Globally (available to all projects)"
echo "  2) Project-wise (current project only)"
read -p "Enter choice [1-2]: " choice

# Set target directories based on choice
if [[ "$choice" == "1" ]]; then
    TARGET_CLAUDE_DIR="$HOME/.claude"
    TARGET_UTAD_DIR="$PROJECT_DIR/.utad"  # UTAD data remains project-specific
    INSTALL_TYPE="global"
elif [[ "$choice" == "2" ]]; then
    TARGET_CLAUDE_DIR="$PROJECT_DIR/.claude"
    TARGET_UTAD_DIR="$PROJECT_DIR/.utad"
    INSTALL_TYPE="project"
else
    echo "Invalid choice. Defaulting to project-wise installation."
    TARGET_CLAUDE_DIR="$PROJECT_DIR/.claude"
    TARGET_UTAD_DIR="$PROJECT_DIR/.utad"
    INSTALL_TYPE="project"
fi

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
echo -e "${YELLOW}Installing UTAD ${INSTALL_TYPE}ly...${NC}"

# ── 1. Create directories ──────────────────────────────────
echo -e "${YELLOW}Creating project structure...${NC}"
mkdir -p "$TARGET_CLAUDE_DIR/skills"
mkdir -p "$TARGET_CLAUDE_DIR/hooks"
mkdir -p "$TARGET_CLAUDE_DIR/agents"
mkdir -p "$TARGET_UTAD_DIR/test-instances"

# ── 2. Copy skills ─────────────────────────────────────────
echo -e "${YELLOW}Installing skills...${NC}"
for skill in utad-discover utad-map utad-test utad-check utad-impl utad-sync; do
    if [ -d "$SCRIPT_DIR/.claude/skills/$skill" ]; then
        cp -r "$SCRIPT_DIR/.claude/skills/$skill" "$TARGET_CLAUDE_DIR/skills/"
        echo -e "  ${GREEN}✓${NC} $skill"
    fi
done

# ── 3. Copy hooks ──────────────────────────────────────────
echo -e "${YELLOW}Installing hooks...${NC}"
cp "$SCRIPT_DIR/.claude/hooks/"*.sh "$TARGET_CLAUDE_DIR/hooks/"
chmod +x "$TARGET_CLAUDE_DIR/hooks/"*.sh
echo -e "  ${GREEN}✓${NC} pre-edit-guard.sh"
echo -e "  ${GREEN}✓${NC} post-edit-check.sh"

# ── 4. Copy agents ─────────────────────────────────────────
echo -e "${YELLOW}Installing agents...${NC}"
cp "$SCRIPT_DIR/.claude/agents/"*.md "$TARGET_CLAUDE_DIR/agents/"
echo -e "  ${GREEN}✓${NC} task-discoverer.md"
echo -e "  ${GREEN}✓${NC} coverage-auditor.md"

# ── 5. Initialise .utad memory bank ───────────────────────
echo -e "${YELLOW}Initialising UTAD memory bank...${NC}"
if [ ! -f "$TARGET_UTAD_DIR/user-task-tree.md" ]; then
    cp "$SCRIPT_DIR/templates/.utad/user-task-tree.md" "$TARGET_UTAD_DIR/"
    echo -e "  ${GREEN}✓${NC} user-task-tree.md"
fi
if [ ! -f "$TARGET_UTAD_DIR/coverage-matrix.md" ]; then
    cp "$SCRIPT_DIR/templates/.utad/coverage-matrix.md" "$TARGET_UTAD_DIR/"
    echo -e "  ${GREEN}✓${NC} coverage-matrix.md"
fi
if [ ! -f "$TARGET_UTAD_DIR/utad-debt.md" ]; then
    cp "$SCRIPT_DIR/templates/.utad/utad-debt.md" "$TARGET_UTAD_DIR/"
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
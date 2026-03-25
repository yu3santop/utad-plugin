#!/usr/bin/env bash
# ============================================================
# UTAD Pre-Edit Guard Hook
# Runs before Claude Code writes to any implementation file.
# Blocks the edit if no Test Instance covers the target file.
#
# Usage (Claude Code hooks config):
#   pre_edit: bash .claude/hooks/pre-edit-guard.sh "$FILE"
# ============================================================

set -euo pipefail

TARGET_FILE="${1:-}"
UTAD_DIR=".utad"
COVERAGE_MATRIX="$UTAD_DIR/coverage-matrix.md"
TEST_INSTANCES_DIR="$UTAD_DIR/test-instances"

# ── Colours ───────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Helper: print banner ───────────────────────────────────
utad_banner() {
  echo -e "${CYAN}[UTAD Guard]${NC} $1"
}

utad_block() {
  echo ""
  echo -e "${RED}${BOLD}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${RED}${BOLD}║  ⛔  UTAD PRE-EDIT GUARD — BLOCKED           ║${NC}"
  echo -e "${RED}${BOLD}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${RED}$1${NC}"
  echo ""
}

utad_pass() {
  echo -e "${GREEN}[UTAD Guard]${NC} ✅ $1"
}

utad_warn() {
  echo -e "${YELLOW}[UTAD Guard]${NC} ⚠️  $1"
}

# ── Skip guard for non-implementation files ────────────────
is_implementation_file() {
  local file="$1"
  # Skip UTAD own files, docs, configs, and test files themselves
  case "$file" in
    .utad/*|.claude/*|*.md|*.yml|*.yaml|*.json|*.toml|*.lock|*.gitignore)
      return 1 ;;
    *test*|*spec*|*__tests__*|*.test.*|*.spec.*)
      return 1 ;;
    *)
      return 0 ;;
  esac
}

# ── Main guard logic ───────────────────────────────────────
main() {
  # Skip if no file argument
  if [ -z "$TARGET_FILE" ]; then
    utad_warn "No target file specified. Skipping guard."
    exit 0
  fi

  # Skip non-implementation files
  if ! is_implementation_file "$TARGET_FILE"; then
    utad_banner "Non-implementation file — guard not required for: $TARGET_FILE"
    exit 0
  fi

  # Skip if UTAD is not initialised in this project
  if [ ! -d "$UTAD_DIR" ] || [ ! -f "$COVERAGE_MATRIX" ]; then
    utad_warn "UTAD not initialised (no .utad/ directory). Run install.sh first."
    exit 0
  fi

  utad_banner "Checking coverage for: $TARGET_FILE"

  # ── Check 1: Does any Test Instance reference this file or its feature? ──
  # Primary check: is the file mentioned in the coverage matrix?
  file_basename=$(basename "$TARGET_FILE" | sed 's/\.[^.]*$//')
  
  if grep -qi "$file_basename" "$COVERAGE_MATRIX" 2>/dev/null; then
    # Get the Task ID and status
    task_entry=$(grep -i "$file_basename" "$COVERAGE_MATRIX" | head -1)
    utad_pass "Found coverage entry: $task_entry"
    
    # Warn if status is PENDING
    if echo "$task_entry" | grep -qi "PENDING"; then
      echo ""
      utad_warn "This Task has coverage entries but status is PENDING."
      utad_warn "Test Instances have been defined but implementation hasn't been formally started."
      utad_warn "Run /utad-impl to begin implementation with proper anchoring."
      echo ""
    fi
    
    # Re-inject the relevant Test Instance into context
    echo ""
    echo -e "${CYAN}${BOLD}📋 Active Test Instances for this feature:${NC}"
    find "$TEST_INSTANCES_DIR" -name "TI-*.md" | while read -r ti_file; do
      # Show the first few lines of matching Test Instances
      if grep -qi "$file_basename" "$ti_file" 2>/dev/null; then
        echo -e "  ${GREEN}→${NC} $(basename $ti_file)"
        grep "^## WHEN" "$ti_file" | head -1 | sed 's/^/    /'
      fi
    done
    echo ""
    
    exit 0
  fi

  # ── Check 2: Does any Test Instance file exist? (for new features) ────────
  ti_count=$(find "$TEST_INSTANCES_DIR" -name "TI-*.md" 2>/dev/null | wc -l | tr -d ' ')
  
  if [ "$ti_count" -eq 0 ]; then
    utad_block "No Test Instances found in .utad/test-instances/.
    
Target file: $TARGET_FILE

This project has no Test Instances yet. Before writing any implementation:

  1. Run /utad-discover to map the user task landscape
  2. Run /utad-map to build the User Task tree
  3. Run /utad-test for each User Task you plan to implement
  4. Run /utad-check to verify coverage
  5. Then run /utad-impl to begin implementation

This is UTAD Iron Law #1: No Test Instance → No Implementation."
    exit 1
  fi

  # ── Check 3: File exists but no matching Test Instance ────────────────────
  utad_block "No Test Instance found covering: $TARGET_FILE

Before writing implementation code for this file, a Test Instance must exist
that covers the user-facing behaviour this code will provide.

Possible actions:
  • Run /utad-test to write a Test Instance for this feature
  • Run /utad-check to see the full coverage map
  • If this file IS covered by an existing Task, update coverage-matrix.md
    to include this file's path

Existing Test Instances in this project: $ti_count
Coverage matrix: $COVERAGE_MATRIX

This is UTAD Iron Law #1: No Test Instance → No Implementation."

  exit 1
}

main "$@"

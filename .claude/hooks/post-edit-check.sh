#!/usr/bin/env bash
# ============================================================
# UTAD Post-Edit Coverage Check Hook
# Runs after Claude Code writes to an implementation file.
# Audits coverage drift and logs uncovered code paths.
#
# Usage (Claude Code hooks config):
#   post_edit: bash .claude/hooks/post-edit-check.sh "$FILE"
# ============================================================

set -euo pipefail

TARGET_FILE="${1:-}"
UTAD_DIR=".utad"
COVERAGE_MATRIX="$UTAD_DIR/coverage-matrix.md"
DEBT_FILE="$UTAD_DIR/utad-debt.md"
TEST_INSTANCES_DIR="$UTAD_DIR/test-instances"

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

utad_info() { echo -e "${CYAN}[UTAD Post-Edit]${NC} $1"; }
utad_ok()   { echo -e "${GREEN}[UTAD Post-Edit]${NC} ✅ $1"; }
utad_warn() { echo -e "${YELLOW}[UTAD Post-Edit]${NC} ⚠️  $1"; }

# ── Skip non-implementation files ─────────────────────────
is_implementation_file() {
  local file="$1"
  case "$file" in
    .utad/*|.claude/*|*.md|*.yml|*.yaml|*.json|*.toml|*.lock|*.gitignore)
      return 1 ;;
    *test*|*spec*|*__tests__*|*.test.*|*.spec.*)
      return 1 ;;
    *)
      return 0 ;;
  esac
}

# ── Compute coverage stats ─────────────────────────────────
compute_coverage() {
  if [ ! -f "$COVERAGE_MATRIX" ]; then
    echo "0 0 0"
    return
  fi
  
  local total pending verified
  total=$(grep -c "^| UT-" "$COVERAGE_MATRIX" 2>/dev/null || echo 0)
  pending=$(grep -c "PENDING" "$COVERAGE_MATRIX" 2>/dev/null || echo 0)
  verified=$(grep -c "VERIFIED" "$COVERAGE_MATRIX" 2>/dev/null || echo 0)
  
  echo "$total $pending $verified"
}

# ── Log UTAD debt ──────────────────────────────────────────
log_debt() {
  local file="$1"
  local reason="$2"
  local date_str
  date_str=$(date '+%Y-%m-%d')
  
  if [ ! -f "$DEBT_FILE" ]; then
    cat > "$DEBT_FILE" << 'EOF'
# UTAD Debt Registry

Uncovered code paths that need Test Instances.
Run /utad-sync to review and prioritise.

EOF
  fi

  # Don't duplicate entries
  if grep -q "$file" "$DEBT_FILE" 2>/dev/null; then
    return
  fi

  cat >> "$DEBT_FILE" << EOF
## Debt Entry — $date_str
- File: $file
- Reason: $reason
- Priority: medium
- Action: Run /utad-test to write a Test Instance covering this file
- Resolved: [ ]

EOF
}

# ── Main ───────────────────────────────────────────────────
main() {
  [ -z "$TARGET_FILE" ] && exit 0
  ! is_implementation_file "$TARGET_FILE" && exit 0
  [ ! -d "$UTAD_DIR" ] && exit 0

  utad_info "Post-edit check for: $TARGET_FILE"

  # ── Coverage stats ─────────────────────────────────────
  read -r total pending verified <<< "$(compute_coverage)"

  if [ "$total" -gt 0 ]; then
    covered=$((total - pending))
    pct=$(( covered * 100 / total ))
    echo ""
    echo -e "  Coverage: ${GREEN}$covered${NC}/$total Tasks (${pct}%)"
    echo -e "  Verified: ${GREEN}$verified${NC} | Pending: ${YELLOW}$pending${NC}"
    echo ""
  fi

  # ── Check if this edit has test coverage ───────────────
  file_basename=$(basename "$TARGET_FILE" | sed 's/\.[^.]*$//')
  has_coverage=false

  if grep -qi "$file_basename" "$COVERAGE_MATRIX" 2>/dev/null; then
    has_coverage=true
  fi

  if $has_coverage; then
    utad_ok "Coverage confirmed for $TARGET_FILE"
    
    # ── Suggest updating status if still IN_PROGRESS ───
    if grep -i "$file_basename" "$COVERAGE_MATRIX" 2>/dev/null | grep -qi "IN_PROGRESS"; then
      utad_warn "Task still marked IN_PROGRESS in coverage matrix."
      utad_warn "When implementation is complete, run /utad-check to verify Acceptance Criteria."
      utad_warn "Then update status to VERIFIED or IMPLEMENTED."
    fi
  else
    utad_warn "No coverage entry found for $TARGET_FILE in coverage matrix."
    utad_warn "Logging to UTAD debt registry."
    log_debt "$TARGET_FILE" "File edited without corresponding Test Instance coverage"
    echo ""
    echo "  To resolve: run /utad-test to write a Test Instance for this feature."
    echo "  Then run /utad-check to update the coverage matrix."
    echo ""
  fi

  # ── Periodic debt reminder (every 10th edit) ───────────
  if [ -f "$DEBT_FILE" ]; then
    debt_count=$(grep -c "^## Debt Entry" "$DEBT_FILE" 2>/dev/null || echo 0)
    unresolved=$(grep -c "\[ \]" "$DEBT_FILE" 2>/dev/null || echo 0)
    
    if [ "$unresolved" -gt 5 ]; then
      echo ""
      utad_warn "UTAD Debt: $unresolved unresolved entries."
      utad_warn "Run /utad-sync to review and prioritise debt."
    fi
  fi
}

main "$@"

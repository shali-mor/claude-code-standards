#!/bin/bash
#
# Install Claude Code standards into the current repository.
#
# Usage (from internal GHE):
#   CLAUDE_STANDARDS_REPO=https://your-ghe-host/org/claude-code-standards \
#     curl -sL $CLAUDE_STANDARDS_REPO/raw/main/scripts/install.sh | bash
#
# Usage (from local copy):
#   CLAUDE_STANDARDS_LOCAL=/path/to/company_workflow bash /path/to/company_workflow/scripts/install.sh
#

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────
REPO_URL="${CLAUDE_STANDARDS_REPO:-}"
BRANCH="${CLAUDE_STANDARDS_BRANCH:-main}"
LOCAL_SOURCE="${CLAUDE_STANDARDS_LOCAL:-}"

# ── Colors ───────────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
fail()  { echo -e "${RED}[FAIL]${NC}  $1"; }

# ── Pre-flight checks ───────────────────────────────────────────────
if [ ! -d ".git" ] && [ -z "${FORCE:-}" ]; then
    warn "Not a git repository. Run from your repo root, or set FORCE=1 to continue anyway."
    exit 1
fi

if [ -z "$LOCAL_SOURCE" ] && [ -z "$REPO_URL" ]; then
    fail "Set CLAUDE_STANDARDS_REPO or CLAUDE_STANDARDS_LOCAL before running."
    echo "  Example: CLAUDE_STANDARDS_LOCAL=/path/to/company_workflow bash install.sh"
    exit 1
fi

echo ""
echo -e "${BOLD}Claude Code Standards Installer${NC}"
echo -e "Source: ${CYAN}${LOCAL_SOURCE:-$REPO_URL ($BRANCH)}${NC}"
echo ""

# ── Determine source ────────────────────────────────────────────────
if [ -n "$LOCAL_SOURCE" ]; then
    SOURCE_DIR="$LOCAL_SOURCE"
    if [ ! -f "$SOURCE_DIR/CLAUDE.md" ]; then
        fail "CLAUDE.md not found in $SOURCE_DIR"
        exit 1
    fi
else
    SOURCE_DIR=$(mktemp -d)
    trap 'rm -rf "$SOURCE_DIR"' EXIT

    info "Downloading from $REPO_URL ($BRANCH)..."
    if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$SOURCE_DIR" 2>&1; then
        fail "Git clone failed. Check CLAUDE_STANDARDS_REPO URL and your access."
        exit 1
    fi
fi

# ── Install files ────────────────────────────────────────────────────
FILES_INSTALLED=0

# CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    warn "CLAUDE.md already exists — backing up to CLAUDE.md.bak"
    cp CLAUDE.md CLAUDE.md.bak
fi
cp "$SOURCE_DIR/CLAUDE.md" .
ok "CLAUDE.md"
FILES_INSTALLED=$((FILES_INSTALLED + 1))

# .claude/ directory
if [ -d ".claude" ]; then
    warn ".claude/ already exists — merging (new files only, existing preserved)"
    # Copy only files that don't already exist
    find "$SOURCE_DIR/.claude" -type f | while read -r src; do
        rel="${src#$SOURCE_DIR/}"
        if [ ! -f "$rel" ]; then
            mkdir -p "$(dirname "$rel")"
            cp "$src" "$rel"
        fi
    done
else
    cp -r "$SOURCE_DIR/.claude" .
fi
ok ".claude/commands/ ($(find .claude/commands -name '*.md' 2>/dev/null | wc -l | tr -d ' ') commands)"
ok ".claude/skills/ ($(find .claude/skills -name '*.md' 2>/dev/null | wc -l | tr -d ' ') skills)"
FILES_INSTALLED=$((FILES_INSTALLED + 1))

# .mcp.json
if [ ! -f ".mcp.json" ]; then
    cp "$SOURCE_DIR/.mcp.json" .
    ok ".mcp.json (Atlassian integration)"
    FILES_INSTALLED=$((FILES_INSTALLED + 1))
else
    warn ".mcp.json already exists — skipped (check manually)"
fi

# commitlint.config.js
if [ ! -f "commitlint.config.js" ]; then
    cp "$SOURCE_DIR/commitlint.config.js" .
    ok "commitlint.config.js (Jira-prefixed commit messages)"
    FILES_INSTALLED=$((FILES_INSTALLED + 1))
else
    warn "commitlint.config.js already exists — skipped"
fi

# .pre-commit-config.yaml (optional)
if [ -f "$SOURCE_DIR/.pre-commit-config.yaml" ]; then
    if [ ! -f ".pre-commit-config.yaml" ]; then
        cp "$SOURCE_DIR/.pre-commit-config.yaml" .
        ok ".pre-commit-config.yaml (git hooks)"
        FILES_INSTALLED=$((FILES_INSTALLED + 1))
    else
        warn ".pre-commit-config.yaml already exists — skipped"
    fi
fi

# Append critical .gitignore entries if missing
GITIGNORE_ENTRIES=(".env" ".env.*" "*.tfstate" "*.tfstate.backup" ".terraform/" ".claude/settings.local.json" ".npmrc" ".pypirc" ".netrc")
if [ -f ".gitignore" ]; then
    ADDED=0
    for entry in "${GITIGNORE_ENTRIES[@]}"; do
        if ! grep -qF "$entry" .gitignore 2>/dev/null; then
            echo "$entry" >> .gitignore
            ADDED=$((ADDED + 1))
        fi
    done
    if [ "$ADDED" -gt 0 ]; then
        ok ".gitignore (appended $ADDED security entries)"
    fi
else
    cp "$SOURCE_DIR/.gitignore" .
    ok ".gitignore"
    FILES_INSTALLED=$((FILES_INSTALLED + 1))
fi

# ── Post-install ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installed $FILES_INSTALLED components.${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md — uncomment/remove stack sections for your repo"
echo "  2. Run '/mcp' in Claude Code to authenticate with Atlassian"
if command -v pre-commit &>/dev/null; then
    echo "  3. Run 'pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push' to activate all hooks"
else
    echo "  3. Run 'pip install pre-commit && pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push' for git hooks (optional)"
fi
echo ""

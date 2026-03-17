#!/bin/bash
#
# Install Claude Code standards into the current repository.
#
# Usage:
#   curl -sL https://github.cicd.cloud.fpdev.io/Forcepoint/claude-code-standards/raw/main/scripts/install.sh | bash
#
#   Or run locally:
#   bash /path/to/company_workflow/scripts/install.sh
#

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────
REPO_URL="${CLAUDE_STANDARDS_REPO:-https://github.cicd.cloud.fpdev.io/Forcepoint/claude-code-standards}"
BRANCH="${CLAUDE_STANDARDS_BRANCH:-main}"
LOCAL_SOURCE="${CLAUDE_STANDARDS_LOCAL:-}"

# ── Colors ───────────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }

# ── Pre-flight checks ───────────────────────────────────────────────
if [ ! -d ".git" ] && [ -z "${FORCE:-}" ]; then
    warn "Not a git repository. Run from your repo root, or set FORCE=1 to continue anyway."
    exit 1
fi

echo ""
echo -e "${BOLD}Claude Code Standards Installer${NC}"
echo -e "Source: ${CYAN}${LOCAL_SOURCE:-$REPO_URL ($BRANCH)}${NC}"
echo ""

# ── Determine source ────────────────────────────────────────────────
if [ -n "$LOCAL_SOURCE" ]; then
    # Copy from local path
    SOURCE_DIR="$LOCAL_SOURCE"
    if [ ! -f "$SOURCE_DIR/CLAUDE.md" ]; then
        warn "CLAUDE.md not found in $SOURCE_DIR"
        exit 1
    fi
else
    # Download from git
    SOURCE_DIR=$(mktemp -d)
    trap "rm -rf $SOURCE_DIR" EXIT

    info "Downloading from $REPO_URL ($BRANCH)..."
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$SOURCE_DIR" 2>/dev/null
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
    warn ".claude/ already exists — merging (existing files preserved)"
    cp -rn "$SOURCE_DIR/.claude/" .claude/ 2>/dev/null || cp -r "$SOURCE_DIR/.claude/" .claude/
else
    cp -r "$SOURCE_DIR/.claude" .
fi
ok ".claude/commands/ ($(ls .claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ') commands)"
ok ".claude/skills/ ($(ls .claude/skills/*.md 2>/dev/null | wc -l | tr -d ' ') skills)"
FILES_INSTALLED=$((FILES_INSTALLED + 1))

# .mcp.json
if [ ! -f ".mcp.json" ]; then
    cp "$SOURCE_DIR/.mcp.json" .
    ok ".mcp.json (Atlassian integration)"
    FILES_INSTALLED=$((FILES_INSTALLED + 1))
else
    warn ".mcp.json already exists — skipped (check manually)"
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

# ── Post-install ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installed $FILES_INSTALLED components.${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md — uncomment/remove stack sections for your repo"
echo "  2. Run '/mcp' in Claude Code to authenticate with Atlassian"
if command -v pre-commit &>/dev/null; then
    echo "  3. Run 'pre-commit install' to activate git hooks"
else
    echo "  3. Run 'pip install pre-commit && pre-commit install' for git hooks (optional)"
fi
echo ""

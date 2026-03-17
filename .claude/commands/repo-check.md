Validate repository structure against Forcepoint standards.

## Instructions

1. Check for required files at the repository root:

### Required (BLOCKING if missing)
- `README.md` — must exist and contain: service description, build instructions, test instructions, deploy instructions, team contact
- `CODEOWNERS` or `.github/CODEOWNERS` — must exist for PR routing
- `Jenkinsfile` — must exist if the repo uses Jenkins CI (check for `.jenkins` or Jenkins references)
- `.gitignore` — must exist

### Required (BLOCKING if missing)
- `.github/PULL_REQUEST_TEMPLATE.md` — must exist with sections: What, Why, How tested, Checklist

### Recommended (WARNING if missing)
- `CHANGELOG.md` — should exist, following keepachangelog.com format
- `CLAUDE.md` — should exist for Claude Code standards enforcement
- `.pre-commit-config.yaml` — should exist for git hooks
- `.mcp.json` — should exist for Atlassian integration

2. If `README.md` exists, check its content:

### README Quality (WARNING)
- Has a description/overview section
- Has build/install instructions
- Has test instructions
- Has deployment instructions or link
- Has team contact (Slack channel, email, or team name)
- Links to relevant Confluence pages

3. If `CODEOWNERS` exists, check:
- Not empty
- Covers at least the root directory (`*`)
- References valid team names or usernames

4. Check for anti-patterns:

### Anti-Patterns (WARNING)
- `.env` file committed (should be in .gitignore)
- `node_modules/`, `vendor/`, `__pycache__/` committed
- `*.tfstate` or `*.tfstate.backup` committed
- Large binary files (> 1MB) committed

## Output Format

```
REPOSITORY STRUCTURE CHECK:

REQUIRED FILES:
  [OK]      README.md
  [MISSING] CODEOWNERS — create .github/CODEOWNERS with team ownership
  [OK]      Jenkinsfile
  [OK]      .gitignore

RECOMMENDED FILES:
  [OK]      CHANGELOG.md
  [MISSING] .github/PULL_REQUEST_TEMPLATE.md
  [OK]      CLAUDE.md
  [MISSING] .pre-commit-config.yaml

README QUALITY:
  [OK]      Has description
  [WARNING] Missing test instructions
  [WARNING] Missing team contact

ANTI-PATTERNS:
  [WARNING] .env file found in repository — add to .gitignore

VERDICT: PASS / NEEDS FIXES / BLOCKED
```

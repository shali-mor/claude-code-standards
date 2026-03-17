Pull architecture docs from Confluence and update local standards.

## Instructions

You have access to Confluence via the MCP server. Use the Confluence search/read tools to:

## Arguments
$ARGUMENTS — Confluence space key or page URL (optional — searches all spaces if omitted)

### Key Confluence Spaces
When syncing Cloud DLP architecture, prioritize:
- **IT** — Infrastructure architecture docs (Cloud DLP Architecture, DPS architecture and deployment, DPS in Detail)
- **DSSEIP** — DPS development home (architecture overviews, EIP integration)
- **HIP** — Cloud DLP product (cloud backend architecture, release notes)
- **FPA** — Architecture (Project Streamline, DSPM architecture)
- **AS** — Application Security (pen testing, secure API design)
- **MRC1** — Cloud services (Portal Architecture, DPS for O365 Email)

### Step 1: Fetch Architecture Pages
Search Confluence for pages tagged or titled with:
- "Architecture" or "System Design"
- "Design Patterns"
- "API Standards" or "API Guidelines"
- "Security Standards" or "Security Policy"
- "Code Standards" or "Coding Guidelines"

Use CQL queries like: `type = page AND label = "architecture"` or search by space key if the user provides one.

### Step 2: Compare With Local Standards
Read the current CLAUDE.md and compare it against the Confluence documentation:
- Are there architecture decisions in Confluence not reflected in CLAUDE.md?
- Are there design patterns documented in Confluence that should be added?
- Are there security policies in Confluence stricter than what CLAUDE.md enforces?
- Are there naming conventions or coding standards that differ?

### Step 3: Present a Diff
Show the user:
```
ADDITIONS (in Confluence, missing from CLAUDE.md):
  - <rule or pattern from Confluence>

CONFLICTS (Confluence says X, CLAUDE.md says Y):
  - <specific conflict>

ALREADY ALIGNED:
  - <rules that match>
```

### Step 4: Ask Before Updating
Do NOT auto-update CLAUDE.md. Present the proposed changes and let the user approve each one.

### Usage
The user may specify a Confluence space or page URL:
- `/sync-architecture SPACE_KEY` — search within a specific space
- `/sync-architecture https://company.atlassian.net/wiki/spaces/ARCH/pages/12345` — sync from a specific page

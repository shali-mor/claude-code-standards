Review code changes in context of past incidents to prevent regressions.

## Arguments
$ARGUMENTS — Service name or component (optional)

## Key Confluence Spaces for Incident Context
- **IT** — Infrastructure architecture (Cloud DLP Architecture, DPS in Detail)
- **AS** — Application Security (pen testing scopes, security findings)
- **HIP** — Cloud DLP product (production releases, known issues)
- **DSSEIP** — DPS development (architecture, deployment patterns)

## Instructions

### Step 1: Find Past Incidents
Use the Atlassian MCP tools to search Jira:
- `type = Bug AND priority in (Critical, Blocker) AND status = Done`
- `labels in ("incident", "postmortem", "regression")`
- If $ARGUMENTS provided, filter by component: `component = $ARGUMENTS`

Also search Confluence for postmortem pages:
- `label = "postmortem" OR label = "incident-report"`

### Step 2: Extract Patterns
From past incidents, identify:
- Root causes (what category of bug: auth bypass, data leak, race condition, etc.)
- Which code areas were involved
- What fixes were applied
- What prevention measures were recommended

### Step 3: Check Current Code
Review the current changes (`git diff`) against the incident patterns:
- Does this change touch an area that had a past incident?
- Does this change introduce a pattern similar to a past root cause?
- Are the recommended prevention measures from postmortems being followed?

### Step 4: Output
```
RELEVANT PAST INCIDENTS:
  [1] INC-456: Data leak via unfiltered API response (2024-11)
      Root cause: domain entity serialized directly to response
      Prevention: always use DTOs
      Current code risk: <assessment>

  [2] INC-789: Auth bypass on admin endpoint (2025-01)
      Root cause: missing auth middleware on new route
      Prevention: auth required by default on all endpoints
      Current code risk: <assessment>

RISK ASSESSMENT:
  - High risk areas: <list or "none detected">
  - Recommendations: <specific actions>
```

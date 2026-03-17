Implement a Jira ticket with full context from Jira and Confluence.

## Arguments
$ARGUMENTS — Jira ticket ID (e.g. DLP-1234)

## Jira Project Keys
- **DPS** — DPS development team tickets
- **IPD** — DevOps/infrastructure tickets
- **NEO** — NEO Portal tickets
- **DSA** — Cloud DLP Agent (DSE) tickets
- **DSPM** — Data Security Posture Management tickets
- **UEP** — Unified Endpoint tickets
- **EA** — Enterprise Architecture tickets
- **WSM** — Web Security Manager tickets
- **ROC** — DSPM QA/monitoring tickets

## Instructions

### Step 1: Fetch Ticket Context
Use the Atlassian MCP tools to read the Jira ticket $ARGUMENTS. Extract:
- Summary and description
- Acceptance criteria
- Linked tickets (blockers, related, epic)
- Comments with implementation notes
- Labels and components (to identify which repo/module this belongs to)

Present a summary:
```
TICKET: $ARGUMENTS
  Summary: <title>
  Acceptance Criteria:
    - <criterion 1>
    - <criterion 2>
  Linked: <related tickets>
  Component: <target module/service>
```

### Step 2: Fetch Related Architecture Docs
Search Confluence for:
- Architecture docs related to the ticket's component/label
- Design patterns used by the target service
- Any linked Confluence pages from the ticket itself

### Step 3: Fetch Architecture Decision Records
Search Jira for ADR tickets related to this component:
- Look for tickets labeled "ADR" or "architecture-decision" in the same project/component
- Summarize relevant decisions that constrain this implementation

### Step 4: Design the Implementation
Following CLAUDE.md standards and existing patterns from Confluence:
- Propose the implementation approach
- Map acceptance criteria to specific code changes
- Identify which layers need changes (domain, usecase, adapter)
- Write a test plan covering each acceptance criterion

Wait for user approval before writing code.

### Step 5: Implement
Follow the `/new-feature` implementation order:
1. Domain → 2. Ports → 3. Use cases → 4. Tests → 5. Adapters → 6. Integration tests

### Step 6: Prepare Commit
Use the ticket ID in the commit message:
```
$ARGUMENTS: <short description of what was done>
```

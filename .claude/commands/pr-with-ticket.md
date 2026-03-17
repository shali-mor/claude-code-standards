Create a PR linked to a Jira ticket with full traceability.

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

### Step 1: Fetch Ticket Details
Use the Atlassian MCP tools to read $ARGUMENTS from Jira. Extract:
- Summary
- Acceptance criteria
- Component/labels

### Step 2: Analyze Changes
Detect the base branch (check for `main`, `master`, or `develop`). Run `git log <base>..HEAD --oneline` and `git diff <base>...HEAD` to understand all changes in this branch.

### Step 3: Map Changes to Acceptance Criteria
For each acceptance criterion from the ticket, identify which code changes satisfy it.

### Step 4: Create the PR
Create the PR with this format:

```markdown
## $ARGUMENTS: <ticket summary>

**Jira:** https://forcepoint.atlassian.net/browse/$ARGUMENTS

## What
<1-3 sentences>

## Why
<motivation from the ticket description>

## Acceptance Criteria Mapping
- [x] <criterion 1> — implemented in `file:line`
- [x] <criterion 2> — implemented in `file:line`
- [ ] <criterion not addressed> — reason

## Architecture Impact
- Layers modified: <list>
- New interfaces/ports: <list or "none">
- API changes: <list or "none">
- Follows patterns from: <Confluence page if referenced>

## Security Considerations
- Data classification impact: <any or "none">
- Auth/authz changes: <any or "none">

## Testing
- [ ] Unit tests cover all acceptance criteria
- [ ] Integration tests for adapter changes
- [ ] Security-critical paths have full branch coverage

## Checklist
- [ ] Dependency rule respected
- [ ] No business logic in adapters
- [ ] Domain entities not exposed in API
- [ ] No hardcoded secrets
- [ ] Sensitive data not logged
```

### Step 5: Push and Create
Push the branch and create the PR using `gh pr create`. Return the PR URL.

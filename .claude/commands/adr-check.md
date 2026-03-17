Review Architecture Decision Records (ADRs) relevant to current work.

## Arguments
$ARGUMENTS — Component name, service name, or Jira project key (optional)

## Instructions

### Step 1: Find ADRs
Use the Atlassian MCP tools to search Jira for ADR tickets:
- Search query: `labels = "ADR" OR labels = "architecture-decision" OR summary ~ "ADR"`
- If $ARGUMENTS is provided, filter by component or project: `project = $ARGUMENTS`
- Also search Confluence for pages titled or labeled "ADR" or "Architecture Decision Record"

### Step 2: Summarize Active ADRs
For each ADR found, extract:
```
ADR-XXX: <title>
  Status: Accepted / Proposed / Superseded
  Decision: <one-line summary of what was decided>
  Constraints: <what this prohibits or requires>
  Applies to: <which services/modules>
```

### Step 3: Check Current Code Against ADRs
If there are code changes (unstaged or recent commits), verify they don't violate any active ADR:
- Flag any conflict between current code and an accepted ADR
- Note if an ADR should be updated based on new requirements

### Step 4: Output
```
ACTIVE ADRs (X found):
  [1] ADR-101: Use event-driven architecture for inter-service communication
      → Constraint: no synchronous HTTP between microservices
  [2] ADR-102: PostgreSQL as primary data store
      → Constraint: no new NoSQL datastores without new ADR

VIOLATIONS IN CURRENT CODE:
  - <file:line> violates ADR-101: direct HTTP call to payment-service
  - none found ✓

PROPOSED ADRs (not yet accepted):
  - ADR-110: Migrate to gRPC for internal APIs (under review)
```

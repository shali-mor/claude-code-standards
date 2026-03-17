Design a new feature based on existing architecture patterns from Confluence.

## Arguments
$ARGUMENTS — Feature description or keywords to search for existing patterns

## Key Confluence Spaces
When searching for Cloud DLP architecture and patterns, prioritize:
- **IT** — Infrastructure architecture docs (Cloud DLP Architecture, DPS architecture and deployment, DPS in Detail)
- **DSSEIP** — DPS development home (architecture overviews, EIP integration)
- **HIP** — Cloud DLP product (release notes, DPS analytics, cloud backend architecture)
- **FPA** — Architecture (Project Streamline, DSPM architecture)
- **PM** — Product management (feature specs)
- **MRC1** — Cloud services (DPS for O365 Email, Portal Architecture)

## Instructions

The user wants to implement a new feature. Before designing, pull relevant context from Confluence.

### Step 1: Understand the Feature
Ask the user:
- What is the feature?
- Which service/repo will it live in?
- Are there existing Confluence pages related to this feature? (space key, page URL, or keywords)

### Step 2: Pull Relevant Confluence Pages
Search Confluence for:
- Architecture diagrams or design docs for the target service
- Existing design patterns used in similar features
- API contracts or integration specs this feature needs to follow
- Data models or entity relationship docs

Summarize what you found:
```
RELEVANT CONFLUENCE DOCS:
  [1] "Payment Service Architecture" (ARCH-123) — describes the event-driven pattern used for all payment flows
  [2] "API Design Guidelines v2" (STD-456) — REST conventions, pagination, error format
  [3] ...
```

### Step 3: Design the Feature Following Existing Patterns
Based on the Confluence docs AND the CLAUDE.md standards:
- Propose the design using the same patterns the team already uses
- Call out where the new feature aligns with existing architecture
- Call out where the new feature might need a NEW pattern (and why)

### Step 4: Present for Review
Show the design as:
- Domain model changes
- Use case / service layer
- API contract (if applicable)
- Integration points with existing services
- Test plan

Reference specific Confluence pages: "Following the pattern from [Page Title], this service should..."

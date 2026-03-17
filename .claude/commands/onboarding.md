Onboard a developer to a service by pulling all relevant context from Jira and Confluence.

## Arguments
$ARGUMENTS — Service name, repo name, or Confluence space key

## Key Confluence Spaces
When searching Confluence for Cloud DLP context, prioritize these spaces:
- **IT** — Infrastructure architecture docs (Cloud DLP Architecture, DPS architecture and deployment, DPS in Detail)
- **DSSEIP** — DPS development home (architecture overviews, onboarding plans, EIP integration)
- **HIP** — Cloud DLP product (release notes, DPS analytics, cloud backend architecture)
- **PM** — Product management (feature specs like OCR for DPS)
- **EP** — Engineering program (PI planning, onboarding plans, Cloud DLP with DSE Agent)
- **AS** — Application Security (pen testing scopes, secure API design)
- **FPA** — Architecture (Project Streamline, DSPM architecture)
- **MRC1** — Cloud services (DPS for O365 Email, Portal Architecture)

## Key Jira Projects
- **DPS** — DPS development team tickets
- **IPD** — DevOps/infrastructure tickets
- **NEO** — NEO Portal tickets
- **DSA** — Cloud DLP Agent (DSE) tickets
- **DSPM** — Data Security Posture Management tickets
- **UEP** — Unified Endpoint tickets

## Instructions

### Step 1: Gather Documentation
Use the Atlassian MCP tools to find:

**From Confluence:**
- Architecture overview / system design docs for $ARGUMENTS
- API documentation
- Onboarding guides or README-type pages
- Runbooks and operational docs
- Data model / ERD diagrams

**From Jira:**
- Active epics and current sprint work for $ARGUMENTS
- Recent completed tickets (last 30 days) to understand recent changes
- Open bugs to be aware of
- ADRs related to this service

### Step 2: Analyze the Codebase
Read the local codebase structure and identify:
- Tech stack and frameworks used
- Architecture pattern (clean arch, layered, etc.)
- Key entry points (main, routes, controllers)
- Configuration and environment setup
- Test setup and how to run tests
- Build and deployment process

### Step 3: Present the Onboarding Guide

```
SERVICE: $ARGUMENTS
═══════════════════

ARCHITECTURE:
  Pattern: <clean architecture / layered / etc.>
  Key docs: <Confluence page links>

TECH STACK:
  <language, framework, DB, message queue, etc.>

HOW TO RUN:
  Build: <command>
  Test: <command>
  Local dev: <command or setup steps>

KEY AREAS:
  Entry point: <file>
  Domain logic: <directory>
  API layer: <directory>
  Config: <file>

CURRENT WORK:
  Active epic: <title> — <brief description>
  Sprint focus: <what the team is working on now>
  Recent changes: <summary of last 30 days>

KNOWN ISSUES:
  <open bugs to be aware of>

ARCHITECTURE DECISIONS:
  <relevant ADRs and their constraints>

STANDARDS:
  This repo follows the company standards in CLAUDE.md.
  Key rules for this service: <highlight most relevant rules>
```

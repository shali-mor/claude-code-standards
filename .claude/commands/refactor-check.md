Evaluate a proposed refactoring against architecture standards and ADRs.

## Arguments
$ARGUMENTS — Description of the refactoring or file/module to refactor

## Instructions

### Step 1: Understand the Scope
Identify what's being refactored:
- Which files/modules are affected?
- What is the current structure vs. the desired structure?
- What motivates this refactoring?

### Step 2: Pull Constraints
Use the Atlassian MCP tools to check:
- **ADRs** that constrain this area (search Jira for architecture decisions related to this module)
- **Confluence docs** with architecture diagrams or design docs for this area
- **Open tickets** that depend on the current structure (refactoring might break in-flight work)

### Step 3: Evaluate the Refactoring

**Architecture alignment:**
- Does the refactoring move the code CLOSER to clean architecture (CLAUDE.md standards)?
- Does it respect the dependency rule?
- Does it violate any ADR?

**Risk assessment:**
- How many files change?
- Are there downstream consumers of the code being refactored?
- Is there sufficient test coverage to catch regressions?
- Does this touch security-critical code?

**Incremental path:**
- Can this be done incrementally (strangler fig pattern) or must it be a big bang?
- Propose a step-by-step approach if incremental is possible

### Step 4: Output
```
REFACTORING: $ARGUMENTS

CONSTRAINTS:
  ADRs: <relevant decisions>
  In-flight work: <tickets that might conflict>
  Test coverage: <sufficient / insufficient for safe refactoring>

ASSESSMENT:
  Architecture improvement: <yes/no — how>
  Risk level: LOW / MEDIUM / HIGH
  Recommended approach: <incremental / big-bang>

PLAN:
  Step 1: <specific action>
  Step 2: <specific action>
  ...

BLOCKERS:
  - <anything that should be resolved first, or "none">
```

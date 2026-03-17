Review the current changes against company architecture and security standards.

## Instructions

1. Run `git diff` to see all staged and unstaged changes. If there are no changes, run `git diff HEAD~1` to review the last commit.

2. For EACH changed file, evaluate against this checklist and report violations:

### Architecture Violations (BLOCKING)
- Domain/core layer imports framework or infrastructure code
- Business logic exists in a controller, handler, or adapter
- Domain entity is directly exposed in an API response
- Missing interface/port for an external dependency
- Cross-module direct dependency (bypassing defined APIs)

### Security Violations (BLOCKING)
- Sensitive data (CONFIDENTIAL/RESTRICTED) logged or exposed in responses
- Hardcoded secrets, tokens, API keys, or passwords
- SQL built via string concatenation
- User input reaches domain logic without validation
- Missing authentication or authorization on an endpoint
- Dependency with known CVE added

### Code Quality Issues (WARNING)
- Missing tests for new/changed behavior
- TODO/FIXME without a linked ticket reference
- Overly broad exception catch (catching Exception/BaseException)
- Dead code or unused imports
- Magic numbers or strings without named constants
- Method/function exceeding 30 lines (suggest extraction)
- Commit messages not starting with Jira ticket number (format: `NEO-1234 Fix ...`)
- Missing SonarQube Quality Gate pass
- New UI components not behind a feature flag

### Naming & Convention Issues (WARNING)
- Class/function name doesn't match the naming conventions in CLAUDE.md
- File placed in wrong layer/package based on its responsibility

## Output Format

For each violation found:
```
[BLOCKING|WARNING] file:line — Rule violated
  → What's wrong: <description>
  → Fix: <specific action to take>
```

End with a summary:
- Total BLOCKING violations (PR must not merge)
- Total WARNINGS (should fix, but not blocking)
- Overall assessment: PASS / NEEDS FIXES / BLOCKED

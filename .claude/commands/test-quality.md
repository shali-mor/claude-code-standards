Evaluate test quality and coverage against company standards.

## Instructions

1. Identify the test framework and structure in the project.

2. For each source file with business logic, check:

### Coverage Analysis
- Does a corresponding test file exist?
- Are happy-path scenarios covered?
- Are failure/edge-case scenarios covered?
- For security-critical code (auth, policy evaluation, data classification): are ALL branches covered?

### Test Quality
- Tests assert **behavior**, not implementation (no mocking internal methods, no asserting call counts on internal collaborators)
- Tests are independent — no shared mutable state, no ordering dependency
- Test names describe the scenario clearly (not `test1`, `testMethod`, `it works`)
- No disabled/skipped tests without a ticket reference in comment
- Mocking is at adapter boundaries only — domain logic is tested with real objects

### Anti-Patterns to Flag
- Testing private methods directly (test through public API instead)
- Excessive mocking that makes the test a mirror of the implementation
- Assert-free tests (tests that run code but never assert outcomes)
- Tests that pass regardless of implementation (tautological assertions)
- Flaky indicators: sleep/delay calls, time-dependent assertions, shared external state

## Output Format

```
FILE: src/.../PolicyService.java
  Tests: src/.../PolicyServiceTest.java
  Coverage: happy-path ✓, error cases ✗ (missing: invalid policy format, expired policy)
  Quality issues:
    - [WARNING] line 45: mocks internal domain method instead of testing through port
    - [WARNING] line 78: test name "testEvaluate" doesn't describe scenario

UNTESTED FILES:
  - src/.../NewFeature.java — NO test file found [BLOCKING]

SUMMARY:
  Files with tests: X/Y
  Quality issues: N warnings, M blocking
  Verdict: PASS / NEEDS WORK
```

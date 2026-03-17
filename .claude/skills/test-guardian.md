---
name: test-guardian
description: Ensures every code change includes proper tests. Activates when Claude writes production code.
trigger: always
---

# Test Guardian

Every production code change MUST be accompanied by tests. No exceptions.

## Rules

### When Writing New Code
- After writing production code, ALWAYS write the corresponding tests before considering the task done
- Implementation order: domain tests first → use-case tests → adapter/integration tests
- Ask the user "Should I write the tests now?" only if you're unsure about the scope — otherwise just write them

### Test Structure
- One test file per production file
- Test file mirrors the source path: `src/domain/Policy.java` → `test/domain/PolicyTest.java`
- Group tests by behavior, not by method name

### What to Test
- **Domain logic**: test all business rules with unit tests, no mocks needed (pure logic)
- **Use cases**: test with mocked output ports, real domain objects
- **Adapters**: integration tests with real infrastructure (test DB, test server)
- **Security-critical paths**: 100% branch coverage — test every authorization check, every validation rule

### What NOT to Do
- Don't mock domain objects when testing use cases — use real ones
- Don't test getters/setters or trivial code
- Don't write tests that mirror implementation (testing that methodX was called N times)
- Don't use `@Disabled` / `skip` / `xit` without a ticket reference

### Naming Convention
Test names must describe the scenario:
- Java: `shouldRejectPolicy_whenClassificationIsRestricted_andUserLacksPermission`
- Python: `test_reject_policy_when_classification_restricted_and_user_lacks_permission`
- React: `it('rejects policy when classification is restricted and user lacks permission')`

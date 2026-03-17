Analyze the repository's architecture for dependency rule violations.

## Instructions

1. Identify the project's stack (Java/Python/React) from the file structure.

2. Map the dependency graph between layers by scanning imports:
   - For Java: scan `import` statements in each package
   - For Python: scan `from ... import` and `import` statements
   - For React/TS: scan `import` statements and path aliases

3. Check for these violations:

### Inward Dependency Rule
The allowed dependency direction is: `adapter → usecase/application → domain`

Flag every import where:
- A **domain** class imports from `adapter`, `infrastructure`, `config`, or `usecase/application`
- A **usecase/application** class imports from `adapter`, `infrastructure`, or `config`
- A **controller/handler** contains business logic (conditionals that make domain decisions)

### Port/Adapter Integrity
- Every external dependency (DB, HTTP client, message queue, file system) must be accessed through an interface defined in the domain/application layer
- Flag any direct usage of framework/infrastructure classes in use-case layer

### Cross-Module Boundaries
- Modules must communicate through their public API (interfaces), not by importing internal classes
- Flag any import that reaches into another module's internal packages

## Output Format

```
DEPENDENCY GRAPH:
  domain/ → (no outward dependencies) ✓ or ✗
  usecase/ → domain/ ✓, adapter/ ✗ (violation)
  adapter/ → usecase/, domain/ ✓

VIOLATIONS:
  [1] src/.../SomeUseCase.java:15 — imports com.company.adapter.persistence.JpaRepo
      → UseCase must depend on a port interface, not the JPA implementation
      → Fix: create a port interface in domain/port/ and inject it

VERDICT: CLEAN / X VIOLATIONS FOUND
```

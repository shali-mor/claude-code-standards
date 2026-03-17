Guide the implementation of a new feature following company architecture standards.

## Instructions

The user will describe a feature. Before writing ANY code:

### Step 1: Identify the Scope
- Which layer(s) does this feature touch? (domain, use-case, adapter, frontend)
- Which module/bounded-context does it belong to?
- Does it require a new API endpoint?

### Step 2: Design First
Present the user with:
- **Domain model changes**: new entities, value objects, or modifications to existing ones
- **Port interfaces**: any new ports (input/output) needed
- **Use case**: the application service that orchestrates the feature
- **Adapter changes**: controllers, repositories, external service clients
- **DTO contracts**: request/response shapes for any new API
- **Test plan**: what needs to be tested at each layer

Wait for user approval before proceeding to code.

### Step 3: Implementation Order
Always implement in this order:
1. Domain model (entities, value objects, domain events)
2. Port interfaces (input ports, output ports)
3. Use case / application service
4. Unit tests for domain + use case (with port mocks at boundary)
5. Adapter implementations (controller, repository)
6. Integration tests
7. Frontend changes (if applicable)

### Step 4: Self-Review
Before presenting the code, run the `/review` command mentally against your own output:
- Dependency rule respected?
- No business logic in adapters?
- Domain entities not exposed in API?
- Input validation at boundaries?
- Tests cover happy path + failure cases?
- Sensitive data handled per classification?

If any check fails, fix it before showing the code to the user.

## Output Format

Present the design as:
```
FEATURE: <feature name>

SCOPE:
  Layers: <domain / usecase / adapter / frontend>
  Module: <target module or bounded context>
  New API: <yes / no>

DESIGN:
  Domain changes: <entities, value objects, events>
  Ports: <new input/output ports>
  Use case: <application service description>
  Adapters: <controllers, repositories, clients>
  DTOs: <request/response shapes>

TEST PLAN:
  - <what to test at each layer>

RISKS:
  - <anything that needs attention>
```

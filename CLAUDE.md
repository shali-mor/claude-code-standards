# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **This is a company-wide standards template.** Copy the `.claude/` folder and this `CLAUDE.md`
> into each organization repository. Adapt the stack-specific sections to match the repo's technology.

---

## Architecture Principles (Non-Negotiable)

These rules apply to ALL repositories. Claude MUST refuse to write code that violates them.

### Dependency Rule
- Dependencies point **inward only**: `adapter → usecase → domain`
- Domain/core modules MUST NOT import from infrastructure, frameworks, or adapters
- Use interfaces (ports) in the domain layer; implement them in the adapter/infrastructure layer
- If you find yourself importing a framework class inside domain logic, you are violating this rule — stop and refactor

### Separation of Concerns
- **One responsibility per class/module.** If a class name contains "And" or does two things, split it.
- Controllers/handlers: input validation, delegation, response mapping — NO business logic
- Services/use-cases: orchestration of domain operations — NO HTTP/DB/framework concerns
- Repositories/adapters: data access only — NO business decisions

### API Contracts
- All external-facing APIs MUST be versioned (`/api/v1/...`)
- Request/response DTOs are separate from domain models — never expose domain entities directly
- Breaking changes require a new API version, not modification of existing endpoints

### Error Handling
- Use domain-specific exception/error types, not generic exceptions
- Errors must propagate through defined boundaries (domain → application → adapter)
- Never swallow exceptions silently — log or rethrow with context

---

## Security Standards (DLP Context)

These are mandatory for a security company. Violations are blocking.

### Data Classification
- All data models MUST document their sensitivity level: `PUBLIC`, `INTERNAL`, `CONFIDENTIAL`, `RESTRICTED`
- `CONFIDENTIAL` and `RESTRICTED` data must be encrypted at rest and in transit
- Log statements MUST NOT contain `CONFIDENTIAL` or `RESTRICTED` field values — log identifiers only

### Authentication & Authorization
- All endpoints (except health checks) require authentication
- Authorization checks happen at the use-case layer, not in controllers
- Use role-based or attribute-based access control — no ad-hoc permission checks scattered in code
- Tokens/secrets: never hardcoded, never in version control, always loaded from vault/env

### Input Validation
- Validate ALL external input at the adapter boundary before it reaches the domain
- Use allowlists over denylists for input validation
- SQL: parameterized queries only — no string concatenation
- Frontend: sanitize all rendered user content (XSS prevention)

### Dependency Security
- No dependencies with known critical/high CVEs
- Pin dependency versions — no floating ranges in production
- Minimal dependency principle: justify every new dependency

---

## Code Review Standards

Claude MUST apply these when reviewing code or writing code meant for review.

### Every PR Must
- Solve exactly ONE concern (feature, bugfix, or refactoring — not mixed)
- Have a clear description of WHAT changed and WHY
- Include tests that cover the changed behavior
- Pass all existing tests — no "fix later" broken tests
- Have no TODO/FIXME without a linked ticket

### Review Checklist (applied by `/review` command)
- [ ] Dependency rule respected (no inward layer importing outward layer)
- [ ] No business logic in controllers/adapters
- [ ] No domain model exposed in API responses
- [ ] Sensitive data not logged or exposed
- [ ] Input validation at boundaries
- [ ] Error handling uses domain-specific types
- [ ] New public APIs are versioned
- [ ] Tests cover happy path AND failure cases
- [ ] No hardcoded secrets, URLs, or environment-specific values

---

## Testing Standards

### Coverage Requirements
- New code: minimum 80% line coverage
- Critical paths (security decisions, data classification, policy evaluation): 100% branch coverage
- Coverage must not decrease on any PR

### Test Pyramid
- **Unit tests** (majority): test domain logic in isolation, no I/O, no frameworks
- **Integration tests**: test adapter implementations against real dependencies (DB, APIs)
- **E2E tests**: test critical user workflows end-to-end, kept minimal

### Test Quality Rules
- Tests must assert behavior, not implementation details
- No test should depend on another test's state or execution order
- Mock external dependencies at adapter boundaries, not inside domain logic
- Test names describe the scenario: `should_reject_policy_when_classification_is_restricted`
- No `@Disabled` / `skip` / `xit` without a linked ticket explaining why

---

## Architecture Reality

The Clean Architecture principles above represent our target state. The current codebase has legacy patterns:

### NEO Control Plane
- **Current state**: Single git repo (`DUP-Backend`), packaged as an uber JAR on AWS Beanstalk
- **Target state**: Containerized services (ECS) with clean architecture boundaries
- **Guidance**: For new code, follow clean architecture strictly. For modifications to existing code, improve the architecture incrementally — extract concerns where possible without large rewrites. Never make the architecture worse.

### DPS Data Plane
- **Current state**: Per-tenant monolithic deployments on Kubernetes, managed via Terraform
- **Target state**: Multi-tenant architecture (long-term)
- **Guidance**: Maintain clean separation between tenant configuration (Terraform) and application logic. New features should be tenant-agnostic where possible.

When the architecture gatekeeper flags existing legacy code, evaluate whether fixing the violation is in scope for the current change. If not, document it as a TODO with a Jira ticket reference.

---

## Stack-Specific Rules

### Java (Backend)
- Clean Architecture with hexagonal ports & adapters
- Package structure: `com.company.{module}.{domain|usecase|adapter.in|adapter.out|config}`
- Domain classes are plain Java — no Spring/JPA annotations in domain layer
- Use records for value objects and DTOs
- Constructor injection only — no field injection
- Follow Google Java Style Guide
- Build: Gradle or Maven — single command `./gradlew build` or `./mvnw verify` must compile + test

### Python (Services)
- Follow the same Clean Architecture principles adapted to Python
- Package structure: `{service}/{domain|application|infrastructure|api}/`
- Type hints required on all public functions
- Use Pydantic for DTOs and validation at boundaries
- Use ABC (Abstract Base Classes) for port interfaces
- Follow PEP 8 + Black formatter
- Build: `pytest` for tests, `pip-compile` for pinned dependencies

### React (Frontend)
- Feature-based folder structure: `src/features/{feature}/{components,hooks,api,types}/`
- Shared UI in `src/components/ui/` — no business logic in shared components
- State management: colocate state as low as possible, lift only when necessary
- API calls happen in dedicated hooks/services, never inside components directly
- TypeScript strict mode — no `any` types except at external API boundaries with runtime validation
- Accessibility: all interactive elements must be keyboard navigable and have ARIA labels

### AWS (Cloud Infrastructure)
- **Lambda**: single-purpose functions, handle cold starts gracefully, use environment variables for config, log structured JSON, set appropriate timeout/memory, avoid storing state locally, configure DLQ for async invocations
- **DynamoDB**: always use SDK parameterized queries, define GSI/LSI for access patterns upfront, handle throttling with exponential backoff, enable encryption at rest and point-in-time recovery for production tables
- **IoT Core / MQTT**: validate device identity on connection, use per-device X.509 certificates, never log full MQTT payloads (may contain sensitive endpoint data), use IoT Rules for routing not business logic
- **Beanstalk** (legacy — migrating to ECS): minimize deployment artifact size, health check endpoints required, environment-specific config via .ebextensions or environment variables only
- **S3**: enable server-side encryption for all buckets handling forensics or policy data, enforce bucket policies blocking public access, use pre-signed URLs with short TTL (max 15 min) for endpoint access, classify all buckets by data sensitivity
- **Kinesis**: use enhanced fan-out for critical alert consumers, handle shard iterator expiry, ensure idempotent consumers
- **Cognito/Auth**: use Cognito user pools with SAML federation (MSFT AD, Okta), never store tokens in frontend localStorage (use httpOnly cookies), validate JWT claims on every API Gateway call

### Kubernetes (DPS Data Plane)
- Per-tenant deployment model: each tenant gets Route53 entry, Ingress CRD, and dedicated pods (min 2 for HA)
- All services run in `dpaas-production` namespace
- Nginx ingress controller for routing — TLS required on all tenant endpoints
- HPA scaling: Sync services scale on container CPU (REST: 600m, CPE: 2400m thresholds). Async services scale via KEDA on SQS queue length
- Always set resource requests AND limits on all containers (DPS services are memory-sensitive)
- Use `topologySpreadConstraints` for cross-AZ distribution
- Liveness and readiness probes required on all services
- No hardcoded tenant IDs or region-specific values in manifests — use Terraform variables

### Terraform (Infrastructure as Code)
- Module structure: one module per resource type, composed in environment-specific configs
- State must be stored in S3 with DynamoDB locking — never local state in production
- All secrets via AWS Secrets Manager or SSM Parameter Store, never in .tf files — mark sensitive variables with `sensitive = true`
- Tag all resources with: `team`, `environment`, `tenant` (where applicable), `cost-center`
- DPS batch deployment: changes deploy via Lambda-triggered Terraform in batches of 10 tenants from NEO tenant registry (DynamoDB)
- Plan before apply: `terraform plan` output must be reviewed before any production apply
- Provider versions pinned, no deprecated resource types

### Multi-Region Deployment
- Deployed in 4+ regions: us-east-1, eu-central-1, ap-south-1, ap-southeast-1
- Data residency: customer data must remain in the region where the tenant is provisioned
- DPS currently has NO automatic regional failover — design for HA within a region (multi-AZ), flag any cross-region data movement
- Route53 entries are per-tenant — changes must be coordinated with tenant registry
- Test deployments in non-production regions first

### CI/CD (Jenkins)
- Pipeline stages: Build → Unit Test → Integration Test → Deploy DEV → Deploy Stage → Deploy Production
- Single-click deployment via Jenkins — never bypass pipeline stages for production
- DPS uses Terraform-based batch deployments triggered by Lambda
- NEO Backend deploys as uber JAR to Beanstalk (legacy, migrating to containers)
- All deployments must pass security scanning before production
- Deployment frequency: every 2 weeks + hotfixes
- Rollback plan required for every production deployment

---

## Naming Conventions

| Layer | Java | Python | React/TS |
|-------|------|--------|----------|
| Domain entity | `Policy` | `Policy` | `Policy` |
| Use case | `EvaluatePolicyUseCase` | `EvaluatePolicyUseCase` | `useEvaluatePolicy` |
| Input port | `EvaluatePolicyPort` | `EvaluatePolicyPort` | `EvaluatePolicyService` |
| Output port | `PolicyRepository` | `PolicyRepository` | `PolicyApi` |
| Controller | `PolicyController` | `PolicyRouter` | N/A |
| DTO (request) | `EvaluatePolicyRequest` | `EvaluatePolicyRequest` | `EvaluatePolicyParams` |
| DTO (response) | `PolicyResponse` | `PolicyResponse` | `PolicyResponse` |

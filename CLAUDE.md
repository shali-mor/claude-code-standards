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
- All list endpoints must support pagination — use cursor-based pagination by default
- POST and PUT operations must support idempotency keys via `Idempotency-Key` header
- Error responses must follow a standard envelope: `{ "error": { "code": "POLICY_NOT_FOUND", "message": "...", "traceId": "...", "details": [...] } }`
- Include `X-Request-Id` / `X-Trace-Id` in all responses for correlation
- Document deprecation via `Sunset` header and minimum 6-month support window for deprecated versions

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

### CSRF Protection
- All state-changing endpoints (POST, PUT, DELETE, PATCH) must include CSRF protection
- Use synchronizer token pattern or SameSite cookie attribute
- Single-page apps: use custom request headers (e.g., `X-Requested-With`) validated server-side
- API-only endpoints authenticated via Bearer tokens are exempt (tokens are not auto-sent by browsers)

### CORS Policy
- CORS origins must be explicitly allowlisted — never use `*` in production
- Allowed origins must match known frontend domains only
- Expose only necessary headers in `Access-Control-Expose-Headers`
- Pre-flight cache (`Access-Control-Max-Age`) should be set to reduce OPTIONS requests

### Rate Limiting
- All external-facing APIs must have rate limiting configured
- Authentication endpoints: strict limits (e.g., 5 attempts per minute per IP)
- Data-retrieval endpoints: reasonable limits per tenant (e.g., 100 requests per minute)
- Rate limit headers must be included in responses: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Use 429 Too Many Requests with `Retry-After` header when limits are exceeded

### Secure Deserialization
- Never use native Java serialization (`ObjectInputStream`) for untrusted input
- Use safe formats only: JSON (Jackson/Gson with type validation), Protocol Buffers, or Avro
- Configure Jackson to reject unknown properties and disable default typing
- Validate deserialized objects against expected schemas before processing

### Secure HTTP Headers
All web-facing responses must include:
- `Strict-Transport-Security: max-age=31536000; includeSubDomains` (HSTS)
- `Content-Security-Policy` — restrict script sources, no `unsafe-inline` in production
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY` (or `SAMEORIGIN` where iframes are required)
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` — disable unused browser features (camera, microphone, geolocation)

### File Upload Validation
- Validate file type by content (magic bytes), not just extension
- Enforce maximum file size limits at the adapter boundary
- Sanitize filenames — strip path traversal characters (`../`, `..\\`)
- Store uploaded files outside the web root, never serve directly
- Scan uploaded files for malware before processing (critical for DLP inspection pipeline)
- Generate unique storage names — never use user-provided filenames for storage

### Cryptographic Standards
- Minimum TLS 1.2 for all connections; prefer TLS 1.3 where supported
- Passwords: hash with bcrypt (cost factor 12+), scrypt, or argon2id — never MD5/SHA-1
- Data integrity: SHA-256 minimum
- Encryption at rest: AES-256 via AWS KMS or SSE-KMS
- Key rotation: automated rotation every 90 days for application keys, yearly for KMS keys
- Never implement custom cryptography — use established libraries only

### Session Management
- Session tokens must be generated with cryptographically secure random generators
- Session timeout: 30 minutes of inactivity for admin sessions, 8 hours maximum absolute
- Invalidate sessions server-side on logout — do not rely on client-side token deletion
- Concurrent session limit: configurable per tenant (default: 5 active sessions per user)
- Bind sessions to client metadata (IP range, User-Agent) where practical

### Security Process (SDL)
- All features require a Security Definition of Done checklist (per PST)
- Threat modeling (Microsoft STRIDE) is mandatory for features that change security boundaries
- New external APIs require a design review with the Product Security Team (PST)
- Security Champions program: each team must have a designated Security Champion
- Reference: Forcepoint Secure Development Lifecycle (SDL) — Confluence space: PST

---

## Code Review Standards

Claude MUST apply these when reviewing code or writing code meant for review.

### Every PR Must
- Solve exactly ONE concern (feature, bugfix, or refactoring — not mixed)
- Have a clear description of WHAT changed and WHY
- Include tests that cover the changed behavior
- Pass all existing tests — no "fix later" broken tests
- Have no TODO/FIXME without a linked ticket

### Commit Message Format
- Every commit message MUST begin with a Jira ticket number: `NEO-1234 Fix policy evaluation timeout`
- Summary line (first line): imperative mood, max 72 characters including ticket
- Format: `<JIRA-TICKET> <Summary in imperative mood>`
- Bad: `NEO-1234 Fixed the bug` — Good: `NEO-1234 Fix policy evaluation timeout`

### Branch Naming
- Branch names: lowercase, alphanumeric, hyphen-separated
- Format: `<purpose>/<jira-ticket>-<short-description>`
- Purpose identifiers: `feature/`, `bugfix/`, `hotfix/`
- Example: `feature/neo-19421-false-positives-portal`
- The `main` (or `master`) branch is the primary branch — no direct commits allowed

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
- New code: minimum 85% line coverage (per DLP Quality Guidelines)
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

### Static Analysis (CI Pipeline — not enforced locally)
These tools run in the Jenkins CI pipeline, not during local development or Claude Code sessions. Claude cannot verify their results directly but will remind developers to check them before merge.
- **SonarQube**: all code must pass the Quality Gate before merge (bugs, vulnerabilities, coverage, duplication). Pipeline fails if gate is not met.
- **Checkmarx SAST**: required for security-critical code paths. Results reviewed before merge.
- **JFrog Xray**: open-source dependency vulnerability scanning. No critical/high findings allowed.
- Claude Code complements these tools locally: skills catch architecture, security, and DLP-specific issues that SonarQube cannot detect. Use `/dep-scan` for local dependency checks.

---

## Observability Standards

### Structured Logging
- All log output must be structured JSON — no unstructured text in production
- Required fields in every log entry: `timestamp`, `level`, `service`, `traceId`, `tenantId`, `message`
- Log levels: ERROR (actionable failures), WARN (degraded but functional), INFO (business events), DEBUG (development only, disabled in production)
- Never log request/response bodies — log only: method, path, status code, duration, tenant ID

### Distributed Tracing
- All services must propagate trace context via W3C Trace Context headers (`traceparent`, `tracestate`)
- Every inbound request must generate or continue a trace ID
- Outbound calls (HTTP, SQS, Lambda invocations) must forward the trace context
- Use AWS X-Ray or OpenTelemetry for instrumentation

### Metrics
- Instrument the RED metrics for every service: Rate (requests/sec), Errors (error rate %), Duration (latency percentiles)
- Name metrics consistently: `{service}_{operation}_{unit}` (e.g., `policy_evaluation_duration_ms`)
- Tag all metrics with: `service`, `environment`, `region`, `tenant_id` (where applicable)
- Set alerts on: error rate > 1%, p99 latency > SLA threshold, 5xx spike

### Health Checks
- Every service must expose `/health` (liveness) and `/ready` (readiness) endpoints
- Health checks must NOT require authentication
- Readiness checks must verify downstream dependencies (DB, cache, message queue)
- Liveness checks must be lightweight — no dependency checks, just "process is alive"

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
- Feature flags: all new UI views or significant UI changes MUST be behind a feature flag before merge

### Go (Services)
- Go 1.23 or greater
- Format with `gofmt` — no exceptions
- Analyze with `go vet` (consider `golangci-lint` as companion)
- Use Go's built-in test framework for testing and coverage
- Follow the same Clean Architecture dependency rules as other stacks

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
- SonarQube Quality Gate must pass in pipeline — pipeline fails if gate is not met (CI-only, not checked locally)
- Internal pre-commit hooks available at: `https://github.cicd.cloud.fpdev.io/Forcepoint/pre-commit-hooks`

### Repository Standards
- Every repository MUST contain a `README.md` at root with: service description, build/test/deploy instructions, contribution guidelines, team contact
- Every repository SHOULD contain a `CHANGELOG.md` following keepachangelog.com format
- Every repository MUST contain a `CODEOWNERS` file for PR routing
- Every repository MUST contain a Pull Request template (`.github/PULL_REQUEST_TEMPLATE.md`)
- Every repository using Jenkins MUST have a `Jenkinsfile` at root
- Reference: Best Practices — Confluence space: wsc

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

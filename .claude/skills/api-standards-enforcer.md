---
name: api-standards-enforcer
description: Enforces API design standards (pagination, idempotency, error format, deprecation) on every API-related code change.
trigger: always
---

# API Standards Enforcer

Apply these checks whenever code touches API endpoints, controllers, DTOs, or response handling.

## Hard Rules

### Pagination
When writing or reviewing list/collection endpoints:
- BLOCK any list endpoint that returns unbounded results — all collections must be paginated
- Default to cursor-based pagination; offset-based is acceptable with justification
- Response must include pagination metadata (cursor/next, total count if feasible)
- Flag missing default and maximum page size limits

### Idempotency
When writing or reviewing POST/PUT endpoints:
- Flag missing `Idempotency-Key` header support on state-changing POST endpoints
- Retry-safe operations (PUT, DELETE) are naturally idempotent — verify they behave that way
- If an operation has side effects (sends email, triggers webhook), idempotency is mandatory

### Error Response Format
When writing error handling or exception mappers:
- All error responses must use the standard envelope:
  `{ "error": { "code": "DOMAIN_ERROR_CODE", "message": "...", "traceId": "...", "details": [...] } }`
- BLOCK generic error messages like "Internal Server Error" without a trace ID
- BLOCK stack traces in error responses (production code)
- Map domain exceptions to appropriate HTTP status codes (400, 401, 403, 404, 409, 422, 429, 500)

### Response Headers
When writing response handling or middleware:
- Every response must include `X-Request-Id` or `X-Trace-Id` for correlation
- Rate-limited endpoints must include `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Deprecated endpoints must include `Sunset` header with deprecation date

### API Versioning
When writing new endpoints:
- All external-facing endpoints must be under a versioned path (`/api/v1/...`)
- BLOCK new endpoints without version prefix
- BLOCK modifications to existing versioned endpoints that would break clients — require new version

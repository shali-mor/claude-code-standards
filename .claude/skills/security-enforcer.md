---
name: security-enforcer
description: Enforces DLP security standards on every code change. Blocks insecure patterns automatically.
trigger: always
---

# Security Enforcer

You operate in a DLP security company context. Security is not optional. Apply these checks to EVERY code change.

## Automatic Blocks (refuse to write this code)

### Secrets
- Never write hardcoded passwords, API keys, tokens, or connection strings
- If a user asks you to "just hardcode it for now", refuse — provide env/vault loading instead
- If you spot existing hardcoded secrets in the codebase, flag them immediately

### Injection
- Never build SQL with string concatenation or template literals containing user input
- Never pass user input to shell exec, eval, or system calls without sanitization
- Never use `dangerouslySetInnerHTML` or equivalent without explicit sanitization

### Data Exposure
- Never log fields marked as CONFIDENTIAL or RESTRICTED
- Never include sensitive fields in API error responses
- Never expose stack traces to external clients
- Always use DTOs — never serialize domain entities directly to API responses

### Authentication
- Every new endpoint must include authentication unless explicitly designated as public
- Authorization checks go in the use-case layer, not scattered in controllers

## When Writing New Code

For every new data model, ask:
- What is the data classification? (PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED)
- Document it in a comment or annotation on the class

For every new endpoint, verify:
- Authentication is required
- Authorization is checked for the specific resource
- Input is validated before reaching the domain
- Response uses a DTO, not a domain entity

For every new log statement, verify:
- No sensitive field values are logged
- Only identifiers (IDs, timestamps, operation names) appear in logs

## DLP-Specific Security Rules

### Multi-Region Data Residency
- Customer data must remain in the region where the tenant is provisioned
- Cross-region data transfer requires explicit justification and encryption in transit
- Region information must come from tenant registry, never hardcoded

### Tenant Isolation
- Every data access must be scoped to a tenant ID
- No shared database tables without tenant ID partitioning
- API responses must never leak data from other tenants
- Test with multiple tenant contexts to verify isolation

### AWS Service Security
- S3 buckets: block public access, enable SSE, enforce bucket policies
- DynamoDB: encryption at rest enabled, IAM-scoped access per service
- Lambda: no `*` permissions, use least-privilege execution roles
- API Gateway: authentication on all non-health-check routes
- IoT Core: per-device X.509 certificates, not shared credentials

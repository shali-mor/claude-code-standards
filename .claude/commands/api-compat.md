Check API changes for backward compatibility violations.

## Instructions

1. Run `git diff <base>...HEAD` to find changes to API-related files:
   - OpenAPI/Swagger specs (`*.yaml`, `*.json` in `api/`, `swagger/`, `openapi/`)
   - Controller/handler files (routes, endpoints)
   - DTO/request/response classes
   - GraphQL schema files
   - Protobuf definitions

2. For EACH API change, classify:

### Breaking Changes (BLOCKING)
- Removed endpoint / route
- Removed or renamed field in response body
- Changed field type in request or response (e.g., string to integer)
- Added required field to request body (existing clients won't send it)
- Changed HTTP method for an endpoint
- Changed URL path or parameter name
- Narrowed accepted values (e.g., enum that accepted "A","B","C" now only accepts "A","B")
- Changed success status code (e.g., 200 to 201)
- Changed error response format

### Non-Breaking Changes (OK)
- Added new optional field to request
- Added new field to response
- Added new endpoint
- Widened accepted values (e.g., added new enum value)
- Added new optional query parameter

### Requires New API Version (BLOCKING if in existing version)
- Any breaking change MUST be in a new API version (`/api/v2/...`)
- Existing version must continue to work unchanged

## Output Format

```
API COMPATIBILITY CHECK:

BREAKING CHANGES:
  [1] DELETE /api/v1/policies/:id — response field "policyName" renamed to "name"
      → Clients expecting "policyName" will break
      → Fix: keep "policyName" in v1, add "name" in v2

NON-BREAKING CHANGES:
  [1] POST /api/v1/policies — new optional field "description" added to request
      → Safe: existing clients unaffected

VERDICT: COMPATIBLE / BREAKING (requires new API version) / BLOCKED
```

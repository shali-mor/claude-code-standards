Review Terraform code against Cloud DLP infrastructure standards.

## Instructions

1. Scan all `.tf` and `.tfvars` files in the repository.

2. Evaluate against:

### State Management (BLOCKING)
- Backend configured with S3 + DynamoDB locking
- No local state files committed (check .gitignore for `*.tfstate`)
- State file encryption enabled

### Security (BLOCKING)
- No secrets, passwords, or API keys in .tf or .tfvars files
- Sensitive variables marked with `sensitive = true`
- No hardcoded AWS account IDs — use `data.aws_caller_identity`
- No overly permissive IAM policies (`Action: "*"` or `Resource: "*"`)
- Security groups: no `0.0.0.0/0` ingress except for public-facing load balancers

### DPS Deployment Patterns (WARNING)
- Tenant resources created via variables, not hardcoded
- Batch-deployment compatible (works with Lambda-triggered batches of 10 tenants)
- NEO tenant registry (DynamoDB) used as source of truth for tenant state
- Changes are idempotent — safe to re-apply

### Resource Standards (WARNING)
- All resources tagged: `team`, `environment`, `tenant` (where applicable), `cost-center`
- Naming convention followed: `{service}-{tenant_id}-{resource_type}`
- Resource dependencies explicit (not relying on implicit ordering)

### Best Practices (WARNING)
- Modules used for reusable components
- Variables have descriptions and type constraints
- Outputs defined for values needed by other modules
- No deprecated resource types or provider features
- Provider version pinned

## Output Format

```
[BLOCKING|WARNING] file:line — Rule violated
  → What's wrong: <description>
  → Fix: <specific action to take>
```

End with: PASS / NEEDS FIXES / BLOCKED

If no relevant files are found in the repository, output:
```
No .tf files found in this repository. This command is not applicable.
```

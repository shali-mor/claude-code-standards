Review DPS-specific code changes against the DPS architecture patterns.

## Instructions

1. Run `git diff` to see all changes. Focus on DPS-related files (Terraform, Kubernetes manifests, DPS service code).

2. For EACH changed file, evaluate against this DPS-specific checklist:

### Tenant Isolation (BLOCKING)
- Tenant ID must never be hardcoded — always derived from configuration or request context
- No cross-tenant data access — each tenant's pods, Route53 entries, and ingress CRDs are isolated
- Tenant-specific secrets must use AWS Secrets Manager or SSM, not config maps

### Kubernetes Patterns (BLOCKING)
- Resource requests AND limits defined on all containers
- Liveness and readiness probes present on all services
- Services deploy in `dpaas-production` namespace (or justified alternative)
- Min 2 replicas per tenant for HA
- topologySpreadConstraints used for cross-AZ distribution

### Scaling Configuration (WARNING)
- Sync services: HPA scaling on container CPU (REST: 600m, CPE: 2400m thresholds)
- Async services: KEDA scaling on SQS queue length
- Scaling thresholds justified for the workload profile

### Terraform (BLOCKING)
- No hardcoded region, account ID, or tenant ID in .tf files
- State stored in S3 with DynamoDB locking
- All resources tagged: team, environment, tenant, cost-center
- Batch deployment compatible — changes must work with Lambda-triggered Terraform batches of 10 tenants

### DPS Security (BLOCKING)
- DLP-scanned content never logged or persisted outside the inspection pipeline
- Verdict responses contain classification result only, never the scanned content
- Nginx ingress TLS configured for all tenant endpoints

### Performance (WARNING)
- Memory-sensitive services: check memory requests/limits are appropriate (DPS is memory-bound)
- No synchronous cross-region calls
- Idempotent consumers for SQS/Kinesis

## Output Format

For each finding:
```
[BLOCKING|WARNING] file:line — Rule violated
  → What's wrong: <description>
  → Fix: <specific action to take>
```

End with: PASS / NEEDS FIXES / BLOCKED

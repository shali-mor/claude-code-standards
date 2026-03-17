Review AWS infrastructure and serverless code against Cloud DLP platform standards.

## Instructions

1. Identify AWS-related files: Lambda handlers, CloudFormation/CDK templates, Terraform configs, API Gateway definitions, IAM policies, S3 configurations.

2. For EACH file, evaluate against:

### IAM & Secrets (BLOCKING)
- No hardcoded AWS credentials, API keys, or tokens anywhere
- IAM roles follow least-privilege principle — no `*` actions or resources in production
- Secrets loaded from AWS Secrets Manager or SSM Parameter Store
- No AWS account IDs hardcoded — use data sources or variables

### Lambda (BLOCKING for handlers, WARNING for config)
- Single responsibility per Lambda function
- Structured JSON logging (not console.log/print with unstructured text)
- Environment variables for all configuration — no hardcoded endpoints or ARNs
- Timeout set appropriately (not default 3s for processing functions)
- Memory sized based on workload (Lambda allocates CPU proportional to memory)
- Error handling: dead letter queue (DLQ) configured for async invocations
- No sensitive data in Lambda environment variables — use Secrets Manager with caching

### API Gateway (BLOCKING)
- Authentication required on all routes (except health checks)
- Request validation enabled
- Throttling/rate limiting configured
- CORS restricted to known origins (not `*` in production)

### S3 (BLOCKING)
- Server-side encryption enabled (SSE-S3 or SSE-KMS for sensitive data)
- Public access blocked via bucket policy
- Forensics/policy buckets classified as CONFIDENTIAL minimum
- Pre-signed URLs use short TTL (15 min max for endpoint access)
- Lifecycle policies defined for data retention

### DynamoDB (WARNING)
- On-demand or provisioned capacity justified
- Point-in-time recovery enabled for production tables
- TTL configured for ephemeral data
- GSI/LSI access patterns documented

### Kinesis / IoT Core (WARNING)
- Kinesis consumers are idempotent
- Enhanced fan-out for critical alert streams
- IoT Core device authentication via X.509 certificates
- MQTT payloads not logged (may contain endpoint-sensitive data)

### Cognito (BLOCKING)
- MFA enabled for admin users
- Token expiry set (access: 1h max, refresh: 30d max)
- Password policy enforces complexity
- User pool configured with SAML federation for SSO

## Output Format

For each finding:
```
[BLOCKING|WARNING] file:line — Rule violated
  → What's wrong: <description>
  → Impact: <what could go wrong>
  → Fix: <specific action to take>
```

End with severity summary and: PASS / NEEDS FIXES / BLOCKED

If no relevant files are found in the repository, output:
```
No AWS-related files found in this repository. This command is not applicable.
```

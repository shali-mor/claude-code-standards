---
name: dlp-content-handler
description: Enforces safe handling of DLP-processed content in inspection pipelines, forensics, and classification data. Always active — checks relevance based on file context.
trigger: always
---

# DLP Content Handler

This system processes CONFIDENTIAL and RESTRICTED content as its core function. Code that touches inspection pipelines, forensics storage, or classification results needs extra scrutiny.

## Hard Rules

### Inspection Pipeline Data
- DLP-scanned content (file bodies, email bodies, web traffic payloads) MUST be processed in-memory only
- Never persist raw scanned content outside the designated forensics pipeline
- Never log scanned content — log only: tenant ID, transaction ID, verdict, policy ID, timestamp
- Test fixtures must use synthetic data, never real customer content or realistic PII

### Forensics Pipeline
- Forensics data uploaded to S3 must use SSE-KMS encryption
- S3 bucket policies must restrict access to the owning tenant only
- Pre-signed URLs for forensics access: max 15-minute TTL
- Forensics retention policies must be configurable per tenant

### Classification Results
- Verdicts (allow/block/monitor) can be logged and stored
- Match details (which classifier matched, match count) can be stored
- Matched content snippets: treat as CONFIDENTIAL — encrypt at rest, restrict access
- Never include matched content in API error responses or debug logs

### Policy Data
- Policy files (policy.xml, rule sets) are INTERNAL classification
- Policy distribution to endpoints via S3 with encryption
- Policy changes must be auditable — log who changed what and when

### Endpoint Communication
- Alerts from endpoints via IoT Core: log alert metadata only, not payload content
- Endpoint registration data (device keys, certificates): RESTRICTED — never log
- MQTT payloads may contain sensitive endpoint data — never log full payloads

### Data Residency
- Forensics data must remain in the region where the tenant is provisioned
- Cross-region transfer of DLP-scanned content or forensics requires explicit justification
- See security-enforcer for general multi-region data residency rules

## When Reviewing Code
For any code touching DPS services (sync/async/standalone), inspection, or forensics:
1. Trace the data flow — where does scanned content go after inspection?
2. Check every log statement in the code path
3. Verify encryption on any persistence
4. Confirm test data is synthetic

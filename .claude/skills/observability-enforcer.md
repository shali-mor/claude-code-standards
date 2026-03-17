---
name: observability-enforcer
description: Enforces structured logging, distributed tracing, and health check standards on every code change.
trigger: always
---

# Observability Enforcer

Apply these checks whenever code touches logging, error handling, HTTP middleware, or service configuration.

## Structured Logging

When writing log statements:
- BLOCK unstructured log output in production code (no `System.out.println`, `console.log`, `print()`)
- Log output must be structured JSON with fields: `timestamp`, `level`, `service`, `traceId`, `tenantId`, `message`
- BLOCK logging of request/response bodies — log only: method, path, status code, duration, tenant ID
- Log levels must be appropriate: ERROR for actionable failures, WARN for degraded, INFO for business events, DEBUG for dev only
- Flag DEBUG-level logging left enabled in production configuration

## Distributed Tracing

When writing HTTP handlers, clients, or message consumers:
- Flag missing trace context propagation (W3C `traceparent`/`tracestate` headers)
- Every inbound request handler should extract or generate a trace ID
- Every outbound call (HTTP, SQS, Lambda) should forward the trace context
- Flag if a new service has no tracing instrumentation (X-Ray or OpenTelemetry)

## Health Checks

When writing service configuration or startup code:
- Flag if a service does not expose `/health` (liveness) and `/ready` (readiness) endpoints
- Health check endpoints must NOT require authentication
- Readiness checks should verify downstream dependencies (DB, cache, queue connectivity)
- Liveness checks must be lightweight — no dependency checks, just "process is alive"

## Metrics

When writing new endpoints or services:
- Flag missing RED metrics instrumentation: Rate (requests/sec), Errors (error rate %), Duration (latency percentiles)
- Metric names should follow: `{service}_{operation}_{unit}` (e.g., `policy_evaluation_duration_ms`)
- All metrics should be tagged with: `service`, `environment`, `region`, `tenant_id`
- Set alerts on: error rate > 1%, p99 latency > SLA threshold, 5xx spike

Perform a security audit on the codebase focused on DLP security standards.

## Instructions

Scan the entire codebase for security issues. Prioritize findings by severity.

### Critical (Must fix immediately)
- Hardcoded secrets, API keys, tokens, or passwords anywhere in code or config files
- SQL injection: queries built with string concatenation or interpolation
- Command injection: user input passed to shell/exec calls
- Sensitive data (PII, classified content) in log statements
- Authentication bypass: endpoints accessible without auth
- Insecure deserialization of untrusted data
- Exposed stack traces or internal error details in API responses

### High (Must fix before merge)
- Missing input validation on external-facing endpoints
- Cross-site scripting (XSS): unescaped user content rendered in frontend
- Insecure direct object references (IDOR): accessing resources without ownership check
- Missing rate limiting on authentication endpoints
- Dependencies with known critical/high CVEs (check lock files)
- CORS misconfiguration (overly permissive origins)
- Missing HTTPS enforcement

### Medium (Should fix)
- Overly permissive file permissions
- Verbose error messages that leak implementation details
- Missing security headers (CSP, X-Frame-Options, etc.)
- Session tokens without expiry
- Missing audit logging for sensitive operations

### DLP-Specific Checks
- Data classification annotations/comments present on models handling sensitive data
- Encryption at rest for CONFIDENTIAL/RESTRICTED data stores
- Data egress points (API responses, exports, logs) reviewed for data leakage
- Policy enforcement points exist and are not bypassable

## Output Format

For each finding:
```
[CRITICAL|HIGH|MEDIUM] Category — file:line
  Description: <what's wrong>
  Impact: <what could go wrong>
  Fix: <specific remediation>
```

End with severity summary and a risk rating: LOW / MEDIUM / HIGH / CRITICAL

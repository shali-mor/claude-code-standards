Scan project dependencies for known vulnerabilities and license issues.

## Instructions

### Step 1: Detect the Package Manager
Identify the project's dependency files:
- `package.json` / `package-lock.json` → Node.js
- `pom.xml` → Java (Maven)
- `build.gradle` / `build.gradle.kts` → Java (Gradle)
- `requirements.txt` / `Pipfile` / `pyproject.toml` → Python
- `go.mod` → Go

### Step 2: Run Vulnerability Scan
Execute the appropriate scanner:
- **Node.js**: `npm audit --json` (or `yarn audit --json`)
- **Python**: `pip audit --format=json` (install with `pip install pip-audit` if needed)
- **Java (Gradle)**: `./gradlew dependencyCheckAnalyze` (requires OWASP dependency-check plugin)
- **Java (Maven)**: `mvn org.owasp:dependency-check-maven:check`
- **Go**: `govulncheck ./...`

If the scanner is not installed, inform the user how to install it.

### Step 3: Check License Compliance
Scan dependencies for license types. Flag:
- **BLOCKING**: GPL, AGPL, SSPL in any dependency (copyleft — incompatible with proprietary code)
- **WARNING**: LGPL (acceptable if dynamically linked, review usage)
- **OK**: MIT, Apache 2.0, BSD, ISC, MPL 2.0

For Node.js: `npx license-checker --summary`
For Python: `pip-licenses --format=json`
For Java: check POM/Gradle dependency metadata

### Step 4: Output

```
VULNERABILITY SCAN:
  Scanner: <tool used>
  Total dependencies: <count>

  CRITICAL: <count>
    - <package>@<version> — <CVE-ID>: <description>
  HIGH: <count>
    - <package>@<version> — <CVE-ID>: <description>
  MEDIUM: <count> (list if < 10, summarize if more)
  LOW: <count> (summary only)

LICENSE COMPLIANCE:
  BLOCKED: <count>
    - <package> — <license> (copyleft, incompatible with proprietary)
  WARNING: <count>
    - <package> — <license> (review usage)
  CLEAN: <count>

VERDICT: PASS / NEEDS FIXES / BLOCKED
```

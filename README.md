# Company Workflow — Architecture Standards

> **Claude Code configurations that enforce architecture, security, and quality standards across all Forcepoint organization repositories.**
>
> `Claude Code` | `Forcepoint Cloud DLP` | `DLP-Grade Security`

---

## What Is This?

This is a **ready-to-copy template** for any Forcepoint repository. It gives Claude Code the knowledge to enforce your architecture rules, security standards, and testing requirements — automatically, as developers write code.

It includes:
- **Rules** that Claude follows on every conversation (`CLAUDE.md`)
- **Skills** that block bad code inline, before it's even committed
- **Commands** that developers run on-demand for deep analysis
- **Hooks** that catch common mistakes for free (zero API cost)
- **Atlassian integration** that pulls context from Jira and Confluence

---

## Quick Start

Copy the template files into your target repository, then customize for your stack.

### Option A: One-line install (from internal GitHub)

Run this from the root of your target repository:

```bash
curl -sL https://github.cicd.cloud.fpdev.io/Forcepoint/claude-code-standards/raw/main/scripts/install.sh | bash
```

### Option B: Install from a local copy

If you already have this repo cloned locally:

```bash
CLAUDE_STANDARDS_LOCAL=/path/to/company_workflow bash /path/to/company_workflow/scripts/install.sh
```

### Option C: Manual copy

```bash
cp -r /path/to/company_workflow/CLAUDE.md .
cp -r /path/to/company_workflow/.claude .
cp /path/to/company_workflow/.mcp.json .
cp /path/to/company_workflow/.pre-commit-config.yaml .   # optional, requires git
```

### After installing

1. Edit `CLAUDE.md` — uncomment/remove the stack sections that match your repo
2. Run `/mcp` in Claude Code to authenticate with Atlassian
3. *(optional)* Run `pip install pre-commit && pre-commit install` for git hooks

---

## How It Works

Three layers of protection, from free to full-powered:

```
  CLAUDE.md (always loaded — the single source of truth)
       |
       +--- Skills (always-on, block bad code as you write it)
       |       arch-gatekeeper, security-enforcer,
       |       test-guardian, dlp-content-handler
       |
       +--- Commands (on-demand, invoked via /command-name)
       |       /review, /arch-check, /dps-review,
       |       /implement-ticket, /onboarding, ...
       |
       +--- Hooks (zero API cost, catch the obvious)
               Claude hooks: secrets, debug logs, skipped tests
               Git hooks: gitleaks, terraform, formatting
```

---

## What's Included

### `CLAUDE.md` — The Rulebook

Claude Code reads this file automatically on every conversation. No action needed from developers — the rules are always active.

| Area | What It Covers |
|------|---------------|
| **Architecture Principles** | Dependency rule (`adapter -> usecase -> domain`), separation of concerns, API versioning |
| **Architecture Reality** | Acknowledges NEO monolith + DPS per-tenant patterns, guides incremental improvement |
| **Security Standards** | Data classification, auth/authz, input validation, dependency security |
| **Code Review** | PR scope, review checklist, no broken tests |
| **Testing** | 80% min coverage, 100% on security paths, test pyramid |
| **Stack Rules** | Java, React, Python, AWS, Kubernetes, Terraform, CI/CD, Multi-Region |

---

### `.claude/skills/` — Always-On Enforcement

Skills activate automatically on every code change. Developers don't need to do anything — Claude simply refuses to write code that violates these rules.

| Skill | What It Does |
|:------|:------------|
| `architecture-gatekeeper` | Blocks code that violates the dependency rule. Refuses to write non-compliant code. |
| `security-enforcer` | Blocks hardcoded secrets, injection, data exposure. Enforces tenant isolation and multi-region residency. |
| `test-guardian` | Ensures tests accompany every production code change. Enforces naming and structure. |
| `dlp-content-handler` | Enforces safe handling of DLP-scanned content, forensics data, and classification results. |

---

### `.claude/commands/` — Slash Commands

Commands are invoked manually by typing `/command-name` in Claude Code. Use them when you need deeper analysis beyond what the always-on skills provide.

#### Code Review and Quality

| Command | When to Use |
|:--------|:--------|
| `/review` | Before submitting a PR — runs full standards check |
| `/arch-check` | When touching multiple layers or refactoring — validates dependency graph |
| `/security-audit` | Before release or when touching auth/data paths — full security scan |
| `/test-quality` | When reviewing test adequacy — checks coverage and test anti-patterns |
| `/pr-summary` | When creating a PR — generates a standardized description |
| `/new-feature` | Starting a new feature — walks you through the architecture layer by layer |

#### Infrastructure Review

| Command | When to Use |
|:--------|:--------|
| `/dps-review` | Changing DPS code — checks tenant isolation, K8s patterns, Terraform, scaling |
| `/aws-review` | Changing AWS infra — checks Lambda, S3, DynamoDB, IAM, Cognito best practices |
| `/terraform-check` | Changing `.tf` files — validates state management, security, tagging |

#### Jira and Confluence Integration

These commands connect to Atlassian to pull real context from your tickets and docs.

| Command | When to Use |
|:--------|:--------|
| `/implement-ticket DLP-1234` | Starting work on a ticket — pulls description, acceptance criteria, and related docs |
| `/pr-with-ticket DLP-1234` | Creating a PR — links it to Jira with acceptance criteria mapping |
| `/adr-check [component]` | Before architectural changes — finds relevant ADRs that may constrain your work |
| `/incident-review [service]` | Before merging to a sensitive area — checks past incidents for regression risk |
| `/onboarding [service]` | Joining a new team/service — generates a full onboarding guide from all sources |
| `/refactor-check [description]` | Before large refactorings — checks ADRs, in-flight work, and test coverage |
| `/sync-architecture [space]` | Periodically — compares Confluence architecture docs with local CLAUDE.md rules |
| `/design-from-confluence` | Starting a feature — pulls existing patterns from Confluence to guide your design |

---

### `.claude/settings.local.json` — Claude Code Hooks

These run automatically on every file edit/write during Claude sessions. They use simple shell scripts — **zero API cost**, instant feedback.

| Hook | What It Catches | Severity |
|:-----|:-------|:---------|
| **Secret Scanner** | AWS keys (`AKIA...`), `.env`/`.credentials`/`.tfstate` files, hardcoded passwords | **BLOCKS** |
| **Debug Logging** | `System.out.println` (Java), `console.log` (JS/TS), `print()` (Python) | WARNS |
| **Skipped Tests** | `@Disabled`/`@Ignore`/`xit`/`skip` without a Jira ticket reference | WARNS |

---

### `.pre-commit-config.yaml` — Git Hooks

Ships with the template. Only relevant for repos with git — activates after install:

```bash
pip install pre-commit && pre-commit install
```

| Hook | What It Does |
|:-----|:------------|
| **gitleaks** | Scans for hardcoded secrets |
| **block large files** | Rejects files > 500KB |
| **detect private keys** | Blocks private key files |
| **no commits to main** | Prevents direct commits to main/master |
| **terraform fmt** | Enforces Terraform formatting |
| **terraform validate** | Validates Terraform syntax |
| **tfsec** | Security scan for Terraform |
| **block .tfstate** | Prevents state files from being committed |
| **block .env files** | Prevents sensitive files from being committed |
| **debug logging** | Warns on console.log / print / System.out |
| **skipped test check** | Blocks skipped tests without ticket references |

Stack-specific hooks (Java formatter, Black, ESLint, pip-audit) are included but commented out. Uncomment the ones that match your repo's stack.

---

### `.mcp.json` — Atlassian Integration

Connects Claude Code to **Confluence** and **Jira** via the official Atlassian MCP server. This is what powers the `/implement-ticket`, `/onboarding`, and other Atlassian commands.

First-time setup: run `/mcp` inside Claude Code to authenticate via OAuth.

---

## Cloud DLP Platform Context

This template is tailored for the Forcepoint Cloud DLP platform. The rules and commands reference the actual architecture documented in Confluence.

### NEO (Control Plane)

| Component | Details |
|:----------|:--------|
| **Backend** | Java uber JAR on AWS Beanstalk (migrating to ECS) |
| **Frontend** | React portal (`DUP-FE`) |
| **AWS Services** | Lambda, API Gateway, DynamoDB, Aurora, Cognito, IoT Core, Kinesis, S3 |
| **Regions** | us-east-1, eu-central-1, eu-west-2, ap-south-1, ap-southeast-1 |

### DPS (Data Plane)

| Component | Details |
|:----------|:--------|
| **Runtime** | Kubernetes, 6 clusters, per-tenant deployments |
| **IaC** | Terraform, batch deploys via Lambda (10 tenants/batch) |
| **Scaling** | Sync (HPA/CPU), Async (KEDA/SQS) |
| **Volume** | 80-100M transactions/day |

### Key Confluence Spaces

| Space | Focus |
|:------|:------|
| **IT** | Infrastructure architecture (Cloud DLP, DPS) |
| **DSSEIP** | DPS development (architecture, EIP) |
| **HIP** | Cloud DLP product (releases, backend arch) |
| **PM** | Product management (feature specs) |
| **EP** | Engineering program (PI planning) |
| **AS** | Application Security (pen testing) |
| **FPA** | Architecture (Streamline, DSPM) |
| **MRC1** | Cloud services (O365 Email, Portal) |

### Key Jira Projects

| Project | Team |
|:--------|:-----|
| **NEO** | NEO Portal |
| **DPS** | DPS Development |
| **DSA** | Cloud DLP Agent (DSE) |
| **IPD** | DevOps / Infrastructure |
| **DSPM** | Data Security Posture Mgmt |
| **UEP** | Unified Endpoint |
| **EA** | Enterprise Architecture |
| **WSM** | Web Security Manager |

---

## Cost vs. Coverage

| Layer | Cost | When It Runs | What It Catches |
|:------|:-----|:-------------|:----------------|
| **Git Hooks** | Free | Every commit/push | Secrets, formatting, tests pass, CVEs, `.tfstate` |
| **Claude Hooks** | Free | Every file edit in Claude | Secrets, debug logging, skipped tests |
| **Skills** | ~8K tokens overhead | Every conversation | Architecture, security, testing, DLP content |
| **Commands (local)** | ~3-15K per use | On-demand | Deep code review, infra checks |
| **Commands (Atlassian)** | ~15-25K per use | On-demand | Full org context from Jira + Confluence |

Best practice: Git hooks catch the cheap stuff for free. Skills catch the architectural stuff inline. Commands provide deep analysis on-demand.

---

## Customization

- **Add repo-specific rules** — Edit `CLAUDE.md` in the target repo after copying
- **Add new commands** — Create `.md` files in `.claude/commands/`
- **Add new skills** — Create `.md` files in `.claude/skills/`
- **Disable a skill** — Remove it from `.claude/skills/` in the target repo
- **Enable stack hooks** — Uncomment Java/Python/JS sections in `.pre-commit-config.yaml`
- **Add Jira project keys** — Edit the command files that reference Jira projects

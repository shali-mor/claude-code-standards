Generate a pull request description from the current branch's changes.

## Instructions

1. Detect the base branch (check for `main`, `master`, or `develop`). Run `git log <base>..HEAD --oneline` to see all commits.
2. Run `git diff <base>...HEAD` to see the full diff. If no commits exist on this branch, inform the user.

2b. Verify all commits follow the format: `<JIRA-TICKET> <Summary in imperative mood>`. Flag any that don't.

3. Generate a PR description in this format:

```markdown
## What
<1-3 sentences: what this PR does>

## Why
<1-3 sentences: the motivation — what problem it solves or what it enables>

## Architecture Impact
- Layers modified: <domain / usecase / adapter / config / frontend>
- New interfaces/ports: <list or "none">
- API changes: <new endpoints, modified contracts, or "none">
- DB changes: <migrations, schema changes, or "none">

## Security Considerations
- Data classification impact: <any new sensitive data fields or "none">
- Auth/authz changes: <any permission changes or "none">
- Input validation: <new external inputs validated or "N/A">

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated (if adapter changes)
- [ ] Manual testing done: <describe what was tested>

## Checklist
- [ ] Follows dependency rule (domain has no outward imports)
- [ ] No business logic in controllers/adapters
- [ ] Domain entities not exposed in API responses
- [ ] No hardcoded secrets or environment-specific values
- [ ] Sensitive data not logged
```

4. Fill in every section based on the actual changes. Do not leave placeholders — if something doesn't apply, write "N/A" or "none".

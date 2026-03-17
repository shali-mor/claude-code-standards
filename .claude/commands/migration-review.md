Review database migration files for safety and best practices.

## Instructions

1. Find all migration files in the repository:
   - SQL files in `migrations/`, `db/migrate/`, `flyway/`, `liquibase/`, `supabase/`
   - Alembic migrations in `alembic/versions/`
   - DynamoDB table definitions in Terraform or CloudFormation

2. For EACH migration, check:

### Destructive Operations (BLOCKING)
- `DROP TABLE` / `DROP COLUMN` — data loss risk, requires backup verification
- `TRUNCATE TABLE` — data loss
- `ALTER COLUMN` that narrows type (e.g., VARCHAR(255) to VARCHAR(50)) — data truncation
- Removing `NOT NULL` constraint without default — existing rows may break
- Removing indexes used by application queries — performance degradation

### Lock Safety (BLOCKING for large tables)
- `ALTER TABLE` on large tables without `CONCURRENTLY` (PostgreSQL) or equivalent
- Adding a column with a `DEFAULT` on a large table (pre-PG11 locks the table)
- Creating an index without `CONCURRENTLY` on production tables

### Best Practices (WARNING)
- Migration has no corresponding rollback/down migration
- Missing index on new foreign key columns
- New column is NOT NULL without a DEFAULT (will fail on existing rows)
- Large data backfill in the same migration as schema change (split into two)
- Hardcoded values that should be configurable

### DynamoDB Specific (WARNING)
- Changing partition key or sort key (requires table recreation)
- Adding GSI on a table with heavy write traffic (can throttle)
- Missing TTL configuration on ephemeral data tables

## Output Format

```
MIGRATION: <filename>
  [BLOCKING] DROP COLUMN user_email — data loss, ensure backup exists
  [BLOCKING] ALTER TABLE policies (10M+ rows) — missing CONCURRENTLY, will lock table
  [WARNING] No rollback migration found

SUMMARY:
  Migrations reviewed: X
  BLOCKING issues: N
  WARNINGS: M
  Verdict: SAFE / NEEDS REVIEW / BLOCKED
```

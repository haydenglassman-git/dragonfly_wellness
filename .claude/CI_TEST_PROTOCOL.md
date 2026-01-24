# CI Test Protocol: Preventing Test Debt Accumulation

**Created:** 2026-01-23
**Lesson Source:** 302 CI failures accumulated over time, requiring 3+ sessions to fix

## The Problem We Solved

Over time, tests were written that:
1. Depended on schema columns/tables that don't exist in CI
2. Used legacy database patterns (`temp_db` fixture, direct `database` module)
3. Required running services (causing deadlocks)
4. Made assertions that differ between environments (encryption, security)

**Root causes:**
- No distinction between "CI-compatible" and "local-only" tests
- Pre-push hook ran ALL tests (slow, prone to timeout)
- Schema drift between local dev and CI environments
- No enforcement of test categorization

## The Solution: Test Categorization System

### Test Markers (MANDATORY for all new tests)

```python
import pytest

# CI-COMPATIBLE: These tests MUST pass in CI
# - Use only schema that exists in CI
# - No external service dependencies
# - Deterministic assertions
@pytest.mark.ci
class TestMyFeature:
    ...

# LOCAL-ONLY: Tests that require full local environment
# - May use columns/tables not in CI
# - May require running services
# - Environment-specific assertions
@pytest.mark.local_only
class TestMyLocalFeature:
    ...

# UNIT: Fast, isolated, no DB required
# These run on EVERY pre-push
@pytest.mark.unit
class TestMyUnit:
    ...
```

### Marker Hierarchy

| Marker | Pre-commit | Pre-push | CI | Description |
|--------|------------|----------|-----|-------------|
| `@pytest.mark.unit` | No | Yes | Yes | Fast, isolated, no DB |
| `@pytest.mark.ci` | No | Yes | Yes | Requires CI schema |
| `@pytest.mark.local_only` | No | No | No | Requires full local schema |
| `@pytest.mark.integration` | No | No | Yes | Requires running services |
| `@pytest.mark.premium` | No | No | No | Premium features only |

### Pre-Push Strategy

**OLD (broken):**
```bash
# Runs ALL tests - takes 10+ minutes, times out
pytest tests/ -m "not premium"
```

**NEW (fast + safe):**
```bash
# Stage 1: Unit tests only (< 30 seconds)
pytest tests/unit/ -m "unit" --tb=short -q

# Stage 2: CI-compatible non-integration tests (< 2 minutes)
pytest tests/ -m "ci and not integration" --tb=short -q --ignore=tests/integration/

# Total: < 3 minutes, catches most issues
```

### CI Schema Requirements

Tests marked `@pytest.mark.ci` can ONLY use these schema elements:

**Available in CI:**
- Core tables: `signals`, `lead_extractions`, `lead_targets`, `users`, `tenants`
- Standard columns on those tables
- Fixtures: `test_client`, `auth_headers`, `api_client`

**NOT available in CI (use `@pytest.mark.local_only`):**
- `dm_research_confidence` column
- `lead_category` column
- `parent_tenant_id` column
- `consent_records` table
- `contact_discovery_jobs` table
- `email_warmup` table
- `temp_db` fixture
- Direct `database` module imports
- Running uvicorn server

## Enforcement Mechanisms

### 1. Test File Validation (pre-commit hook)

Every test file MUST have exactly ONE of these markers at module level:
```python
# One of these must appear near the top of the file
pytestmark = pytest.mark.ci           # CI-compatible
pytestmark = pytest.mark.local_only   # Local only
pytestmark = pytest.mark.unit         # Unit tests
```

### 2. Schema Drift Detection

Before marking a test as `@pytest.mark.ci`, verify:
```python
# Add this fixture to tests that need schema validation
@pytest.fixture
def verify_ci_schema(db_connection):
    """Verify required schema exists, skip if not."""
    required_columns = {
        "lead_extractions": ["id", "company_name", "status"],
        # Add columns your test needs
    }
    for table, columns in required_columns.items():
        for col in columns:
            if not column_exists(db_connection, table, col):
                pytest.skip(f"CI schema missing: {table}.{col}")
```

### 3. New Test Checklist

Before committing a new test file:

- [ ] Added module-level marker (`pytest.mark.ci`, `local_only`, or `unit`)
- [ ] If `ci` marked: verified all schema elements exist in CI
- [ ] If `ci` marked: no `temp_db` or direct `database` imports
- [ ] If `ci` marked: no assertions that depend on environment
- [ ] If `integration` marked: test handles service unavailability gracefully
- [ ] Ran `pytest <test_file> -v` locally to verify it passes

## Recovery Protocol

When CI failures accumulate despite this protocol:

### Step 1: Triage
```bash
# Download CI failure logs
gh run view <RUN_ID> --log-failed > /tmp/ci-failures.log

# Categorize failures
grep -E "FAILED|ERROR" /tmp/ci-failures.log | sort | uniq -c | sort -rn
```

### Step 2: Categorize Each Failure

| Error Pattern | Fix |
|--------------|-----|
| `column X does not exist` | Add `@pytest.mark.local_only` or skip |
| `relation X does not exist` | Add `@pytest.mark.local_only` or skip |
| `DeadlockDetected` | Add `@pytest.mark.local_only` (needs running server) |
| `AssertionError` (env-specific) | Add conditional skip or `local_only` |
| `fixture 'temp_db' not found` | Add `@pytest.mark.local_only` |

### Step 3: Fix Systematically
```python
# Add skip marker at module level
pytestmark = pytest.mark.skip(reason="Requires X not in CI schema")

# OR add local_only marker
pytestmark = pytest.mark.local_only
```

### Step 4: Verify Locally Before Pushing
```bash
# Run the CI-equivalent test suite locally
pytest tests/ -m "ci and not integration" --ignore=tests/integration/ -q

# Only push when this passes
git push origin main
```

## File Organization

```
tests/
├── unit/                    # @pytest.mark.unit - fast, isolated
│   ├── test_validators.py
│   └── test_utils.py
├── integration/             # @pytest.mark.integration - needs services
│   ├── test_api_routes.py
│   └── test_db_operations.py
├── contract/                # @pytest.mark.ci - API contract tests
│   └── test_api_contracts.py
├── e2e/                     # @pytest.mark.local_only - full environment
│   └── test_full_flows.py
└── conftest.py              # Shared fixtures with CI detection
```

## conftest.py Additions

```python
# Add to tests/conftest.py

def pytest_configure(config):
    """Register custom markers."""
    config.addinivalue_line("markers", "ci: Tests that must pass in CI")
    config.addinivalue_line("markers", "local_only: Tests requiring full local schema")
    config.addinivalue_line("markers", "unit: Fast isolated unit tests")


def pytest_collection_modifyitems(config, items):
    """Auto-skip local_only tests when CI environment detected."""
    if os.getenv("CI") or os.getenv("GITHUB_ACTIONS"):
        skip_local = pytest.mark.skip(reason="local_only tests skipped in CI")
        for item in items:
            if "local_only" in item.keywords:
                item.add_marker(skip_local)
```

## Summary: The Golden Rules

1. **Every test file needs a marker** - `ci`, `local_only`, or `unit`
2. **Pre-push runs fast tests only** - unit + ci-marked, < 3 minutes
3. **Schema awareness** - know what CI has vs what local has
4. **Fail fast locally** - don't push tests that can't pass CI
5. **Skip gracefully** - use `pytest.mark.skip` with clear reason
6. **Recovery is systematic** - categorize failures, fix in batches

## Related Files

- `.pre-commit-config.yaml` - Hook configuration
- `pyproject.toml` - pytest configuration
- `tests/conftest.py` - Shared fixtures
- `.github/workflows/ci.yml` - CI workflow

# CI Test Protocol Template

**Purpose:** Drop this into any new Python project to prevent CI test debt accumulation.

---

## SETUP CHECKLIST (Do These 4 Things)

```
┌─────────────────────────────────────────────────────────────────────┐
│  BEFORE WRITING ANY TESTS, COMPLETE THIS CHECKLIST:                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  □ 1. Add markers to pyproject.toml (copy from Section 1 below)    │
│                                                                     │
│  □ 2. Add auto-skip logic to tests/conftest.py (copy from Sec 2)   │
│                                                                     │
│  □ 3. Update pre-push hook to run unit tests only (copy from Sec 3)│
│                                                                     │
│  □ 4. Create test directory structure:                              │
│       tests/                                                        │
│       ├── unit/           # Fast, no DB (@pytest.mark.unit)         │
│       ├── integration/    # Needs services (@pytest.mark.integration)│
│       └── e2e/            # Full env (@pytest.mark.local_only)      │
│                                                                     │
│  TIME: ~5 minutes                                                   │
│  PREVENTS: Hours/days of CI debugging later                         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Quick Setup (5 minutes)

### 1. Add to `pyproject.toml`

```toml
[tool.pytest.ini_options]
markers = [
    "ci: Tests that must pass in CI environment",
    "local_only: Tests requiring full local schema (skipped in CI)",
    "unit: Fast isolated unit tests (no DB required)",
    "integration: Tests requiring running services",
    "e2e: End-to-end tests requiring full environment",
]
testpaths = ["tests"]
```

### 2. Add to `tests/conftest.py`

```python
import os
import pytest


def pytest_configure(config: pytest.Config) -> None:
    """Register custom markers for CI test protocol."""
    config.addinivalue_line("markers", "ci: Tests that must pass in CI")
    config.addinivalue_line("markers", "local_only: Tests skipped in CI")
    config.addinivalue_line("markers", "unit: Fast isolated unit tests")
    config.addinivalue_line("markers", "integration: Tests requiring services")


def pytest_collection_modifyitems(items: list[pytest.Item]) -> None:
    """Auto-skip local_only tests in CI environment."""
    is_ci = os.getenv("CI") or os.getenv("GITHUB_ACTIONS")

    for item in items:
        markers = {m.name for m in item.iter_markers()}

        # Skip local_only in CI
        if is_ci and "local_only" in markers:
            item.add_marker(pytest.mark.skip(reason="local_only skipped in CI"))
```

### 3. Update pre-push hook (`.pre-commit-config.yaml`)

```yaml
# FAST: Only run unit tests on pre-push (< 30 seconds)
- id: backend-tests-fast
  name: Backend Tests (unit only)
  entry: bash -c 'pytest tests/unit/ --tb=short -q || exit 1'
  language: system
  stages: [pre-push]
```

### 4. Create test directory structure

```
tests/
├── unit/           # @pytest.mark.unit - run on every push
├── integration/    # @pytest.mark.integration - run in CI
├── e2e/            # @pytest.mark.e2e or @pytest.mark.local_only
└── conftest.py     # Shared fixtures
```

---

## The Rules

### Rule 1: Every Test File Gets a Marker

At the top of every test file:

```python
import pytest

# Choose ONE:
pytestmark = pytest.mark.unit        # Fast, no DB
pytestmark = pytest.mark.ci          # Must pass in CI
pytestmark = pytest.mark.local_only  # Full local env only
pytestmark = pytest.mark.integration # Needs running services
```

### Rule 2: Know Your CI Schema

Document what's available in CI vs local:

```markdown
## CI Environment Has:
- Tables: users, projects, tasks
- Columns: All standard columns

## CI Environment Does NOT Have:
- Table: analytics_events (created by migration not in CI)
- Column: users.premium_tier (added later)
- External services: Redis, Elasticsearch
```

### Rule 3: Pre-Push = Fast Tests Only

Pre-push should complete in < 60 seconds:
- Unit tests only
- No database tests
- No network tests

Full test suite runs in CI, not locally.

### Rule 4: Skip Gracefully, Not Silently

When a test can't run in CI:

```python
# GOOD: Clear skip reason
pytestmark = pytest.mark.skip(reason="Requires analytics_events table not in CI")

# GOOD: Conditional skip
@pytest.mark.skipif(
    not os.getenv("REDIS_URL"),
    reason="Requires Redis"
)
def test_caching():
    ...

# BAD: Silent failure
def test_something():
    if not table_exists("analytics"):
        return  # Silent skip - will cause confusion
```

### Rule 5: Fail Fast on Schema Drift

Add schema validation to CI-marked tests:

```python
@pytest.fixture
def verify_schema(db):
    """Fail fast if required schema is missing."""
    required = ["users", "projects", "tasks"]
    for table in required:
        if not table_exists(db, table):
            pytest.fail(f"CI schema missing table: {table}")
```

---

## Recovery Protocol

When CI breaks despite following these rules:

### Step 1: Categorize Failures

```bash
# Get failure summary
gh run view <ID> --log-failed | grep -E "FAILED|ERROR" | sort | uniq -c
```

### Step 2: Match Pattern to Fix

| Error Pattern | Fix |
|--------------|-----|
| `relation X does not exist` | `@pytest.mark.local_only` |
| `column X does not exist` | `@pytest.mark.local_only` |
| `fixture 'X' not found` | `@pytest.mark.local_only` |
| `ConnectionRefused` | `@pytest.mark.integration` |
| `AssertionError` (env-specific) | Conditional assertion or `local_only` |

### Step 3: Batch Fix

```python
# Add to top of affected test file
pytestmark = pytest.mark.skip(reason="<specific reason>")
```

### Step 4: Verify Locally

```bash
# Run what CI runs
pytest tests/ -m "not local_only" --ignore=tests/e2e/ -q
```

---

## Checklist for New Tests

Before committing any new test:

- [ ] Added module-level marker (`unit`, `ci`, `local_only`, or `integration`)
- [ ] If `ci` marked: uses only CI-available schema
- [ ] If `ci` marked: no external service dependencies
- [ ] If `ci` marked: deterministic assertions (no timing, no randomness)
- [ ] Ran test locally: `pytest tests/path/to/test.py -v`
- [ ] Skip reason is specific if using `pytest.mark.skip`

---

## Anti-Patterns to Avoid

### 1. Running All Tests on Pre-Push

```yaml
# BAD: Takes 10+ minutes, will timeout
entry: pytest tests/ --tb=short

# GOOD: Unit tests only, < 30 seconds
entry: pytest tests/unit/ --tb=short
```

### 2. Silent Environment Detection

```python
# BAD: Test silently passes when it should fail
def test_feature():
    if not os.getenv("FEATURE_ENABLED"):
        return
    # ... actual test

# GOOD: Explicit skip
@pytest.mark.skipif(not os.getenv("FEATURE_ENABLED"), reason="Feature not enabled")
def test_feature():
    # ... actual test
```

### 3. Catching All Exceptions

```python
# BAD: Hides real failures
def test_something():
    try:
        result = dangerous_operation()
        assert result
    except:
        pass  # "It's fine"

# GOOD: Let it fail
def test_something():
    result = dangerous_operation()
    assert result
```

### 4. Unmarked Test Files

```python
# BAD: No marker = unknown behavior in CI
class TestMyFeature:
    ...

# GOOD: Explicit marker
pytestmark = pytest.mark.ci

class TestMyFeature:
    ...
```

---

## Summary

1. **Marker every test file** - `unit`, `ci`, `local_only`, or `integration`
2. **Pre-push = fast** - Unit tests only, < 60 seconds
3. **CI = comprehensive** - Full suite minus `local_only`
4. **Skip explicitly** - Always with a reason
5. **Document schema** - Know what CI has vs local
6. **Fix in batches** - Don't let failures accumulate

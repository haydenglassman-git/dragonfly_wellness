# Project Instructions

## CI Test Protocol (MANDATORY)

```
+==============================================================================+
|  BEFORE WRITING TESTS: Read .claude/CI_TEST_PROTOCOL.md                      |
|  This prevents CI test failures from accumulating (learned the hard way)     |
+==============================================================================+
```

**Quick checklist before writing tests:**
- [ ] Markers in pyproject.toml (`ci`, `local_only`, `unit`)
- [ ] Auto-skip logic in conftest.py
- [ ] Pre-push runs unit tests only (not full suite)
- [ ] Test dirs organized: `unit/`, `integration/`, `e2e/`

Full protocol: `.claude/CI_TEST_PROTOCOL.md`
Template: `.claude/templates/CI_TEST_PROTOCOL_TEMPLATE.md`

# Walkthrough

> Accumulated proof-of-work log. Each iteration appends a dated entry.
> See [AGENT.md](./AGENT.md) for entry template and update protocol.

---

## 2026-03-28 — Documentation infrastructure setup

**Contributor**: AI agent (Antigravity)
**What was done**: Deep codebase review + created autoresearch-inspired documentation loop. Added `program.md` (agent entry point), `AGENT.md` (contributor protocol), `plan.md` (living iteration plan), `walkthrough.md` (this file). Updated CLAUDE.md, README.md, INDEX.md, ROADMAP.md for coherence.

**Observations**:
- Codebase has 6 codex adapters (claude, gemini, openai, groq, aider + base) but ROADMAP.md was missing Groq/Aider status
- README.md had a broken markdown code block in Installation section (unclosed backtick)
- No iterative contribution mechanism existed — contributors had no way to track what was tried, what worked, what's next
- Karpathy's `program.md` pattern (single entry-point skill file) maps well to this project's multi-contributor model

**Decisions made**:
- `program.md` is the universal entry point (human reads it, agent reads it)
- `AGENT.md` mandates documentation updates — this is the enforcement mechanism
- `plan.md` replaces informal TODO tracking with structured experiment tracking
- `walkthrough.md` provides institutional memory across sessions
- CLAUDE.md remains as technical internals doc but now points to AGENT.md for contribution protocol

**Next**: Validate Groq and Aider adapters with real benchmark runs (plan.md items #1, #2)

---

## 2026-03-28 — MiniGrades fix + problem structure rules

**Contributor**: AI agent (Antigravity)
**What was done**: Rewrote all 5 minigrades problem files to match minigit quality level. Added mandatory problem structure rules to program.md.

**Key changes**:
- `problem.json`: replaced incompatible schema with minigit-style (binary_name, v1/v2 spec/test/prompt)
- `SPEC-v1.txt`: 6 commands (init, add, add-grade, delete, list, average-mock), deterministic exact-output format
- `SPEC-v2.txt`: extends v1 with 8 commands (+del-grade, real calc-avg, report, enhanced list)
- `test-v1.sh`: 17 tests, language-agnostic (`./minigrades` not `python3 solution.py`), `PASS:`/`FAIL:` format
- `test-v2.sh`: 25 tests, same format
- `program.md`: added "Problem structure (mandatory)" section with JSON schema, SPEC rules, test script rules

**Observations**:
- Original minigrades was Python-specific (hardcoded `python3 solution.py`) — now language-agnostic
- Test output format was `[PASSED]`/`[FAILED]` — benchmark.rb's `run_tests()` regex expects `PASS:`/`FAIL:` and `PASSED:`/`FAILED:` summary → fixed
- v1 delete message was "Student deleted successfully." but v2 was "Student and all grades deleted successfully." — normalized per version

**Next**: Run `ruby benchmark.rb --problem minigrades --dry-run` to validate loading

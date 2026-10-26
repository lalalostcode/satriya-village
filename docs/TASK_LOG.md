# Satriya Village — Completed Instruction Log

Read recent entries before starting a task. Append one entry after completing a user instruction, covering all related work. Use this record to share outcomes and lessons between agents. Earlier tasks have not been backfilled.

## Entry format

- Date: YYYY-MM-DD (Asia/Jakarta)
- Instruction: What the user requested.
- Outcome: What was completed; distinguish proposals from approved decisions.
- Files changed: Exact paths, or none.
- Verification: Checks performed and actual results; mark untested behavior explicitly.
- Lessons / next step: Findings another agent should reuse, remaining limitations, or the next useful action.

## 2026-10-26 — Require logging after completed user instructions

- Instruction: Add a persistent rule to AGENTS.md so agents log completed user instructions and share what they learned. The user clarified that logging is per completed task, not per code edit.
- Outcome: Added the completed-instruction logging rule, created this shared log, and linked it from the document index.
- Files changed: `AGENTS.md`, `docs/TASK_LOG.md`, `docs/DOCUMENT_INDEX.md`.
- Verification: Markdown links resolve and `git diff --check` passed (Git reported only line-ending conversion warnings). The required Godot parser check could not start: the previously recorded executable is no longer in the workspace, and neither `godot` nor `godot4` was found on PATH. Gameplay was not tested.
- Lessons / next step: Group related edits into one task entry. For explicitly read-only tasks, present the proposed entry in the response instead of modifying repository files. This is a documentation task; gameplay acceptance remains untested.

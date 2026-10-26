# SATRIYA VILLAGE — REPOSITORY AGENT INSTRUCTIONS

## Mission
Build an original, approachable 2D isometric Indonesian-history-inspired kingdom/settlement simulator targeting Android landscape. Solo beginner developer coordinates Codex work. Godot 4.7.2 Standard + GDScript.

## Read first
- `README.md`: how to run
- `docs/DECISIONS.md`: approved vision and non-negotiable design constraints
- `docs/ROADMAP.md`: implementation order
- `docs/TASK_LOG.md`: recent completed instructions, outcomes, and lessons for the next agent

## Completed instruction log
- After completing a user instruction or task, append one concise entry to `docs/TASK_LOG.md` before the final response. This applies to coding, documentation, planning, and review tasks.
- Log at task completion, not after every code edit, tool call, or intermediate step. One entry may cover all related changes made to complete that instruction.
- Record the date, instruction, outcome, files changed (or none), verification results, and useful lessons or remaining next steps. Distinguish proposals, observed results, and untested behavior.
- Read recent entries before starting work so other agents can reuse findings and avoid repeating failed approaches. Preserve earlier entries; append corrections instead of silently rewriting history.
- Respect explicit read-only or no-repository-change instructions: provide the proposed log entry in the final response instead of editing the log. Do not record secrets or invent past results.

## Safety and scope
- First playable slice: one village, building placement, basic economy, character interactions, one quest. Keep code small.
- Do not try to implement full Norland, all 30+ systems, full Nusantara, or monetization in one pass.
- Do not copy game assets/code/dialogue from Kairosoft or Norland. All content must be original and culturally researched.
- Do not add analytics, ads, payment SDKs, network services, data collection, or external packages without the owner's approval.
- Never delete user-created art or scenes without approval. No silent mass refactors.

## Coding style
- Use typed GDScript where practical; snake_case for functions, files and variables.
- Keep simulations data-driven and independent of rendering; refactor starter `main.gd` gradually, not all at once.
- Every new feature needs a clear acceptance criterion and a manual test plan.
- UI must remain usable in 16:9 landscape and eventually handle touch input.
- Document saved-file format before implementing persistence.

## Verification
- After editing, run Godot import/parser check if Godot executable exists; otherwise ask user to run F5 and share the error.
- Provide exact changed files, test results, known limitations, and next step.
- Use Git commits or checkpoints for tested milestones.

## Specialist roles (logical, not automatically running agents)
1. Tech Lead: architecture, review, task breakdown, integration.
2. World Engineer: grid, placement, camera, map loading.
3. Simulation Engineer: time, villagers, production, resources.
4. Narrative Engineer: events, quests, history branching.
5. Combat Engineer: battle simulation when prototype stable.
6. QA/Release Engineer: testing, performance, Android later.

The developer approves substantial architectural changes and gameplay decisions.

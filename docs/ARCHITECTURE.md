# Starter architecture

Historical starter overview: inspect the actual commit and working tree during [M0 audit](M0_AUDIT_PLAN.md) before treating this as current implementation evidence. The documentation-only review does not certify concurrent source edits. Current target contracts are draft [TDD](TDD.md) and [SAVE_FORMAT](SAVE_FORMAT.md), with activation controlled by [Quality Gates](QUALITY_GATES.md).

- `project.godot`: engine settings, startup scene, renderer.
- `scenes/main.tscn`: sole entry-point scene.
- `scripts/main.gd`: intentionally compact demo for first boot, not production architecture.
- `assets/`: future original art only.
- `data/`: future game data files (JSON/Resources).
- `tests/`: future automated checks.

## Planned production modules
SimulationClock, WorldModel, SettlementModel, EconomyModel, CharacterModel, EventEngine, SaveGame, TacticalBattle.
All progression systems must be deterministic and data-driven where possible, and decoupled from scene rendering.

The major first refactor is to separate clock, building placement, and resource simulation out of `scripts/main.gd` after baseline runs successfully.

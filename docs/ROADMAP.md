## Active Director priority — 2026-10-26 visual rework

The Director explicitly supersedes the earlier mechanics-first implementation sequence: V01 environment, V02 sprite assets, V03 chibi presentation, V04 compact mock UI, V05 visual review. The initial procedural visual was REJECTED / REVISE. The Director approved the visual direction on 27 October 2026 and requested proportion/footprint refinement. Apply the [48×24 footprint baseline](PROPORTIONS_FOOTPRINTS.md); composition acceptance remains pending. Keep this task limited to proportion, layout and readability; the approval does not authorize new mechanics, unrelated audits or large architecture changes. Existing mechanics stay available in main.tscn via F6; visual_village.tscn is the F5 target. See [implemented asset inventory and review](../assets/visual/README.md). Historical roadmap entries below remain history and retained vision, not authorization to bypass this gate.
# Roadmap

## Optional guidance implementation — 27 October 2026

Added one [food-guidance quest](M2_FOOD_QUEST.md) to the shared session/Laras panel, available in the integrated F5 scene. Accept → observe an actual successful harvest → explicitly complete, or decline the optional guidance. Terminal outcomes are saved with stable resolution IDs and reject duplicate application; no new economic reward or penalty. Optional v4 envelope preserves nested legacy/visual village formats and publishes quest/village together. Final related checks: 634 PASS, 0 FAIL, with rendered F5 quest evidence. This remains partial M2: official authority, two economic crisis strategies, wood recovery and physical Android acceptance are still pending.

## Mechanics continuation — 27 October 2026

After the aggregate-worker recommendation, the Director requested continuation in the mechanics task. Added a small [read-only agriculture-official interaction](M2_OFFICIAL_INTERACTION.md) to `scenes/main.tscn` (F6): named official/player markers, a shared panel, live food/worker reports, modal input protection and mouse/touch coverage. Final related desktop suites pass 471 assertions. This does not change the F5 visual-review priority, approved footprint/art baseline, or authorize the rest of M2; authority limits, quests, mutable characters and integration with the visual scene remain pending.

## Implementation evidence update — 2026-10-26

The Director subsequently authorized implementation and requested the remaining M1 foundations. Grid/placement/state/inventory/clock/camera, versioned manual persistence, touch tap/drag/pinch and separate autosave are now implemented; [M1 verification](M1_FOUNDATION_VERIFICATION.md) records 281 passing desktop assertions and a rendered 1280×720 HUD check. The documentation-only statements below describe the earlier planning checkpoint. M0/M1 human acceptance and Android physical-device evidence remain outstanding; no connected ADB target was found. This update does not ratify pilot/MVP scope or enable all deferred systems.

The next authorized M2 step adds [aggregate farming allocation](M2_WORKFORCE_CONTRACT.md): one worker per field, manual/automatic worker cap, worker-dependent production, HUD forecast/daily report and schema v2 with strict v1 migration. Final regression/migration/restart runs have 406 passing assertions. This is partial M2 implementation; individual worker AI, officials, character interactions and quests remain pending.

## Status and scope gates — 26 October 2026

The sequence M0–M4 is retained. [PRD v1.1](PRD.md) is a revision of v1.0 and remains **DRAFT**. The Director accepted the direction of a one-village vertical slice in principle while retaining the complete Satriya Village vision. Detailed slice manifest O01-S, pilot scope O01-P, and MVP definition O01-M have separate decisions in the [Decision Register](DECISION_REGISTER.md). M3/M4 below describe intended progression, not approved pilot content or dates.

A02 gameplay audit is **NOT TESTED**; M0 is not marked passed. Early Android validation is accepted in principle, with the device and execution plan O04 still OPEN. Runtime evidence and feature contracts remain separate from document approval. Current work is documentation only.

Reviewer S12 provides a provisional planning baseline: the slice manifest includes simple wood collection and a visible player with one interaction (FR19); O02 uses 13+/Indonesian/non-graphic onboarding for design, not a store rating. These are not explicit Director scope approval. O03 hours/budget/PC and O04 device fields remain TBD and do not block documentation; estimates and device tests wait for their inputs. [GDD](MASTER_GDD.md), [TDD](TDD.md), [Execution Plan](AI_AGENT_EXECUTION_PLAN.md), [Quality Gates](QUALITY_GATES.md) and [M0 Audit Plan](M0_AUDIT_PLAN.md) now prepare the conditional progression. No new feature before baseline audit/stability and the relevant contracts are ready.

## Milestone 0 — first boot [STARTER]
- Godot project opens and F5 runs.
- Placeholder isometric grid shows and buttons work.
- User can pick a building, place it, and change time speed.
- Git repository initialized and baseline committed.

## Milestone 1 — playable settlement slice
- Convert visual grid to modular reusable system.
- Tile placement, occupancy, construction costs.
- Basic resource inventories + production/consumption separated from rendering.
- Camera pan and zoom; mouse then touch interactions.
- Save and load; autosave and format versioning.

## Milestone 2 — living village
- Lightweight worker AI and role priorities.
- Named agriculture official with authority limits.
- Provisional FR19: a visible player character and one simple interaction through shared UI, with no full movement/avatar-editor subsystem.
- Event / quest framework; introductory crop-crisis quest.
- Tests and balancing checks.

## Milestone 3 — conflict prototype
- One neighboring settlement with world map summary.
- Diplomacy values, a small commander-led tactical battle in separate arena.
- Defeat/retreat loop and political consequence.

## Milestone 4 — Android pilot
- Landscape touch controls, fonts, performance budgets, Android build testing.
- One coherent East Java chapter, proper save, error reporting.
- Verify current Google Play policies and families/ad requirements before shipping.

## Scope control
Do not implement future vision features as part of Milestone 0 unless explicitly approved.

## Retained vision and conditional expansion

These are retained vision requirements, not removed by a one-village slice. Activation gates, design work and acceptance intent are traced in [PRD §7](PRD.md); they do not create dated milestones or automatic pilot/MVP scope.

| Retained vision / source | Conditional progression |
|---|---|
| Politics, vassal/independent paths, officials, diplomacy, betrayal, intrigue/intelligence — D04/D14, DECISIONS and retained reviewer vision | Official interaction in the slice baseline; neighbor/diplomacy in the pilot proposal; deeper politics after authority, relationships and events |
| Custom dynasty, six attributes, personality, succession — D12/D13, DECISIONS | Basic characters first; simple dynasty remains pilot vision with exact scope OPEN; deeper succession after calendar/continuity design |
| Tactical warfare, formations/commander skills, open-field battle, settlement siege, heavy defeat/exile — D09–D11 | Limited arena battle after slice acceptance; siege and wider defeat/recovery after combat/settlement/persistence contracts |
| Deep economy, production chains/quality, local storage, logistics, manual/delegated settlements and hybrid research — D08/D15–D20 | Local economy foundation; multiple settlements after save/economy stability; deeper chains, knowledge and logistics after their prerequisites |
| Optional guidance, crisis/upeti/mystery, branching history and time skips — D02/D03/D21–D23 | Local quest proposal first; broader history scheduler after calendar/event contracts; no offline war/major story resolution |
| Nusantara political unification through multiple strategies — DECISIONS Premise | Expansion after multi-region politics, economy, logistics, content and Android capacity are demonstrated |

At every scope review, keep deferred requirements linked to their source and gate. Before implementation, settle the relevant decisions; feature vision alone does not authorize engineering.

## Current priority update — 27 October 2026: integration delivered

The Director's latest instruction supersedes the earlier visual-only gate and F5/F6 split. F5 now combines Nusantara sprites with existing simulation, footprint placement, workers, reports and safe save/load. HUD was verified before placement integration; [evidence, manual checklist and limitations](VISUAL_GAMEPLAY_INTEGRATION.md) record the results. No additional M2 quest/economy or M3 systems were introduced. Next is human F5 acceptance and physical Android validation, not automatic expansion of the roadmap.

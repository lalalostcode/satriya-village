# Visual/gameplay integration — 27 October 2026

## Acceptance and implementation

The current Director instruction authorizes gradual integration of the previously separate F5 visual and F6 simulation scenes. F5 remains `scenes/visual_village.tscn`, now the playable entry point. Existing original PNGs, 48×24 tile baseline and major-building size hierarchy remain in use. No new economy, wood system, politics, dynasty, combat or quest was added.

| Stage / acceptance | Implementation and evidence |
|---|---|
| 1. HUD shows real inventory, day, speed and workers; paused time does not advance | `village_session.gd` adapts the existing main controller, suppressing its legacy drawing/input/HUD. The visual scene binds its labels and panels to that one session. Four rendered checks passed before placement work; intermediate screenshot `integration_hud.png` still contains the pre-integration decorative building composition. |
| 2. Place house/field/granary through model commands, once per tap/click, with atomic cost and legal footprint | `village_layout.gd` supplies geometry, roads, water and landmark reservations to settlement placement, save validation and the visual view. Green/red preview covers all four footprint cells. Actual viewport click/release creates all three types; occupancy/gap/reserved/out-of-bounds/insufficient wood reject without debit. |
| 3. Initial and new buildings are distinguishable; no sprite economy | Three initial model buildings reproduce the old economic baseline. Static landmarks have no production. The sprite list is rebuilt from model buildings; initial/imported origins are persisted, new ones are not added to that set. Selected field reports actual allocation. Decorative scenery is only hidden where construction covers its anchor. |
| 4. Existing workers, clock, characters and persistence operate in F5 | Existing controller commands and lifecycle/autosave are reused. Chief and Laras open the existing modal and report service. Reports refresh on tick/commands, modal blocks world input. Save/load rebinds the view and resets placement/camera/gestures. |
| 5. Existing saves survive | Save contract documented before implementation. v1/v2 remain readable; visual load migrates coordinates on a staging model. 100-building fixture retains counts, resources, population, worker cap and deterministic ordering; full footprint validation passes. Source file bytes stay unchanged after load; explicit save publishes v3 with v2 backup; that backup loads again. |

The authored 20×20 center remains the starting composition. The model now supports a 40×40 visual layout to fit legacy saves of up to 100 buildings with 2×2 footprints and one-tile gaps, without deleting structures. This is simple surrounding buildable land, not a second settlement/world system. Legacy layout models remain available for regression fixtures and still write v2. `main.tscn` is retained for those tests; players use F5 only.

## Final checks

Godot `4.7.2.stable.official.ed1daf0bf`. Compatibility rendering on Intel Arc A530M, 1280×720. Test file outputs go under `.godot` or an isolated APPDATA, not the player's save slots.

| Suite | Result |
|---|---:|
| `tests/test_prototype.gd` (headless) | 75 pass |
| `tests/test_persistence.gd` (headless) | 115 pass |
| `tests/test_m1_foundation.gd` (headless) | 98 pass |
| `tests/test_workforce.gd` (headless) | 111 pass |
| `tests/test_official_interaction.gd` (headless) | 71 pass |
| `tests/test_visual_hud.gd` (rendered stage 1; headless regression also passed) | 4 pass |
| `tests/test_visual_smoke.gd` (rendered) | 23 pass |
| `tests/test_visual_integration.gd` (rendered) | 47 pass |
| Total final suite results | **544 pass, 0 fail** |

Import/parser: exit 0 with no errors in final normal-access run. Godot scene reference checker: 0 errors, 0 warnings, 91 files checked. Main-project launch and scene tests do not substitute for a human pressing F5 and playing. Screenshots inspected: `integration_village.png`, `integration_playable.png`, `integration_controls.png`, `integration_footprints.png` (plus intermediate HUD evidence).

Local logs: `.godot/integration-final-import.log`, `.godot/*-integration.log`, `.godot/step1-render.log`, `.godot/playable-integration.log`, `.godot/visual-integration-render.log`. They are generated/ignored; checked-in scripts and screenshots are the reproducible evidence. Example: `Godot_v4.7.2-stable_win64_console.exe --path . --script tests/test_visual_integration.gd`. Run fixtures with APPDATA redirected to a test directory; do not launch multiple gameplay instances against one save slot.

During development, a test expected `occupied` for a footprint also crossing a road; the fixture was corrected to isolate overlap. Character selection was updated to retain the selection index while opening the real panel. One later rendered synthetic-input run missed placements and cascaded failures; immediate headless and rendered reruns both passed. Desktop focus/input timing is a remaining test reproducibility caveat (focus loss intentionally cancels gestures); no unverified cause is claimed. Initial sandbox editor import emitted cache permission errors; final normal-access import completed cleanly. No human/device acceptance is inferred from these checks.

## Manual F5 plan

1. F5: expect one house, two active fields, 120 wood/60 food/150 coins/8 citizens. At 1x wait one day: food +7, coins +2. Pause and wait: no automatic changes. Try 2x/3x, then pause.
2. Bangun → Rumah, place at origin (2,13) using G overlay; expect 90 wood and 10 citizens, a new sprite and NEW status. Sawah at (14,10), Lumbung at (11,12): expect 25 wood. Retry occupied/adjacent/road/water/outside sites: no changes. Preview reflects validity and cost. Cancel with Esc.
3. Kelola: reduce farmers to zero; next day has no harvest. Restore automatic; each field activates subject to population. Select a field and compare assigned workers with the HUD. Open Laras Pangan/Pekerja and compare live reports; open Anda. Click/drag outside modal: no building or camera change. Esc closes safely.
4. Save paused with manual worker cap, build/change cap, load: original buildings/stock/cap/speed return. Check labels initial/imported vs new. Exercise manual backup, automatic load/backup, and protected startup toggle using test slots.
5. Load a COPY of a v1/v2 save: counts/stocks/population/time preserved, coordinates relocated to legal plots; source bytes unchanged until Save. Save once and check previous legacy version remains in backup. Never use a valuable sole save as a destructive fixture.
6. Pan/zoom and place/select again. Native touch: tap builds once, drag/pinch never builds, HUD taps do not leak into the world. Check gate center remains open and size tiers unchanged. Repeat on physical Android when a device/export setup is available.

## Exact changed files

Code: `scripts/presentation/village_session.gd` (+ UID), `scripts/simulation/village_layout.gd` (+ UID), `scripts/simulation/settlement_state.gd`, `scripts/persistence/save_store.gd`, `scripts/visual/village_art.gd`, `scripts/visual/visual_village.gd`.

Tests: `tests/test_visual_hud.gd` (+ UID), `tests/test_visual_integration.gd` (+ UID), `tests/test_visual_smoke.gd`.

Documentation: `README.md`, `docs/SAVE_FORMAT.md`, `docs/VISUAL_GAMEPLAY_INTEGRATION.md`, `docs/DECISIONS.md`, `docs/ROADMAP.md`, `docs/TASK_LOG.md`.

Evidence: `docs/screenshots/integration_{hud,village,playable,controls,footprints}.png` and their generated `.import` metadata. Original asset PNGs and previous proportion screenshots were not edited. The character changes present at task start were preserved; their separate commit is not part of this integration.

## Limits and next step

Finite starting wood limits building, because the existing model has no wood replenishment. Granary has cost/persistence but no storage bonus. Character idle art is decorative; only reports/identity are functional. No active food quest was present to connect, so the mock quest button was replaced with management. Outer land lacks authored scenery, and maximum-village/mobile performance is untested. Save migration preserves economic content but intentionally relocates legacy spatial arrangements. Future footprint/content changes need an explicit compatibility revision rather than silently editing rules under visual-1.

Next: human F5 acceptance against the checklist, then physical Android interaction/lifecycle testing. Further economy or art scope requires a separate instruction.

# M2 aggregate farming prototype — 2026-10-26

The Director requested continuation after the aggregate-worker/observable field-production recommendation. This contract implements that small prototype feature, not final economy balancing or approval of the entire M2 slice. Existing PRD/GDD O07 proposals remain open outside this contract.

## Rules and acceptance

- Workforce is an aggregate count, provisionally equal to current prototype population. No age, health, pathfinding or named-character simulation is invented. Decorative sprite count never changes worker availability or output.
- Each rice field has one worker slot and produces the existing 5 food/day only when staffed. Houses/granaries have zero worker slots. Definitions remain data-driven. Default automatic allocation staffs fields up to both field-slot capacity and workforce.
- Stable allocation order is row-major `(y, x)`. Count-based workers have no individual NPC identity. Total assigned + idle = population and no slot is counted twice. A field with no worker produces zero.
- Saved `farm_worker_target` is an integer: `-1` means automatic; otherwise 0..population caps agricultural assignment. Petani −/+ changes the current actual count by one within available population/slots; Otomatis restores the automatic policy. Commands are valid during pause, cost nothing and advance no clock. New fields/houses recompute assignment; a manual cap stays in effect until changed or switched to automatic.
- Keep other starter rules: starting population 8, house adds 2 population, total food need 3/day, coins +2/day, existing wood costs and eight seconds/day. At the initial village: 2 farmers, 6 idle, production 10, consumption 3, net +7. At 1 farmer: production 5, net +2. At 0 farmers: production 0, net -3 while food remains. Zero food consumes zero and records unmet need instead of negative stock. No starvation consequence/recovery mechanic is added.
- Daily report: produced food, consumed food, unmet food need, net food, coin income and assigned workers, from the same single model transaction. Reports are observational and transient; no extra economic effect. HUD shows assignment/idle count and the next-day food projection, then reports the latest real production when a day advances. Load clears the transient report and restores projection/policy.
- Current draw/HUD remains the view; all allocation/production decisions are renderer-independent. Three touch-sized workforce buttons occupy the previous help row; footer moves to y=516, leaving the default map (bottom edge y=512) visible. HUD consumption and touch/camera cancellation must remain intact.

## Save contract change (before implementation)

Write `schema_version: 2`, `content_version: "prototype-2"`. Add exactly `settlement.farm_worker_target` with the validation above. Other v1 fields and paths remain unchanged. Load accepts validated v1/prototype-1 on a deep copy, inserts automatic target `-1`, upgrades the envelope and validates all v2 fields before producing staging models. Loading alone never rewrites source bytes; the next explicit/manual or enabled automatic save writes v2. Previous v1 data may be represented as validated v2 in the rotating backup. Versions >2, incompatible content and extra/missing fields remain rejected/protected. Old game builds intentionally reject v2 rather than discarding the policy.

Do not persist derived assignment counts, sprite data or daily reports. Manual/automatic saves and backups must retain the player's target; autosave dirty comparison must detect paused policy changes. Test v1 migration, no mutation of source data, v2 round-trip, invalid target rejection, failed-load session preservation and future-version protection.

## Manual check

1. Open `scenes/main.tscn` and press F6, then Pause: HUD should show Petani 2/2, Bebas 6, Pangan +10 -3 = +7/hari. Click Petani −: 1/2, Bebas 7, projection +2. No stock/day change yet.
2. Run exactly one day: food 60 → 62, coins 150 → 152. Pause; reduce to 0 farmers, run one day: food 62 → 59. Day report should match actual stock changes.
3. Pause, restore Otomatis: 2 farmers again; build one field: 3 farmers and production 15/day. A manual cap of 1 must remain 1 after adding a field.
4. Save a target of 1, change to automatic, then load: target/projection must return to 1. Repeat with the separate autosave and restart fixture. Load an old v1 save: its buildings/resources/calendar remain, with automatic worker allocation.
5. Drag/pinch or tap any workforce button: no unintended building/debit. Check all buttons/status fit at 1280×720. Sprite count changes cannot alter headless production results.

Runtime evidence is appended after implementation; Android physical touch and Director acceptance remain separate.

## Actual implementation and verification

Implemented allocation and report functions in `settlement_state.gd`, catalog worker-slot definitions, three workforce controls and live forecast/daily feedback in `main.gd`, and strict v1→v2 migration in the existing save store. The new worker policy participates in both manual and automatic snapshots. Daily reports remain transient. No package, art, scene replacement or individual NPC AI was added.

Godot `4.7.2.stable.official.ed1daf0bf` editor import/parser passed with exit 0 and no script errors. Final relevant runs:

| Suite | Result |
|---|---|
| Existing prototype gameplay/camera | 75 PASS, 0 FAIL |
| Persistence integrity/fault injection/UI | 115 PASS, 0 FAIL |
| M1 touch/autosave/lifecycle + all new button bounds | 96 PASS, 0 FAIL |
| Workforce model, UI, migration and rendered capture | 111 PASS, 0 FAIL |
| Separate process write / read with saved worker policy | 1 + 8 PASS, 0 FAIL |
| Total final assertions | 406 PASS, 0 FAIL |

The earlier headless workforce run (110 checks) is not counted again; the final rendered run adds one screenshot check. All runners returned exit 0. Inspected `.godot/workforce-tests/workforce-ui.png`: all controls and the worker projection fit at 1280×720 in Compatibility renderer (Intel Arc A530M). That capture shows one farmer, seven idle citizens and +2 food/day. A rendered test run is not human F5 acceptance or physical Android validation.

Worker tests cover scarce/zero population, no fields, manual cap across placement, deterministic tie-break regardless of insertion order, no production without assigned workers, exact daily ledger and unmet need, speed equivalence, paused policy commands, viewport mouse/touch control, no accidental placement, policy round-trip/autosave/restart, strict invalid-target rejection, and v1 migration with unmodified source data/file bytes. Existing save fault-injection and all previous touch/lifecycle regressions still pass. Test data uses isolated `.godot/` paths, never the player's real save slot.

Re-run from the project folder:

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --editor --import --quit
& $godotExe --headless --path . --script res://tests/test_prototype.gd
& $godotExe --headless --path . --script res://tests/test_persistence.gd
& $godotExe --headless --path . --script res://tests/test_m1_foundation.gd
& $godotExe --path . --script res://tests/test_workforce.gd -- --render-smoke
& $godotExe --headless --path . --script res://tests/test_persistence.gd -- --restart-write
& $godotExe --headless --path . --script res://tests/test_persistence.gd -- --restart-read
```

Limitations: workforce availability equals population as an explicit prototype rule; no age/health/worker travel or named-character contribution. No wood recovery, housing/storage rebalance, quest or hunger consequence. Human F5 and Android physical-device checks remain NOT TESTED. M2 is not complete. Next recommended task: a named agricultural official with one short interaction that explains current food/worker state; keep authority/quest mechanics a separate step.

Concurrent workspace change: a separate visual task created `scenes/visual_village.tscn`, `scripts/visual/`, screenshots and `tests/test_visual_smoke.gd`, and changed `project.godot` to launch the visual scene. Those paths were not modified/staged by this task. All gameplay suites explicitly load `scenes/main.tscn`; use F6 on that scene or launch it by explicit path. Visual/mockup integration with this model is not tested or claimed here. Scoped whitespace checks passed; the separate `project.godot` edit has an extra blank line at EOF, left untouched.

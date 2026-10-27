# M2 official interaction — 2026-10-27

The Director requested continuation after one named agriculture-official interaction was recommended. This small step adds a read-only interaction to the existing simulation scene `scenes/main.tscn` (F6). The approved visual-review F5 scene and its footprint/art rules remain separate. This does not complete M2, FR19, official authority or a quest system.

## Contract before implementation

- Static character definitions: `village_chief` = Kepala desa (Anda), `agriculture_official` = Laras, Pejabat pertanian. Laras is an original fictional prototype character; no historical office/name authenticity is claimed. Stable definition IDs and line IDs are separate from displayed text.
- Player actor ID must be `village_chief`. The official supports `food_report` and `workforce_report`; the player marker supports `identity`. Unknown actor, target or unavailable action is rejected. No arbitrary expressions, script loading or external dialogue packages.
- The official greets the chief and reports current day, stocks, worker/field counts, production, fulfilled consumption, unmet need and net food projection from the live settlement model. Advice distinguishes no fields, no workers, insufficient assigned workers, food shortage and staffed surplus. Workforce text explains the current manual/automatic policy. Reports never grant resources, change assignment, create NPCs or advance time.
- Reuse the two existing placeholder character drawings as individually labeled static player/official markers at their existing anchors. Their presence does not add population/workforce or block model occupancy. Clicking/tapping a marker opens its panel before world placement; a HUD Bicara button also opens the official. Marker hit regions remain 44 design pixels wide in screen space after pan/zoom. This is an interaction anchor, not autonomous movement/pathfinding.
- Panel uses the same presentation for both characters, two official topics, and Tutup/Esc. Opening does not force pause or resume. While open, it consumes world input; dragging/pinching/closing cannot build or debit. Simulation can advance at its chosen speed; reports refresh on normal HUD/day updates. Reopening always reads fresh model state. Successful load closes any old panel; reopening reads the loaded session.
- Dialogue has no persistent state: no seen flag, rewards, relationships, assignments, quest or mutable character identity. Save schema stays v2; static IDs come from content definitions. This does not claim the future customizable player/official lifecycle has been serialized.

Acceptance: reports match actual model values under surplus/shortage/zero-worker fixtures; invalid IDs reject; repeated interactions do not mutate snapshots; mouse and native touch open/select/close; pause/speed unchanged; modal blocks placement/camera; transformed marker pick is correct; after load/tick/reopen text uses current data; all controls/text fit 1280×720. Existing simulation/save/touch regressions must pass. Android physical input and Director acceptance remain separately reported.

## Manual check

1. Open `scenes/main.tscn`, F6, Pause. Click Bicara: Laras or the Laras marker. Expect a greeting addressed to the village chief, 60 food, 2/2 farmers, production 10 and net +7/day; no stock/day/speed change.
2. Select Pekerja, close, change Petani - to 1, reopen: expect 1 farmer and 7 idle citizens, manual cap 1, production 5/net +2. Zero farmers should explain that fields need workers.
3. While the panel is open, click outside it or drag/pinch: no building, debit or camera movement. Tutup and Esc close safely. Click the Anda marker: expect player identity, without increasing population.
4. Open the report at 1× and let one day pass: day/stock figures refresh. Save a worker cap, change it and reload, then reopen: report matches the loaded policy.
5. Repeat marker picking after pan/zoom and native touch topic/close controls. Inspect at 1280×720. Use the separate F5 scene only for visual review; the official feature is not integrated there.

## Actual results

Godot `4.7.2.stable.official.ed1daf0bf` import/parser PASS, exit 0, no script errors. The Compatibility rendered interaction suite passed and its 1280×720 screenshot was inspected: title, role, all report text and 44-pixel topic/close targets fit. Longer empty-food/zero-worker reports were also checked for body/card bounds. Screenshot is generated at `.godot/official-tests/official-ui.png` and is not a tracked art asset.

| Final related run | Result |
|---|---|
| Prototype gameplay/camera | 75 PASS |
| Save integrity/fault injection/UI | 115 PASS |
| M1 touch/autosave/lifecycle and visible HUD bounds | 98 PASS |
| Aggregate-worker/migration/UI | 111 PASS |
| Rendered official reports/markers/modal/native touch | 72 PASS |
| Total | 471 PASS, 0 FAIL; all processes exit 0 |

Tests verify valid/invalid actor/target/action IDs, live surplus/unstaffed/no-field/no-worker/unmet-food text, stable line IDs, unchanged before/after snapshots, modal mouse/touch/wheel blocking, safe close/Esc, report refresh after tick and load, marker picking at three zoom levels, shared player identity panel, no population increase, native touch topics/close, and layout. All scene runners use isolated save/autosave paths. No new persistent fields or migration is required.

An initial test parse error used inferred typing on a dynamic test node; it was corrected. The first input run also left a synthetic wheel press without its release, capturing later GUI clicks; pairing the wheel release made the real viewport mouse sequence pass. Balanced synthesized input is important when extending these tests. The shortage warning is appended to the zero-worker/no-field advice when unmet need exists, rather than depending on an unreachable negative-net branch for staffed fields.

Re-run from this checkout (the rendered interaction run opens and closes a test window):

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --editor --import --quit
& $godotExe --headless --path . --script res://tests/test_prototype.gd
& $godotExe --headless --path . --script res://tests/test_persistence.gd
& $godotExe --headless --path . --script res://tests/test_m1_foundation.gd
& $godotExe --headless --path . --script res://tests/test_workforce.gd
& $godotExe --path . --script res://tests/test_official_interaction.gd -- --render-smoke
```

The headless interaction suite has 71 assertions; rendered mode adds the screenshot check. F6 human acceptance, physical Android touch/safe areas and the visual-review scene's integration remain NOT TESTED. Individual character attributes, authority/spending, relationships, quest effects, configurable player identity and pathfinding are not implemented. Next recommended feature: one local food-guidance quest with explicit outcomes and idempotent saved resolution, after its small contract is defined.

Checkpoint provenance: while this task was running, another operation committed the initial implementation files in `d81456b` (`design fix scala`). That history was preserved. This task's follow-up checkpoint contains final report corrections, UIDs, the complete interaction/regression tests and verification/log documentation. The visual-review scene/art/configuration were not edited by this task.

# M0 audit and M1 foundation — 2026-10-26

The Director's current instruction authorizes prototype fixes and incremental M1 foundations. Earlier documentation-only restrictions describe earlier tasks; this does not ratify the entire PRD or future gameplay proposals. Existing planning edits from another task were left untouched.

## Observed baseline and fixes

- Actual executable reports `4.7.2.stable.official.ed1daf0bf`; project uses Compatibility. Main scene instantiated successfully.
- The original implementation passed 40 runtime assertions, including actual Viewport input dispatch through HUD controls and world input. The previous report that all mechanics fail was NOT reproduced. Do not claim a root cause for that report. Multiple old Godot windows were present; launch this checkout explicitly to avoid testing a stale session.
- Decorative NPC animation originally used unscaled delta, continuing during pause. It now follows simulation speed; verified by regression test. These sprites remain decorative.
- Food could become negative with no fields and insufficient food. Consumption now uses only available stock. This is an inventory invariant, not a new starvation/recovery mechanic. The original starting village cannot reach this fixture without changing its fields.
- Ground and buildings were interleaved in the draw loop, allowing subsequent ground to paint over earlier geometry. All ground now renders before buildings. Final visual occlusion inspection remains manual.

## Implemented boundaries

- `scripts/simulation/building_catalog.gd`: definitions keyed by stable `house`, `rice_field`, `granary` IDs; Indonesian names, wood costs, population and production values. One source for UI and model. No external package or asset dependency.
- `scripts/simulation/settlement_state.gd`: authoritative occupancy, inventory, population and daily economy; no Node/HUD/render dependencies. `try_place` validates ID, bounds, occupancy and funds before committing. `transact` validates every integer stock delta before applying any of them; unknown resources and overdrafts fail without partial mutations.
- `scripts/simulation/simulation_clock.gd`: day/remainder/speed, eight seconds per day at 1x; returns whole daily ticks. Pause preserves fractional progress and accepts explicit placement through the model. Frame partition tested; this is not offline simulation.
- `scripts/main.gd`: existing scene, rendering and HUD retained; delegates rules to model/clock. Middle mouse drag pans, wheel zoom clamps to 0.6–1.8. Input uses inverse camera transform. HUD consumes input first; middle-button release over HUD and focus loss cancel pan.
- `tests/test_prototype.gd`: standalone SceneTree runner with nonzero failure exit and completion guards. No test plugin needed.

Baseline: wood 120, food 60, coins 150, population 8; one house and two fields; house 30 wood/+2 population, field 20 wood/+5 food per day, granary 45 wood/no functional storage bonus; total consumption 3 food and income 2 coins daily. These remain prototype rules, not final balancing.

## Verification actually performed

| Check | Result |
|---|---|
| Original runtime assertions | PASS — 40/40 |
| Final import/editor parser | PASS — exit 0, clean output with normal editor directory access |
| Final model + viewport integration suite | PASS — 75/75, exit 0 |
| Real Compatibility-renderer launch | PASS — Intel Arc A530M OpenGL context, no script/runtime errors in final launch log |
| Baseline GUI grid/HUD visible | PASS — screenshot inspected |
| Full final GUI click-through / editor F5 | NOT TESTED — UI automation detected user input repeatedly; final window activation timed out. Automated viewport tests cover input behavior, not human acceptance |
| Android/touch/export | NOT TESTED |

Initial sandbox runs reported editor/cache write errors. Re-running import and rendered launch with access to the normal Godot directories resolved those errors; they were not GDScript parse failures.

Run from the project folder in PowerShell (replace the executable path if installed elsewhere):

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --version
& $godotExe --headless --path . --editor --import --quit
& $godotExe --headless --path . --script res://tests/test_prototype.gd
```

## F5 acceptance checklist

1. Import this checkout's `project.godot`, open it in Godot 4.7.2, press F5. Expect `Prototype 0.2`, visible 10×10 grid, three starter buildings, readable HUD at 1280×720. Restart any older running demo.
2. Pause. Record day/stocks; wait ten seconds. Neither day, economy nor decorative villagers should advance.
3. While paused, build one Rumah, Sawah, Lumbung on different empty cells. Wood must be 120 → 90 → 70 → 25; population 8 → 10. Each click adds exactly one building and updates HUD immediately.
4. Click an occupied cell; no debit or replacement. Try another Lumbung with 25 wood; expect insufficient-wood message and unchanged state. Click outside the map; no mutation.
5. Click all build/speed buttons and empty panel areas; no unintended placement. Pause again.
6. Drag with middle mouse, release over the HUD, then move normally. Camera stops dragging; no building is created. Scroll over the world to zoom; build a Sawah on an empty visible cell. Correct cell receives it, wood becomes 5. HUD remains fixed.
7. Fresh session: at 1x, one day per eight seconds; at 2x, two days per eight seconds; at 3x, three. Starting village gains 7 food and 2 coins per day. Pause/resume retains partial day progress.
8. Repeat at a resized 16:9 window. Check roofs, selection outline, text readability and correct click coordinates after camera movement. Report any error and its Godot Debugger line.

The automated suite also verifies all four map-corner inverse transforms at three zoom levels, invalid ID/bounds, atomic multi-resource failure, stock type validation, empty-food fixtures, speed validation, frame partition and paused remainder.

## Remaining scope

M1 foundations are implemented, not the entire M1 milestone: save/load/autosave, touch/pinch, worker AI, character interaction, quest, politics, war, dynasty and economy recovery are not implemented. HUD remains in the presentation script; no broad UI rewrite. No push or merge. Human acceptance and final F5 visual checks remain outstanding.

Next recommended implementation: after the F5 checklist, finalize and validate the versioned save contract, then implement safe save/load with round-trip and corruption tests.

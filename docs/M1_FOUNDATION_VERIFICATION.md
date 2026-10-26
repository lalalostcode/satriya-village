# M1 remaining foundations — 2026-10-26

The instruction “lakukan semuanya” was applied to the remaining M1 foundation work discussed immediately before it: touch controls, autosave/recovery, lifecycle behavior and verification. The full kingdom simulation remains later work under the roadmap.

## Implemented behavior and acceptance

| Feature | Contract / acceptance |
|---|---|
| Touch placement | Single finger releases within 12 design pixels of its start to place once. No building on press. Occupied/poor/outside placements still use the shared model transaction. |
| Touch camera | One-finger drag pans; two-finger pinch changes zoom within 0.6–1.8 around the gesture midpoint. Survivors of a pinch cannot become build taps. Camera pan limits remain the existing prototype limits. |
| UI and cancellation | HUD-origin touches, HUD/world crossings, canceled touches and focus loss cannot produce world placement. Godot emulates mouse for UI; emulated mouse is ignored by world input to prevent a second debit. HUD buttons are at least 44×44 design units. |
| Autosave | Dedicated `village-autosave.json` and previous-good backup, separate from manual files. Every 60 unscaled foreground seconds, save only changed state. Paused explicit commands count as changes. No-op periods do not rotate backups. Failures keep data dirty and retry at the next interval. |
| Prior-session protection | Existing autosave or backup disables automatic writes on startup. Explicit load/recovery enables future autosaves and primes baseline/timer. The player can explicitly toggle autosave for a new session. Failed loads preserve this protection and active state. |
| Lifecycle | Focus loss/suspend cancels gestures, attempts one dirty autosave and suspends automatic simulation and intervals. Foreground restores normal ticking without offline catch-up. Chosen speed remains unchanged. |
| Normal close | Flush enabled dirty autosave before quit. A failed save keeps the game open and explains retry/manual save/disable options. Force-kill/crash is not a normal-close guarantee. |

`world_gestures.gd` is a small input interpreter independent of simulation/HUD; `autosave_controller.gd` owns timing/dirty comparison and delegates file integrity to the existing save store. `main.gd` remains the composition/presentation layer. No new package, SDK, service, art asset or gameplay economy rule was introduced. Payload schema and content revision remain unchanged; policy was documented before implementation in [SAVE_FORMAT](SAVE_FORMAT.md).

## Actual verification

Godot `4.7.2.stable.official.ed1daf0bf`; Compatibility renderer on Intel Arc A530M. Editor import/parser passed cleanly (exit 0). Final runs:

- `tests/test_prototype.gd`: 75 passed, 0 failed.
- `tests/test_persistence.gd`: 115 passed, 0 failed.
- `tests/test_m1_foundation.gd -- --render-smoke`: 91 passed, 0 failed (90 behavioral assertions + one rendered capture).
- Total for these final runs: 281 assertions, no failures; every process exited 0.
- Inspected `.godot/m1-tests/m1-ui.png` at 1280×720: map and two-row controls fit, all actions are readable, and status/help remain inside footer.
- Touch tests dispatch actual InputEventScreenTouch/ScreenDrag via Viewport; the HUD test also uses Input.parse_input_event plus Godot's mouse emulation. This is engine-level touch testing on Windows, not a claim of physical multi-touch hardware validation.
- Android SDK ADB exists. The sandbox initially prevented its daemon from starting; normal-access retry succeeded and returned an empty device list. No connected Android device/emulator was available. Export templates were not found in the normal user export_templates directory. No packages/templates were installed and no APK/device result is claimed.
- Human F5 acceptance, actual Android suspend/resume/safe areas, physical disk-full and power loss: NOT TESTED.

The first M1 suite exposed two fixture mistakes (manual slot had been used by an earlier HUD touch; direct flag mutation had not refreshed its button text). Those fixture expectations were corrected. No passing claim is based on that failing run.

All suites now inject isolated autosave paths before scene activation, so focus notifications during rendered tests cannot autosave test state into the player's real slot. Generated fixtures/screenshots remain ignored under `.godot/`.

## Re-run

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --editor --import --quit
& $godotExe --headless --path . --script res://tests/test_prototype.gd
& $godotExe --headless --path . --script res://tests/test_persistence.gd
& $godotExe --headless --path . --script res://tests/test_m1_foundation.gd
# Optional real Compatibility-renderer capture:
& $godotExe --path . --script res://tests/test_m1_foundation.gd -- --render-smoke
```

The headless M1 run has 90 assertions; the rendered run adds the screenshot assertion. Test runners count unfinished test methods as failures and explicitly return nonzero on failure.

## F5 / device acceptance checklist

1. F5 this checkout. Mouse placement/speed/manual save/load must still work; footer uses two rows. Check readability in a resized 16:9 window.
2. On a touch-capable device, tap a free cell: exactly one building/debit on release. Drag one finger then release: pan only. Pinch both directions; release fingers in either order: zoom only. Tap a new cell after pinch: correct transformed cell receives one building.
3. Touch a HUD button, drag from HUD to world, drag from world to HUD, and cancel/background during a gesture. No accidental building; no stuck camera after returning.
4. Pause, place a house, leave the app foreground for 60 seconds: automatic-save status reports success without advancing simulation. Leave unchanged for another interval: no backup churn. Load automatic snapshot and compare day/stocks/buildings.
5. Make a second changed autosave. Restart: slot writes start disabled. Muat Otomatis restores the latest snapshot; Cadangan Otomatis restores the prior good one. Enabling Autosave explicitly permits this session to update the automatic slot. Manual saves remain separate.
6. Make a change, background/suspend, wait, foreground: state should resume with no background production or extra offline time. Close normally after a change, reopen, load automatic snapshot: the close snapshot should be available.
7. For storage-error testing use fixture paths: a failure must preserve the prior valid file and live state, show an error, and wait before retrying. Failure on normal close must keep the game open. No destructive testing on the only real save.

## Remaining boundaries

The M1 engineering feature set is implemented; Director acceptance and physical Android evidence remain open. No rebind menu, gesture-settings UI, offline progress, NPC jobs, quest, character interaction, combat, dynasty or world map has been added. Next implementation after acceptance: the smallest M2 village loop (aggregate worker assignment and observable field production), with a separately reviewed economy contract before changing starter rules.

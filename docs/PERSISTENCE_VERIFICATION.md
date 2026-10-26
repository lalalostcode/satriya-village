# Manual save/load verification — 2026-10-26

Follow-up: separate autosave and touch/lifecycle support were implemented after this manual-slot checkpoint. See [latest M1 results](M1_FOUNDATION_VERIFICATION.md) and the autosave extension in [SAVE_FORMAT](SAVE_FORMAT.md); the limitations below describe the original manual-save task.

Implemented one manual JSON slot and previous-good backup. Full schema, paths, numeric validation and replacement policy are in [SAVE_FORMAT](SAVE_FORMAT.md). Save captures the existing settlement and simulation clock between transactions; load builds a separate validated model before swapping the active session. No offline progress is applied.

## Actual results

Godot binary: `4.7.2.stable.official.ed1daf0bf` from Downloads. Import/parser passed with exit 0 and no script errors. Final checks:

| Check | Actual result |
|---|---|
| Existing gameplay and camera integration | PASS — 75 assertions |
| Persistence, invalid data, injected write/rename failures, actual viewport button input | PASS — 115 assertions |
| Real Compatibility renderer screenshot plus isolated actual user-data write/read | PASS — 3 additional assertions, 118 total in this run |
| Separate process saves, exits, next process reads | PASS — 1 write + 6 read assertions |
| 1280×720 rendered HUD inspected | PASS — all three added buttons fit and restored state appears in HUD |
| Human F5 walkthrough / Android / actual disk-full / power loss | NOT TESTED |

There are 200 assertions across the final gameplay, rendered persistence and two restart runs. The separate earlier 115-assertion run is not counted again. Fault injection simulates storage failures; it does not prove real disk-full or power-loss behavior.

The actual Godot user-data directory resolved to `%APPDATA%/Godot/app_userdata/Satriya Village`. Tests used `.godot/save-tests/` and isolated `user://save-tests/` files; they did not change the player's `user://saves/village.json` slot. Test fixtures and the screenshot are generated artifacts, not tracked assets.

Verified failures include truncated/empty/oversized JSON, invalid types and ranges, unsupported schema/content, unknown building ID, duplicate/invalid cells, candidate/backup write failure, backup promotion failure, primary promotion failure, and the Windows replacement gap where primary disappears. Prior data remains readable from primary or backup. A failed UI load preserves the model object, clock object and displayed resources. Corrupt primary bytes are retained separately before a subsequent save replaces them. Unsupported save versions are protected from overwrite.

## Re-run

From this checkout in PowerShell:

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --editor --import --quit
& $godotExe --headless --path . --script res://tests/test_prototype.gd
& $godotExe --headless --path . --script res://tests/test_persistence.gd
& $godotExe --headless --path . --script res://tests/test_persistence.gd -- --restart-write
& $godotExe --headless --path . --script res://tests/test_persistence.gd -- --restart-read
# Optional rendered/user-directory check (opens and closes a test window):
& $godotExe --path . --script res://tests/test_persistence.gd -- --render-smoke --user-data-smoke
```

Each runner returns a nonzero exit on a counted failure or an unfinished test. Read output for script errors as well. Rendered screenshot: `.godot/save-tests/persistence-ui.png`.

## Manual F5 acceptance

1. Open this checkout in Godot 4.7.2 and press F5. Pause, place one house; expect 90 wood, 10 population, day 1.
2. Click Simpan. Expect `Desa tersimpan.` with no extra building or resource change.
3. Place a granary; expect 45 wood. Click Muat; expect the house-only snapshot, 90 wood, day 1, paused. Camera returns to the initial view.
4. Place the granary again and click Simpan. This creates a backup of the prior house-only snapshot.
5. Close the game, F5 again, click Muat. Expect 45 wood and the granary. Click Cadangan; expect 90 wood and no granary.
6. Resume at 2×, pause partway through a day, save and reload. Day, resources, pause and fractional day progress must be restored. No extra production happens merely from loading.
7. For corruption testing, use copies of test files rather than the only real save. An invalid primary should leave the current village unchanged and offer Cadangan if healthy. A missing backup reports an error without replacing the village.

## Limitations and next step

One manual slot only; no autosave, automatic startup load, cross-version migration, offline progress or multi-instance writer coordination. Flush and backup protect against tested write/replacement failures, not all power-loss scenarios. Android storage/lifecycle remain unverified. M1 is not declared complete.

Next recommended implementation: touch tap/drag/pinch input with placement suppression during camera gestures, retaining viewport and persistence regressions.

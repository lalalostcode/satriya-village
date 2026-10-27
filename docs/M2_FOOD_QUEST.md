# Optional food guidance quest — 2026-10-27

The Director requested continuation after a small saved food-guidance quest was recommended. This task adds one optional tutorial quest, not a branching history scheduler, hunger consequences or a final two-strategy crisis design. Concurrent visual integration and its layout/save extensions must be preserved.

## Contract before implementation

- ID `food_guidance`, title “Menjaga pangan desa”, offered by Laras. Static title/objective/state text/choice IDs and transitions live in a small definition catalog. State belongs to the settlement model, not the dialogue panel or sprites.
- Offered → Ikuti panduan → active. Record the current day as accepted/last observed. On a subsequent real daily economy tick, if assigned farmers produce enough to cover the reported daily consumption and all food needs are met, mark ready and record that harvest day. A loaded stock count or simulated report view alone never satisfies it.
- Ready → Laporkan panen → completed. This is an explicit command, allowed while paused. Offered/active → Tolak panduan → declined. Completed and declined are distinct saved outcomes with distinct Laras responses. No resources, worker policy or time are changed by any choice. These are guidance outcomes, not two fully developed economic crisis strategies.
- Closing, changing topics or ignoring the panel leaves guidance unchanged. No deadline, forced pause, automatic punishment or repeated rewards. All build/camera/clock controls remain available after closing or declining.
- Terminal resolution uses one stable `resolution_id`: empty until terminal, then `food_guidance.completed` or `food_guidance.declined`. Duplicate/stale/invalid choices fail without mutation. No quest reactivation/reset button. Completion requires the recorded successful harvest, revalidated at command time; reload must not repeat a resolution.
- Payload fields: exactly `id`, `state` (offered/active/ready/completed/declined), `accepted_day`, `observed_day`, `harvest_day`, `resolution_id`. Days are integers within 0..saved clock day. Offered has zero days and empty resolution. Active has accepted>=1, observed>=accepted, no harvest/resolution. Ready/completed require accepted<harvest<=observed, with appropriate resolution. Decline has no harvest and a consistent offered-origin or active-origin day history.
- Save integration will extend the latest shared village schema (including visual schema 3), preserving all existing layout/inventory fields. All older supported schemas acquire fresh offered guidance on a staging copy; loading does not rewrite source bytes. Unknown quest IDs, inconsistent history/resolution and future versions are rejected before session swap. Manual, autosave and backups must preserve each stage/outcome.
- Laras gains a Panduan topic and explicit choices in the shared modal panel. Reports/ticks refresh visible text; hidden/stale choice controls cannot bypass model validation. Closing/choice/touch consumes input without placement. Existing visual frontend should inherit the shared session/panel behavior without duplicating quest state.

Acceptance: accept/reject, observe a real harvest, explicit completion, duplicate choice rejection, pause/clock behavior, saved stage/outcome and old-save migration, autosave dirtiness, malformed-history rejection, no source mutation, mouse/touch modal controls, post-decline construction, and shared model regression checks. Record actual results only after running them.

## Exact save extension (before code)

The completed visual integration now supports village schemas 1/2/3. Preserve their strict validation and migration. A pristine offered quest may continue writing the existing v2 legacy or v3 visual snapshot (absence means fresh offered guidance). Once guidance changes, write an envelope with exactly `schema_version: 4`, `content_version: "food-guidance-1"`, `saved_at_utc`, `village` (the unchanged validated v2/v3 village snapshot) and `food_quest` (the six fields above). Never nest a v4 envelope inside village. Validate the nested supported village snapshot first, then quest history against its clock; return both only on full success. Preserve raw validated envelope data for candidate/backup read-back verification. No sidecar files, separate writes or independent quest save: village and quest are one published snapshot. Loading v1/v2/v3 creates offered guidance without rewriting the source file. Existing manual/autosave backup and future-version protection policies apply to v4 as well.

Autosave dirty comparison excludes both outer and nested saved-at metadata, so unchanged paused quest state does not rotate backups just because wall time changes.

## Actual implementation and results

Implemented the catalog, pure quest state machine, per-day observation hook, shared Laras topic/choices, optional v4 envelope and nested-timestamp dirty filtering. The visual integration completed during this task in `41bee26`; the quest uses its shared session and panel without changing visual art/layout/footprint code. The original composition and economy baseline remain intact.

Godot `4.7.2.stable.official.ed1daf0bf` import/parser PASS (exit 0, no script errors). The rendered quest suite used Compatibility/OpenGL on Intel UHD Graphics 770. Inspected offered and completed F5 panels at 1280×720; text and choices fit. Evidence: [offered](screenshots/food_guidance_offered.png), [completed](screenshots/food_guidance_completed.png).

| Final run | Actual result |
|---|---|
| Prototype / persistence / M1 / workforce / official | 75 + 115 + 98 + 111 + 71 PASS |
| Visual HUD / visual smoke / visual gameplay integration (headless) | 4 + 21 + 45 PASS |
| Rendered quest model/save/modal/native touch/F5 flow | 90 PASS |
| Separate-process quest write/read | 1 + 3 PASS |
| Total | 634 PASS, 0 FAIL; every process exit 0 |

The headless quest suite has 88 checks; rendered mode adds two screenshots. Earlier development runs are not counted again. Tests cover accept/decline from offered/active, no same-day or duplicate-day success, failed and successful harvests, real first-day observation during a multi-day frame, explicit completion while paused, distinct terminal IDs, duplicate/stale rejection, all save stages, v1/v2/v3 defaults, v4 visual/layout round-trip, backup stage preservation, malformed history/envelope refusal without replacing the live session, future save protection, paused-choice autosave and nested timestamp stability, native touch, modal completion, post-decline building, and completed-result persistence across a new OS process. No test changed the player's actual manual or automatic slot.

An initial UI fixture clicked the Panduan topic before container layout had run; the resulting wrong target caused cascading failures. Waiting for the panel layout and rejecting hidden-button clicks corrected the fixture. Final mouse/native touch/F5 runs pass. No production reward was removed to make the tests pass; rewards were excluded in the pre-implementation contract.

## Run and manual acceptance

1. F5, Kelola → Laras (or click Laras), then Panduan. Check the objective and both choices.
2. While paused, accept and wait: no harvest progress. Close, keep at least one farmer assigned, run one day, pause. Return to Panduan and Laporkan panen. Completion should change only quest outcome, not stock, workers or time.
3. Save, restart, load, reopen: completed text remains and choices are gone. A new village can instead decline guidance; normal construction/time/report controls still work.
4. In another fresh test session, accept, set zero farmers and run a day: guidance remains active. Restore farmers, run a day, then report. A loaded food stock alone cannot satisfy the objective.
5. Verify manual/automatic backup behavior with copied test saves, not the only real save. Malformed quest history should leave the active village intact. On a physical touch device, repeat choices/close/drag; no accidental placement.

```powershell
$godotExe = Join-Path $env:USERPROFILE 'Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --editor --import --quit
& $godotExe --path . --script res://tests/test_food_guidance.gd -- --render-smoke
& $godotExe --headless --path . --script res://tests/test_food_guidance.gd -- --restart-write
& $godotExe --headless --path . --script res://tests/test_food_guidance.gd -- --restart-read
```

Human F5 acceptance and physical Android remain NOT TESTED. This is one optional local tutorial, not full FR09 economic crisis branching or all M2. No deadline, auto-punishment, resource reward, new recovery mechanic, official spending authority or broad narrative engine. Next recommended implementation: a small wood-gathering activity so the construction loop can recover after finite starting wood is spent, with a separate workforce/yield contract.

Checkpoint provenance: another operation committed initial quest code/tests in `e2e7c1f` (`design fix scala`) during implementation. That commit was preserved; this task's follow-up records final tests, UIDs, evidence and completion documentation rather than rewriting history.

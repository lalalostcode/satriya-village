extends SceneTree
const Autosave = preload("res://scripts/persistence/autosave_controller.gd")
const Store = preload("res://scripts/persistence/save_store.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")

class CountingStore extends "res://scripts/persistence/save_store.gd":
    var attempts: int = 0
    var fail: bool = false
    func save_game(model: RefCounted, clock: RefCounted) -> Dictionary:
        attempts += 1
        if fail:
            return {"ok": false, "error": "write_candidate"}
        return super.save_game(model, clock)

var passed: int = 0
var failed: int = 0
var game: Node2D
var directory: String

func _initialize() -> void:
    call_deferred("_run")

func check(actual: Variant, expected: Variant, label: String) -> void:
    if actual == expected:
        passed += 1
    else:
        failed += 1
        push_error("FAIL %s: expected %s, got %s" % [label, expected, actual])

func _run() -> void:
    directory = "res://.godot/m1-tests/" + str(Time.get_ticks_usec())
    root.size = Vector2i(1280, 720)
    game = load("res://scenes/main.tscn").instantiate()
    game.save_store = Store.new(directory + "/manual.json")
    game.autosave = Autosave.new(directory + "/auto.json")
    root.add_child(game)
    game.set_process(false)
    await process_frame
    await process_frame
    for method: String in ["test_touch", "test_autosave", "test_lifecycle", "test_ui"]:
        if call(method) != true:
            failed += 1
    if await test_native_touch_ui() != true:
        failed += 1
    if OS.get_cmdline_user_args().has("--render-smoke"):
        await process_frame
        await process_frame
        check(root.get_texture().get_image().save_png("res://.godot/m1-tests/m1-ui.png"), OK, "rendered foundation capture")
    print("M1: %d passed, %d failed" % [passed, failed])
    game.free()
    quit(1 if failed else 0)

func touch(index: int, pos: Vector2, down: bool, canceled: bool = false) -> void:
    var event := InputEventScreenTouch.new()
    event.index = index
    event.position = pos
    event.pressed = down
    event.canceled = canceled
    root.push_input(event, true)

func drag(index: int, pos: Vector2) -> void:
    var event := InputEventScreenDrag.new()
    event.index = index
    event.position = pos
    root.push_input(event, true)

func mouse(pos: Vector2, device: int = 0) -> void:
    for down: bool in [true, false]:
        var event := InputEventMouseButton.new()
        event.position = pos
        event.button_index = MOUSE_BUTTON_LEFT
        event.pressed = down
        event.device = device
        root.push_input(event, true)

func screen(cell: Vector2i) -> Vector2:
    return (game._cell_to_screen(cell) - game.CAMERA_CENTER) * game.camera_zoom + game.CAMERA_CENTER + game.camera_offset

func reset_view() -> void:
    game._cancel_gestures()
    game.camera_offset = Vector2.ZERO
    game.camera_zoom = 1.0

func test_touch() -> bool:
    game.clock.speed = 0.0
    game.current_building = "Rumah"
    var pos := screen(Vector2i(1, 1))
    touch(0, pos, true)
    check(game.settlement.buildings.size(), 3, "touch down does not build")
    touch(0, pos, false)
    check(game.settlement.buildings.get(Vector2i(1, 1)), "house", "tap places at release")
    check(game.settlement.stocks.wood, 90, "tap debits once")
    mouse(screen(Vector2i(2, 1)), InputEvent.DEVICE_ID_EMULATION)
    check(game.settlement.stocks.wood, 90, "emulated world mouse ignored")
    touch(0, pos, true)
    touch(0, pos, false)
    check(game.settlement.stocks.wood, 90, "occupied tap no debit")
    pos = screen(Vector2i(2, 2))
    touch(0, pos, true)
    drag(0, pos + Vector2(5, 2))
    touch(0, pos + Vector2(5, 2), false)
    check(game.settlement.buildings.get(Vector2i(2, 2)), "house", "small jitter remains a tap")
    check(game.settlement.stocks.wood, 60, "jitter tap single debit")
    pos = screen(Vector2i(3, 3))
    var count: int = game.settlement.buildings.size()
    touch(0, pos, true)
    drag(0, pos + Vector2(40, 20))
    touch(0, pos + Vector2(40, 20), false)
    check(game.camera_offset, Vector2(40, 20), "single finger pans")
    check(game.settlement.buildings.size(), count, "drag does not build")
    reset_view()
    touch(0, Vector2(550, 350), true)
    touch(1, Vector2(650, 350), true)
    drag(1, Vector2(750, 350))
    check(game.camera_zoom, 1.8, "pinch zoom clamped")
    touch(1, Vector2(750, 350), false)
    drag(0, Vector2(560, 350))
    touch(0, Vector2(560, 350), false)
    check(game.settlement.buildings.size(), count, "pinch survivor cannot tap-build")
    reset_view()
    touch(0, Vector2(550, 350), true)
    touch(1, Vector2(650, 350), true)
    drag(1, Vector2(575, 350))
    check(game.camera_zoom, 0.6, "pinch minimum")
    touch(0, Vector2(550, 350), false)
    touch(1, Vector2(575, 350), false)
    reset_view()
    touch(0, pos, true)
    touch(0, pos, false, true)
    check(game.settlement.buildings.size(), count, "canceled touch never builds")
    # HUD/world crossing, including a second finger that starts on the HUD.
    touch(0, pos, true)
    drag(0, Vector2(50, 600))
    touch(0, Vector2(50, 600), false)
    check(game.gestures.touches.is_empty(), true, "release over HUD clears gesture")
    touch(0, Vector2(50, 600), true)
    drag(0, pos)
    touch(0, pos, false)
    check(game.settlement.buildings.size(), count, "HUD-origin drag never builds")
    touch(0, pos, true)
    touch(1, Vector2(50, 600), true)
    touch(1, Vector2(50, 600), false)
    touch(0, pos, false)
    check(game.settlement.buildings.size(), count, "mixed HUD/world multitouch never builds")
    reset_view()
    game.camera_zoom = 1.3
    game.camera_offset = Vector2(70, 20)
    game.current_building = "Sawah"
    pos = screen(Vector2i(5, 2))
    touch(2, pos, true)
    touch(2, pos, false)
    check(game.settlement.buildings.get(Vector2i(5, 2)), "rice_field", "touch picks after camera transform")
    check(game.settlement.stocks.wood, 40, "transformed touch debit")
    reset_view()
    return true

func test_autosave() -> bool:
    var manual_before: String = FileAccess.get_file_as_string(directory + "/manual.json") if FileAccess.file_exists(directory + "/manual.json") else ""
    var model := Settlement.new()
    var clock := Clock.new()
    clock.speed = 0.0
    var auto := Autosave.new(directory + "/unit-auto.json")
    var store := CountingStore.new(directory + "/unit-auto.json")
    auto.store = store
    auto.prime(model, clock)
    check(auto.enabled, true, "new autosave enabled")
    auto.advance(60.0, model, clock)
    check(store.attempts, 0, "unchanged paused state skips write")
    model.try_place("house", Vector2i.ZERO)
    auto.advance(59.0, model, clock)
    check(store.attempts, 0, "interval throttles dirty snapshot")
    check(auto.advance(1.0, model, clock).ok, true, "paused explicit command autosaved")
    check(store.attempts, 1, "exactly one write per interval")
    check(store.load_game().settlement.stocks.wood, 90, "autosave contains command")
    auto.advance(120.0, model, clock)
    check(store.attempts, 1, "unchanged data does not rotate backup")
    check(FileAccess.file_exists(store.path + ".bak"), false, "no unnecessary backup")
    model.try_place("rice_field", Vector2i(1, 0))
    auto.advance(60.0, model, clock)
    check(store.load_game(true).settlement.stocks.wood, 90, "autosave backup separate")
    check(store.load_game().settlement.stocks.wood, 70, "autosave current")
    var manual_after: String = FileAccess.get_file_as_string(directory + "/manual.json") if FileAccess.file_exists(directory + "/manual.json") else ""
    check(manual_after, manual_before, "autosave never touches manual slot")
    var restarted := Autosave.new(store.path)
    check(restarted.enabled, false, "prior session autosave protected on startup")
    restarted.prime(Settlement.new(), Clock.new())
    restarted.advance(600.0, Settlement.new(), Clock.new())
    check(store.load_game().settlement.stocks.wood, 70, "protected file not overwritten")
    model.try_place("rice_field", Vector2i(2, 0))
    store.fail = true
    check(auto.advance(60.0, model, clock).ok, false, "autosave error returned")
    var attempts: int = store.attempts
    auto.advance(1.0, model, clock)
    check(store.attempts, attempts, "failure does not retry each frame")
    check(store.load_game().settlement.stocks.wood, 70, "failed autosave preserves prior snapshot")
    store.fail = false
    check(auto.advance(59.0, model, clock).ok, true, "dirty state retried after interval")
    check(store.load_game().settlement.stocks.wood, 50, "retry stores latest state")
    auto.enabled = false
    model.try_place("rice_field", Vector2i(3, 0))
    check(auto.flush(model, clock).is_empty(), true, "disabled flush is inert")
    auto.enabled = true
    check(auto.flush(model, clock).ok, true, "lifecycle flush stores dirty state")
    auto.advance(-1.0, model, clock)
    check(auto.elapsed, 0.0, "invalid interval ignored")
    return true

func test_lifecycle() -> bool:
    game.clock.speed = 2.0
    game.clock.elapsed = 3.0
    touch(0, Vector2(650, 350), true)
    game._notification(NOTIFICATION_APPLICATION_PAUSED)
    check(game.gestures.touches.is_empty(), true, "suspend cancels touches")
    check(game.autosave.store.load_game().ok, true, "suspend flushes dirty session")
    var day: int = game.clock.day
    var remainder: float = game.clock.elapsed
    var stocks: Dictionary = game.settlement.stocks.duplicate()
    game._process(120.0)
    check(game.clock.day, day, "background stops calendar")
    check(game.clock.elapsed, remainder, "background stops remainder")
    check(game.settlement.stocks, stocks, "background stops production")
    game._notification(NOTIFICATION_APPLICATION_RESUMED)
    game._process(0.25)
    check(game.clock.elapsed, 3.5, "resume has no catchup")
    check(game.clock.speed, 2.0, "resume keeps chosen speed")
    var previous_auto: RefCounted = game.autosave
    var exit_auto := Autosave.new(directory + "/exit-auto.json")
    var exit_store := CountingStore.new(directory + "/exit-auto.json")
    exit_auto.store = exit_store
    exit_auto.prime(game.settlement, game.clock)
    game.clock.elapsed = 4.0
    game.autosave = exit_auto
    exit_store.fail = true
    check(game._save_before_close(), false, "failed exit autosave keeps game open")
    check(game.status_label.text.contains("tetap terbuka"), true, "exit failure is visible")
    exit_store.fail = false
    check(game._save_before_close(), true, "exit retry succeeds")
    check(exit_store.load_game().clock.elapsed, 4.0, "close snapshot verified")
    game.clock.elapsed = 3.5
    game.autosave = previous_auto
    return true

func button(label: String) -> Button:
    for candidate: Node in game.find_children("*", "Button", true, false):
        if candidate.text == label:
            return candidate
    return null

func test_ui() -> bool:
    for candidate: Node in game.find_children("*", "Button", true, false):
        if not candidate.is_visible_in_tree():
            continue
        var rect: Rect2 = candidate.get_global_rect()
        check(rect.size.y >= 44.0, true, "touch target height " + candidate.text)
        check(rect.position.x >= 0 and rect.end.x <= 1280 and rect.end.y <= 720, true, "HUD fits " + candidate.text)
    var before: int = game.settlement.buildings.size()
    mouse(button("Muat Otomatis").get_global_rect().get_center())
    check(game.settlement.buildings.size(), before, "autosave load button does not build")
    check(game.autosave.enabled, true, "autosave load enables future writes")
    check(game.clock.elapsed, 3.0, "autosave load restores snapshot clock")
    game.autosave.store._write_text(game.autosave.store.path, "broken")
    var model: RefCounted = game.settlement
    game.autosave.enabled = false
    game._update_autosave_controls()
    mouse(button("Muat Otomatis").get_global_rect().get_center())
    check(game.settlement, model, "failed auto-load keeps live model")
    check(game.autosave.enabled, false, "failed auto-load keeps write protection")
    # The backup recovery button restores only after complete validation as well.
    var backup_model := Settlement.new()
    var backup_clock := Clock.new()
    backup_clock.speed = 0.0
    game.autosave.store._write_text(game.autosave.store.path + ".bak", JSON.stringify(game.autosave.store.capture(backup_model, backup_clock)))
    check(game.status_label.text.contains("Cadangan Otomatis"), false, "earlier missing backup is not falsely offered")
    mouse(button("Cadangan Otomatis").get_global_rect().get_center())
    check(game.settlement.stocks.wood, 120, "autosave backup button recovers inventory")
    check(game.autosave.enabled, true, "backup recovery enables future autosave")
    check(game.autosave.elapsed, 0.0, "recovery restarts interval")
    mouse(button("Autosave: Aktif").get_global_rect().get_center())
    check(game.autosave.enabled, false, "explicit protection restored")
    mouse(button("Autosave: Mati").get_global_rect().get_center())
    check(game.autosave.enabled, true, "explicit toggle enables new session")
    mouse(button("Autosave: Aktif").get_global_rect().get_center())
    check(game.autosave.enabled, false, "explicit toggle disables")
    return true

func test_native_touch_ui() -> bool:
    var target: Vector2 = button("Pause").get_global_rect().get_center()
    for down: bool in [true, false]:
        var event := InputEventScreenTouch.new()
        event.position = target
        event.index = 0
        event.pressed = down
        Input.parse_input_event(event)
        Input.flush_buffered_events()
        await process_frame
    check(game.clock.speed, 0.0, "native touch mouse emulation operates HUD")
    check(game.blocked_touches.is_empty(), true, "HUD touch releases cleanly")
    return true

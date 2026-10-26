extends SceneTree
const Store = preload("res://scripts/persistence/save_store.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")

class FailingStore extends "res://scripts/persistence/save_store.gd":
    var failure: String = ""
    func _write_text(destination: String, text: String) -> Error:
        if (failure == "candidate" and destination.ends_with(".json.tmp")) or (failure == "backup" and destination.ends_with(".bak.tmp")):
            return ERR_FILE_CANT_WRITE
        return super._write_text(destination, text)
    func _rename(source: String, destination: String) -> Error:
        if failure == "backup_rename" and destination.ends_with(".bak"):
            return ERR_FILE_CANT_WRITE
        if failure in ["primary_rename", "interrupted_replace"] and destination.ends_with(".json"):
            if failure == "interrupted_replace":
                DirAccess.remove_absolute(destination) # Test-owned fixture only: Windows replacement gap.
            return ERR_FILE_CANT_WRITE
        return super._rename(source, destination)

var passed: int = 0
var failed: int = 0
var directory: String
var game: Node2D

func _initialize() -> void:
    call_deferred("_run")

func check(actual: Variant, expected: Variant, label: String) -> void:
    if actual == expected:
        passed += 1
    else:
        failed += 1
        push_error("FAIL %s: expected %s, got %s" % [label, expected, actual])

func _run() -> void:
    directory = "res://.godot/save-tests/" + str(Time.get_ticks_usec())
    DirAccess.make_dir_recursive_absolute(directory)
    if OS.get_cmdline_user_args().has("--restart-write") or OS.get_cmdline_user_args().has("--restart-read"):
        if restart_fixture() != true:
            failed += 1
    else:
        for method: String in ["test_round_trip", "test_validation", "test_failures"]:
            if call(method) != true:
                failed += 1
        if await test_ui() != true:
            failed += 1
        if OS.get_cmdline_user_args().has("--user-data-smoke"):
            if test_user_data() != true:
                failed += 1
    print("Persistence: %d passed, %d failed" % [passed, failed])
    quit(1 if failed else 0)

func test_round_trip() -> bool:
    var store := Store.new(directory + "/roundtrip.json")
    var model := Settlement.new()
    var clock := Clock.new()
    clock.advance(3.125)
    clock.set_speed(0.0)
    model.try_place("granary", Vector2i.ZERO)
    check(store.load_game().error, "missing", "missing file")
    check(store.save_game(model, clock).ok, true, "first save")
    var restored: Dictionary = store.load_game()
    check(restored.ok, true, "read validated file")
    check(restored.settlement.buildings, model.buildings, "occupancy roundtrip")
    check(restored.settlement.stocks, model.stocks, "inventory roundtrip")
    check(restored.settlement.population, model.population, "population roundtrip")
    check(restored.clock.elapsed, 3.125, "fractional progress preserved")
    check(restored.clock.speed, 0.0, "pause preserved")
    check(restored.clock.day, clock.day, "day preserved")
    model.try_place("house", Vector2i(1, 0))
    check(store.save_game(model, clock).ok, true, "second save")
    check(store.load_game().settlement.stocks.wood, 45, "new primary")
    check(store.load_game(true).settlement.stocks.wood, 75, "previous good backup")
    store._write_text(store.path, "{broken")
    check(store.load_game().error, "json", "corruption reported without fallback")
    check(store.load_game(true).ok, true, "explicit recovery works")
    check(store.save_game(model, clock).ok, true, "save after corruption")
    check(store.load_game(true).settlement.stocks.wood, 75, "corruption did not replace healthy backup")
    var rejected_count: int = 0
    for name: String in DirAccess.get_files_at(directory):
        if name.begins_with("roundtrip.json.rejected-"):
            rejected_count += 1
            check(FileAccess.get_file_as_string(directory + "/" + name), "{broken", "corrupt bytes retained")
    check(rejected_count, 1, "one rejected file archived")
    restored.settlement.stocks.wood = 0
    check(model.stocks.wood, 45, "loaded state does not alias active model")
    for speed: float in [0.0, 1.0, 2.0, 3.0]:
        clock.set_speed(speed)
        var data := store.capture(model, clock)
        check(store.validate(JSON.parse_string(JSON.stringify(data))).clock.speed, speed, "speed roundtrip")
    return true

func test_validation() -> bool:
    var store := Store.new(directory + "/validation.json")
    var base := store.capture(Settlement.new(), Clock.new())
    var cases: Array = []
    for value: Variant in [null, [], "data", 42, true]:
        cases.append(value)
    for value: Variant in [2, 0, 1.5, true, "1"]:
        var data := base.duplicate(true)
        data.schema_version = value
        cases.append(data)
    for value: Variant in [-1, 0.5, true, "12", INF, NAN, 1000000001]:
        var data := base.duplicate(true)
        data.settlement.stocks.wood = value
        cases.append(data)
    for value: Variant in [-0.1, 8.0, INF, "0", true]:
        var data := base.duplicate(true)
        data.clock.elapsed = value
        cases.append(data)
    for value: Variant in [-1, 4, 1.5, true]:
        var data := base.duplicate(true)
        data.clock.speed = value
        cases.append(data)
    for field: String in ["clock", "settlement", "saved_at_utc"]:
        var data := base.duplicate(true)
        data.erase(field)
        cases.append(data)
    for change: Dictionary in [{"id": "unknown"}, {"x": 10}, {"y": -1}, {"x": 0.5}, {"y": true}]:
        var data := base.duplicate(true)
        data.settlement.buildings[0].merge(change, true)
        cases.append(data)
    var duplicate := base.duplicate(true)
    duplicate.settlement.buildings.append(duplicate.settlement.buildings[0].duplicate())
    cases.append(duplicate)
    var unknown := base.duplicate(true)
    unknown.content_version = "future"
    cases.append(unknown)
    var extra := base.duplicate(true)
    extra.script = "res://anything.gd"
    cases.append(extra)
    for data: Variant in cases:
        check(store.validate(data).ok, false, "invalid snapshot rejected")
    store._write_text(store.path, " ".repeat(Store.MAX_BYTES + 1))
    check(store.load_game().error, "too_large", "file size guard")
    for text: String in ["", "{", "null", "[]"]:
        store._write_text(store.path, text)
        check(store.load_game().ok, false, "empty/truncated/wrong root rejected")
    var future := base.duplicate(true)
    future.schema_version = 2
    var future_text := JSON.stringify(future)
    store._write_text(store.path, future_text)
    check(store.save_game(Settlement.new(), Clock.new()).error, "protected_save", "newer primary protected")
    check(FileAccess.get_file_as_string(store.path), future_text, "newer primary bytes retained")
    store._write_text(store.path, JSON.stringify(base))
    store._write_text(store.path + ".bak", future_text)
    check(store.save_game(Settlement.new(), Clock.new()).error, "protected_save", "newer backup protected")
    return true

func test_failures() -> bool:
    for fault: String in ["candidate", "backup", "backup_rename", "primary_rename", "interrupted_replace"]:
        var store := FailingStore.new(directory + "/" + fault + ".json")
        var model := Settlement.new()
        var clock := Clock.new()
        check(store.save_game(model, clock).ok, true, "create prior save for " + fault)
        model.try_place("house", Vector2i.ZERO)
        store.failure = fault
        check(store.save_game(model, clock).ok, false, "report failure " + fault)
        var previous := store.load_game(true) if fault == "interrupted_replace" else store.load_game()
        check(previous.ok, true, "prior snapshot survives " + fault)
        check(previous.settlement.stocks.wood, 120, "prior data survives " + fault)
        check(model.stocks.wood, 90, "live state untouched by save failure")
        store.failure = ""
        check(store.save_game(model, clock).ok, true, "retry succeeds " + fault)
    return true

func click_button(label: String) -> void:
    for button: Node in game.find_children("*", "Button", true, false):
        if button.text != label:
            continue
        check(button.get_global_rect().end.x <= 1280, true, "button fits viewport " + label)
        for pressed: bool in [true, false]:
            var event := InputEventMouseButton.new()
            event.position = button.get_global_rect().get_center()
            event.button_index = MOUSE_BUTTON_LEFT
            event.pressed = pressed
            root.push_input(event, true)
        return
    check(false, true, "missing button " + label)

func test_ui() -> bool:
    root.size = Vector2i(1280, 720)
    game = load("res://scenes/main.tscn").instantiate()
    game.save_store = Store.new(directory + "/ui.json")
    root.add_child(game)
    game.set_process(false)
    game.clock.set_speed(0.0)
    await process_frame
    await process_frame
    game.settlement.try_place("house", Vector2i.ZERO)
    click_button("Simpan")
    check(game.status_label.text, "Desa tersimpan.", "save button reports success")
    check(game.settlement.buildings.size(), 4, "save click never builds")
    game.settlement.try_place("granary", Vector2i(1, 0))
    click_button("Simpan")
    game.settlement.try_place("rice_field", Vector2i(2, 0))
    click_button("Muat")
    check(game.settlement.buildings.size(), 5, "load swaps model")
    check(game.settlement.stocks.wood, 45, "load restores inventory")
    check(game.resource_label.text.contains("Kayu: 45"), true, "load refreshes HUD")
    check(game.clock.speed, 0.0, "load restores paused speed")
    game.save_store._write_text(game.save_store.path, "broken")
    var old_model: RefCounted = game.settlement
    var old_clock: RefCounted = game.clock
    var old_hud: String = game.resource_label.text
    click_button("Muat")
    check(game.settlement, old_model, "failed load retains model identity")
    check(game.clock, old_clock, "failed load retains clock identity")
    check(game.resource_label.text, old_hud, "failed load preserves HUD")
    check(game.status_label.text.contains("Cadangan"), true, "offers explicit recovery")
    click_button("Cadangan")
    check(game.settlement.stocks.wood, 90, "backup button restores prior snapshot")
    check(game.settlement.buildings.size(), 4, "backup button never places")
    if OS.get_cmdline_user_args().has("--render-smoke"):
        await process_frame
        await process_frame
        var screenshot := root.get_texture().get_image()
        check(screenshot.save_png("res://.godot/save-tests/persistence-ui.png"), OK, "rendered UI capture")
    game.free()
    return true

func test_user_data() -> bool:
    var store := Store.new("user://save-tests/" + str(Time.get_ticks_usec()) + ".json")
    check(store.save_game(Settlement.new(), Clock.new()).ok, true, "actual user data write")
    check(store.load_game().ok, true, "actual user data load")
    print("User data: " + OS.get_user_data_dir())
    return true

func restart_fixture() -> bool:
    var store := Store.new("res://.godot/save-tests/restart.json")
    if OS.get_cmdline_user_args().has("--restart-write"):
        var model := Settlement.new()
        var clock := Clock.new()
        model.try_place("granary", Vector2i(9, 9))
        clock.day = 12
        clock.elapsed = 6.25
        clock.speed = 0.0
        check(store.save_game(model, clock).ok, true, "save in first process")
    else:
        var result := store.load_game()
        check(result.ok, true, "read in new process")
        check(result.settlement.buildings.get(Vector2i(9, 9)), "granary", "building survives restart")
        check(result.settlement.stocks.wood, 75, "stocks survive restart")
        check(result.clock.day, 12, "day survives restart")
        check(result.clock.elapsed, 6.25, "remainder survives restart")
        check(result.clock.speed, 0.0, "pause survives restart")
    return true

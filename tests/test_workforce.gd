extends SceneTree
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
const Store = preload("res://scripts/persistence/save_store.gd")
const Autosave = preload("res://scripts/persistence/autosave_controller.gd")
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
    directory = "res://.godot/workforce-tests/" + str(Time.get_ticks_usec())
    for method: String in ["test_allocation", "test_production", "test_migration_and_persistence"]:
        if call(method) != true:
            failed += 1
    if await test_ui() != true:
        failed += 1
    print("Workforce: %d passed, %d failed" % [passed, failed])
    quit(1 if failed else 0)

func test_allocation() -> bool:
    var model := Settlement.new()
    var workers := model.workforce()
    check(workers.assigned, 2, "two starter farmers")
    check(workers.idle, 6, "remaining population idle")
    check(workers.slots, 2, "only fields offer work")
    check(workers.production, 10, "starter production retained")
    check(model.set_farm_worker_target(1), true, "manual limit accepted")
    check(model.workforce().assigned, 1, "manual limit applied")
    check(model.workforce().allocations[Vector2i(3, 4)], 1, "earlier row field staffed")
    check(model.workforce().allocations[Vector2i(4, 5)], 0, "later row field idle")
    check(model.set_farm_worker_target(-2), false, "negative invalid limit rejected")
    check(model.set_farm_worker_target(9), false, "limit exceeding workforce rejected")
    check(model.farm_worker_target, 1, "invalid commands preserve policy")
    model.try_place("rice_field", Vector2i(0, 0))
    check(model.workforce().assigned, 1, "new field respects manual cap")
    check(model.workforce().allocations[Vector2i.ZERO], 1, "new earlier field gets deterministic allocation")
    check(model.workforce().production, 5, "only staffed field produces")
    model.set_farm_worker_target(-1)
    check(model.workforce().assigned, 3, "automatic fills new field")
    model.population = 1
    check(model.workforce().assigned, 1, "scarce workers cannot fill all slots")
    check(model.workforce().idle, 0, "no negative idle workforce")
    var reversed := Settlement.new()
    reversed.population = 1
    reversed.buildings.clear()
    var cells: Array = model.buildings.keys()
    cells.reverse()
    for cell: Vector2i in cells:
        reversed.buildings[cell] = model.buildings[cell]
    check(reversed.workforce().allocations, model.workforce().allocations, "allocation independent of insertion order")
    model.population = 0
    check(model.workforce().assigned, 0, "no workers means no assignment")
    check(model.workforce().production, 0, "no free production")
    model.population = 8
    model.buildings.clear()
    check(model.workforce().assigned, 0, "no fields means no assignment")
    check(model.workforce().idle, 8, "all idle without fields")
    return true

func test_production() -> bool:
    for target: int in [-1, 1, 0]:
        var model := Settlement.new()
        model.set_farm_worker_target(target)
        var before: int = model.stocks.food
        model.advance_day()
        var expected_produced: int = 10 if target == -1 else target * 5
        check(model.stocks.food, before + expected_produced - 3, "food ledger target " + str(target))
        check(model.stocks.coins, 152, "income applied once")
        check(model.last_day_report.produced, expected_produced, "reported production is real production")
        check(model.last_day_report.net, model.stocks.food - before, "report reconciles inventory")
        check(model.last_day_report.consumed, 3, "starter consumption retained")
    var depleted := Settlement.new()
    depleted.set_farm_worker_target(0)
    depleted.stocks.food = 1
    depleted.advance_day()
    check(depleted.stocks.food, 0, "food cannot be negative")
    check(depleted.last_day_report.consumed, 1, "consume only available food")
    check(depleted.last_day_report.unmet, 2, "unmet need reported")
    depleted.advance_day()
    check(depleted.last_day_report.unmet, 3, "unmet need at zero food")
    depleted.set_farm_worker_target(-1)
    depleted.advance_day()
    check(depleted.stocks.food, 7, "staffed production can feed same day")
    check(depleted.last_day_report.unmet, 0, "production resolves current need")
    # Equivalent simulated duration produces the same data at every speed.
    for speed: float in [1.0, 2.0, 3.0]:
        var model := Settlement.new()
        model.set_farm_worker_target(1)
        var clock := Clock.new()
        clock.set_speed(speed)
        for i: int in clock.advance(48.0 / speed):
            model.advance_day()
        check(model.stocks.food, 72, "six daily ticks at speed " + str(speed))
        check(model.stocks.coins, 162, "income independent of speed")
    return true

func legacy_snapshot(store: RefCounted) -> Dictionary:
    var data: Dictionary = store.capture(Settlement.new(), Clock.new())
    data.schema_version = 1
    data.content_version = "prototype-1"
    data.settlement.erase("farm_worker_target")
    return data

func test_migration_and_persistence() -> bool:
    var store := Store.new(directory + "/manual.json")
    var model := Settlement.new()
    var clock := Clock.new()
    clock.speed = 0.0
    model.set_farm_worker_target(1)
    check(store.save_game(model, clock).ok, true, "save manual farm policy")
    check(store.load_game().settlement.farm_worker_target, 1, "manual policy roundtrip")
    check(store.load_game().settlement.workforce().production, 5, "production restored from policy")
    check(store.load_game().settlement.last_day_report.is_empty(), true, "transient report not persisted")
    var data := store.capture(model, clock)
    for invalid: Variant in [-2, 9, 0.5, true, "1", null]:
        var bad := data.duplicate(true)
        bad.settlement.farm_worker_target = invalid
        check(store.validate(bad).ok, false, "invalid saved target rejected")
    var missing := data.duplicate(true)
    missing.settlement.erase("farm_worker_target")
    check(store.validate(missing).ok, false, "v2 requires farm policy")
    var old := legacy_snapshot(store)
    var original := old.duplicate(true)
    var migrated := store.validate(old)
    check(migrated.ok, true, "v1 accepted")
    check(migrated.data.schema_version, 2, "v1 migrates to v2")
    check(migrated.data.content_version, "prototype-2", "content revision migrated")
    check(migrated.settlement.farm_worker_target, -1, "old saves use automatic farming")
    check(migrated.settlement.stocks, original.settlement.stocks, "legacy stocks preserved")
    check(migrated.settlement.workforce().production, 10, "old starter output preserved")
    check(old, original, "migration does not mutate input")
    var text := JSON.stringify(old)
    store._write_text(store.path, text)
    check(store.load_game().ok, true, "legacy file loads")
    check(FileAccess.get_file_as_string(store.path), text, "load does not rewrite legacy bytes")
    check(store.save_game(model, clock).ok, true, "save after legacy load publishes v2")
    check(store.load_game(true).settlement.farm_worker_target, -1, "legacy backup retains auto policy")
    old.settlement.farm_worker_target = 0
    check(store.validate(old).ok, false, "extra legacy fields not silently dropped")
    var broken := original.duplicate(true)
    broken.settlement.stocks.food = -1
    check(store.validate(broken).ok, false, "legacy payload fully validated after migration")
    var auto := Autosave.new(directory + "/auto.json")
    auto.prime(model, clock)
    model.set_farm_worker_target(0)
    check(auto.advance(60.0, model, clock).ok, true, "paused policy alone makes autosave dirty")
    check(auto.store.load_game().settlement.farm_worker_target, 0, "autosave policy roundtrip")
    check(clock.day, 1, "saving policy never advances calendar")
    return true

func find_button(label: String) -> Button:
    for button: Node in game.find_children("*", "Button", true, false):
        if button.text == label:
            return button
    return null

func click(label: String) -> void:
    var button := find_button(label)
    if button == null:
        check(false, true, "missing button " + label)
        return
    for down: bool in [true, false]:
        var event := InputEventMouseButton.new()
        event.button_index = MOUSE_BUTTON_LEFT
        event.position = button.get_global_rect().get_center()
        event.pressed = down
        root.push_input(event, true)

func test_ui() -> bool:
    root.size = Vector2i(1280, 720)
    game = load("res://scenes/main.tscn").instantiate()
    game.save_store = Store.new(directory + "/ui-manual.json")
    game.autosave = Autosave.new(directory + "/ui-auto.json")
    root.add_child(game)
    game.set_process(false)
    await process_frame
    await process_frame
    game.app_active = true
    game._set_speed(0.0)
    check(game.help_label.text.contains("Petani 2/2"), true, "initial worker HUD")
    check(game.help_label.text.contains("+10 -3 = +7/hari"), true, "initial production projection")
    var count: int = game.settlement.buildings.size()
    click("Petani -")
    check(game.settlement.farm_worker_target, 1, "minus button sets cap")
    check(game.help_label.text.contains("+5 -3 = +2/hari"), true, "policy refreshes HUD")
    check(game.clock.day, 1, "paused policy no calendar change")
    check(game.settlement.stocks.food, 60, "paused policy no production")
    check(game.settlement.buildings.size(), count, "worker HUD never places building")
    game._set_speed(1.0)
    game._process(8.0)
    check(game.settlement.stocks.food, 62, "one-worker real daily production")
    check(game.status_label.text.contains("panen +5, konsumsi 3"), true, "daily result visible")
    game._set_speed(0.0)
    click("Petani -")
    check(find_button("Petani -").disabled, true, "cannot reduce below zero")
    game._set_speed(1.0)
    game._process(8.0)
    check(game.settlement.stocks.food, 59, "zero-worker daily consumption")
    game._set_speed(0.0)
    click("Otomatis")
    check(game.settlement.workforce().assigned, 2, "automatic restores workers")
    check(find_button("Petani +").disabled, true, "cannot exceed available slots")
    click("Petani -")
    click("Simpan")
    click("Otomatis")
    click("Muat")
    check(game.settlement.farm_worker_target, 1, "load restores UI policy")
    check(game.help_label.text.contains("+2/hari"), true, "load restores production forecast")
    var native_target: Vector2 = find_button("Petani +").get_global_rect().get_center()
    for down: bool in [true, false]:
        var event := InputEventScreenTouch.new()
        event.position = native_target
        event.pressed = down
        Input.parse_input_event(event)
        Input.flush_buffered_events()
        await process_frame
    check(game.settlement.workforce().assigned, 2, "touch operates worker control")
    check(game.settlement.buildings.size(), count, "touch worker control never builds")
    for button: Node in game.find_children("*", "Button", true, false):
        var rect: Rect2 = button.get_global_rect()
        check(rect.end.x <= 1280 and rect.end.y <= 720 and rect.size.y >= 44.0, true, "touch HUD fits " + button.text)
    check(game.help_label.get_global_rect().end.x <= 1280, true, "worker forecast fits")
    if OS.get_cmdline_user_args().has("--render-smoke"):
        click("Petani -")
        await process_frame
        await process_frame
        check(root.get_texture().get_image().save_png("res://.godot/workforce-tests/workforce-ui.png"), OK, "workforce render capture")
    game.free()
    return true

extends SceneTree

var passed: int = 0
var failed: int = 0
var game: Node2D

func _initialize() -> void:
    call_deferred("_run")

func check(actual: Variant, expected: Variant, label: String) -> void:
    if actual == expected:
        passed += 1
    else:
        failed += 1
        push_error("FAIL %s: expected %s, got %s" % [label, expected, actual])

func click_at(pos: Vector2) -> void:
    var motion := InputEventMouseMotion.new()
    motion.position = pos
    root.push_input(motion, true)
    for down: bool in [true, false]:
        var event := InputEventMouseButton.new()
        event.position = pos
        event.button_index = MOUSE_BUTTON_LEFT
        event.pressed = down
        root.push_input(event, true)

func _run() -> void:
    root.size = Vector2i(1280, 720)
    game = load("res://scenes/main.tscn").instantiate()
    root.add_child(game)
    game.set_process(false)
    await process_frame
    await process_frame
    if await exercise() != true:
        failed += 1
    if test_model() != true:
        failed += 1
    if test_camera() != true:
        failed += 1
    print("Prototype: %d passed, %d failed" % [passed, failed])
    game.queue_free()
    quit(1 if failed else 0)

func exercise() -> bool:
    # Inject events through the viewport, including GUI consumption, not signals alone.
    for button: Node in game.find_children("*", "Button", true, false):
        if button.is_in_group("persistence_controls"):
            continue # File I/O and these buttons are covered by test_persistence.gd.
        var before: int = game.settlement.buildings.size()
        click_at(button.get_global_rect().get_center())
        check(game.settlement.buildings.size(), before, "HUD never places: " + button.text)
        if button.text.begins_with("Rumah") or button.text.begins_with("Sawah") or button.text.begins_with("Lumbung"):
            check(game.current_building, button.text.get_slice(" ", 0), "button selection")
        else:
            var expected := 0.0 if button.text == "Pause" else float(button.text.left(1))
            check(game.clock.speed, expected, "speed button")
    game._set_speed(0.0)
    var old_day: int = game.clock.day
    var old_animation: float = game.animation_time
    game._process(20.0)
    check(game.clock.day, old_day, "pause freezes calendar")
    check(game.animation_time, old_animation, "pause freezes decorative villagers")
    for i: int in 3:
        var kind: String = ["Rumah", "Sawah", "Lumbung"][i]
        game._select_building(kind)
        var before_wood: int = game.settlement.stocks.wood
        var before_count: int = game.settlement.buildings.size()
        var cell := Vector2i(i, 0)
        click_at(game._cell_to_screen(cell))
        check(game.settlement.buildings.get(cell), game.Catalog.id_for_name(kind), "placement " + kind)
        check(game.settlement.stocks.wood, before_wood - game.Catalog.DEFINITIONS[game.Catalog.id_for_name(kind)].wood, "single debit")
        check(game.settlement.buildings.size(), before_count + 1, "single building")
        click_at(game._cell_to_screen(cell))
        check(game.settlement.stocks.wood, before_wood - game.Catalog.DEFINITIONS[game.Catalog.id_for_name(kind)].wood, "occupied no debit")
        check(game.clock.day, old_day, "paused commands do not advance day")
    var before_count: int = game.settlement.buildings.size()
    click_at(game._cell_to_screen(Vector2i(3, 0)))
    check(game.settlement.buildings.size(), before_count, "insufficient resources")
    check(game.settlement.stocks.wood, 25, "failed placement preserves resources")
    click_at(Vector2(10, 300))
    check(game.settlement.buildings.size(), before_count, "outside map")
    check(game.resource_label.text.contains("Kayu: 25"), true, "HUD reflects debit")
    for multiplier: float in [1.0, 2.0, 3.0]:
        game.clock.elapsed = 0.0
        game._set_speed(multiplier)
        var before_day: int = game.clock.day
        var before_food: int = game.settlement.stocks.food
        game._process(8.0)
        check(game.clock.day, before_day + int(multiplier), "speed calendar")
        check(game.settlement.stocks.food, before_food + 12 * int(multiplier), "production baseline")
    return true

func test_model() -> bool:
    var model = game.Settlement.new()
    var initial: Dictionary = model.stocks.duplicate()
    check(model.transact({"coins": 5, "wood": -121}), false, "atomic failure")
    check(model.stocks, initial, "no partial credit")
    check(model.transact({"unknown": 5}), false, "unknown resource")
    check(model.transact({"wood": 1.5}), false, "fractional resource rejected")
    check(model.try_place("missing", Vector2i.ZERO), "unknown_building", "unknown definition")
    check(model.try_place("house", Vector2i(-1, 0)), "outside_map", "negative coordinate")
    check(model.try_place("house", Vector2i(10, 0)), "outside_map", "boundary coordinate")
    check(model.stocks, initial, "rejected commands preserve inventory")
    model.buildings.clear()
    model.stocks.food = 1
    model.advance_day()
    check(model.stocks.food, 0, "food cannot go negative")
    model.advance_day()
    check(model.stocks.food, 0, "zero food remains zero")
    var a = game.Clock.new()
    var b = game.Clock.new()
    a.advance(24.0)
    for i: int in 96:
        b.advance(0.25)
    check(a.day, b.day, "frame partition invariant")
    check(a.elapsed, b.elapsed, "remainder invariant")
    b.advance(2.0)
    b.set_speed(0.0)
    b.advance(100.0)
    check(b.elapsed, 2.0, "pause preserves fractional progress")
    b.set_speed(3.0)
    check(b.advance(2.0), 1, "resume uses remainder")
    b.set_speed(-1.0)
    check(b.speed, 3.0, "invalid speed ignored")
    check(b.advance(-1.0), 0, "negative delta ignored")
    return true

func test_camera() -> bool:
    game._set_speed(0.0)
    var before: int = game.settlement.buildings.size()
    var down := InputEventMouseButton.new()
    down.position = Vector2(640, 320)
    down.button_index = MOUSE_BUTTON_MIDDLE
    down.pressed = true
    root.push_input(down, true)
    var drag := InputEventMouseMotion.new()
    drag.position = Vector2(720, 340)
    drag.relative = Vector2(80, 20)
    root.push_input(drag, true)
    check(game.camera_offset, Vector2(80, 20), "middle mouse pan")
    down.pressed = false
    down.position = Vector2(50, 600)
    root.push_input(down, true)
    check(game.panning, false, "release on HUD ends pan")
    var wheel := InputEventMouseButton.new()
    wheel.position = Vector2(640, 320)
    wheel.button_index = MOUSE_BUTTON_WHEEL_UP
    wheel.pressed = true
    root.push_input(wheel, true)
    check(is_equal_approx(game.camera_zoom, 1.1), true, "wheel zoom")
    check(game.settlement.buildings.size(), before, "camera never builds")
    for zoom: float in [0.6, 1.0, 1.8]:
        game.camera_zoom = zoom
        for cell: Vector2i in [Vector2i.ZERO, Vector2i(9, 0), Vector2i(0, 9), Vector2i(9, 9)]:
            var screen: Vector2 = (game._cell_to_screen(cell) - game.CAMERA_CENTER) * zoom + game.CAMERA_CENTER + game.camera_offset
            check(game._screen_to_cell(screen), cell, "camera inverse at map corners")
    game.camera_zoom = 1.1
    game._select_building("Sawah")
    var cell := Vector2i(2, 2)
    var screen: Vector2 = (game._cell_to_screen(cell) - game.CAMERA_CENTER) * game.camera_zoom + game.CAMERA_CENTER + game.camera_offset
    click_at(screen)
    check(game.settlement.buildings.get(cell), "rice_field", "placement after pan and zoom")
    check(game.settlement.stocks.wood, 5, "transformed placement debits once")
    return true

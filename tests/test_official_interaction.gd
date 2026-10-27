extends SceneTree
const Interactions = preload("res://scripts/characters/village_interactions.gd")
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
    directory = "res://.godot/official-tests/" + str(Time.get_ticks_usec())
    if test_reports() != true:
        failed += 1
    if await test_ui() != true:
        failed += 1
    print("Official: %d passed, %d failed" % [passed, failed])
    quit(1 if failed else 0)

func snapshot(model: RefCounted, clock: RefCounted) -> Dictionary:
    var data := Store.new().capture(model, clock)
    data.erase("saved_at_utc")
    return data

func test_reports() -> bool:
    var service := Interactions.new()
    var model := Settlement.new()
    var clock := Clock.new()
    clock.elapsed = 3.25
    var before := snapshot(model, clock)
    for action: String in ["food_report", "workforce_report", "food_report"]:
        var result := service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, action, model, clock)
        check(result.ok, true, "official action " + action)
        check(result.name, "Laras", "named speaker")
        check(result.text.contains("Kepala desa"), true, "addresses chief")
        check(snapshot(model, clock), before, "reports never mutate state")
    var result := service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "food_report", model, clock)
    check(result.text.contains("Persediaan pangan: 60"), true, "stock value")
    check(result.text.contains("panen 10"), true, "production value")
    check(result.text.contains("bersih: +7"), true, "net food value")
    model.set_farm_worker_target(1)
    result = service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "workforce_report", model, clock)
    check(result.text.contains("Batas 1 petani"), true, "manual policy reported")
    check(result.text.contains("belum bekerja: 7"), true, "idle count reported")
    result = service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "food_report", model, clock)
    check(result.text.contains("Sebagian tempat sawah belum terisi"), true, "unstaffed advice")
    model.set_farm_worker_target(0)
    model.stocks.food = 0
    result = service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "food_report", model, clock)
    check(result.text.contains("panen 0"), true, "no worker no production")
    check(result.text.contains("kebutuhan belum terpenuhi 3"), true, "unmet need reported")
    check(result.text.contains("Belum ada petani"), true, "no worker advice")
    check(result.text.contains("Kebutuhan pangan belum terpenuhi"), true, "shortage advice")
    model.buildings.clear()
    result = service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "food_report", model, clock)
    check(result.text.contains("Belum ada sawah"), true, "no field advice")
    result = service.report(Interactions.PLAYER_ID, Interactions.PLAYER_ID, "identity", model, clock)
    check(result.name, "Kepala desa (Anda)", "player identity")
    check(result.line_id, "chief.identity", "stable line id")
    check(service.report("unknown", Interactions.OFFICIAL_ID, "food_report", model, clock).error, "invalid_actor", "invalid actor")
    check(service.report(Interactions.OFFICIAL_ID, Interactions.OFFICIAL_ID, "food_report", model, clock).error, "invalid_actor", "official is not player actor")
    check(service.report(Interactions.PLAYER_ID, "unknown", "food_report", model, clock).error, "invalid_target", "invalid target")
    check(service.report(Interactions.PLAYER_ID, Interactions.OFFICIAL_ID, "reward", model, clock).error, "invalid_action", "unknown action")
    check(service.report(Interactions.PLAYER_ID, Interactions.PLAYER_ID, "food_report", model, clock).error, "invalid_action", "target-specific action")
    return true

func mouse(pos: Vector2) -> void:
    var motion := InputEventMouseMotion.new()
    motion.position = pos
    root.push_input(motion, true)
    for pressed: bool in [true, false]:
        var event := InputEventMouseButton.new()
        event.position = pos
        event.button_index = MOUSE_BUTTON_LEFT
        event.pressed = pressed
        root.push_input(event, true)

func touch(pos: Vector2, down: bool) -> void:
    var event := InputEventScreenTouch.new()
    event.position = pos
    event.pressed = down
    root.push_input(event, true)

func button(label: String) -> Button:
    for node: Node in game.find_children("*", "Button", true, false):
        if node.text == label:
            return node
    return null

func native_touch(target: Vector2) -> void:
    for down: bool in [true, false]:
        var event := InputEventScreenTouch.new()
        event.position = target
        event.pressed = down
        Input.parse_input_event(event)
        Input.flush_buffered_events()
        await process_frame

func test_ui() -> bool:
    root.size = Vector2i(1280, 720)
    game = load("res://scenes/main.tscn").instantiate()
    game.save_store = Store.new(directory + "/manual.json")
    game.autosave = Autosave.new(directory + "/auto.json")
    root.add_child(game)
    game.set_process(false)
    await process_frame
    await process_frame
    game.app_active = true
    game._set_speed(0.0)
    var before := snapshot(game.settlement, game.clock)
    mouse(button("Bicara: Laras").get_global_rect().get_center())
    await process_frame
    await process_frame
    check(game.character_panel.visible, true, "HUD opens panel")
    check(game.character_panel.title_label.text, "Laras", "panel named speaker")
    check(game.character_panel.body_label.text.contains("Persediaan pangan: 60"), true, "panel reads active model")
    check(snapshot(game.settlement, game.clock), before, "opening does not mutate snapshot")
    mouse(game._cell_to_screen(Vector2i(0, 0)))
    touch(game._cell_to_screen(Vector2i(1, 0)), true)
    var drag := InputEventScreenDrag.new()
    drag.position = Vector2(700, 300)
    root.push_input(drag, true)
    touch(drag.position, false)
    var wheel := InputEventMouseButton.new()
    wheel.position = Vector2(700, 300)
    wheel.button_index = MOUSE_BUTTON_WHEEL_UP
    wheel.pressed = true
    root.push_input(wheel, true)
    wheel.pressed = false
    root.push_input(wheel, true)
    check(snapshot(game.settlement, game.clock), before, "modal blocks world placement")
    check(game.camera_offset, Vector2.ZERO, "modal blocks touch pan")
    check(game.camera_zoom, 1.0, "modal blocks wheel zoom")
    check(game.gestures.touches.is_empty(), true, "modal leaves no stuck gesture")
    mouse(game.character_panel.workers_button.get_global_rect().get_center())
    check(game.character_panel.body_label.text.contains("Warga dalam kelompok tenaga kerja: 8"), true, "mouse topic switch")
    check(snapshot(game.settlement, game.clock), before, "topic has no effects")
    mouse(game.character_panel.close_button.get_global_rect().get_center())
    check(game.character_panel.visible, false, "close button")
    check(snapshot(game.settlement, game.clock), before, "closing never builds or debits")
    game._change_farm_workers(-1)
    var official_pos: Vector2 = game._character_screen_position(Interactions.OFFICIAL_ID)
    mouse(official_pos)
    check(game.character_panel.body_label.text.contains("panen 5"), true, "marker opens fresh report")
    check(game.character_panel.body_label.text.contains("bersih: +2"), true, "changed policy reflected")
    game._set_speed(1.0)
    game._process(8.0)
    check(game.character_panel.body_label.text.contains("hari 2"), true, "open report refreshes after tick")
    check(game.character_panel.body_label.text.contains("Persediaan pangan: 62"), true, "open report refreshes inventory")
    check(game.clock.speed, 1.0, "dialog does not force pause")
    var esc := InputEventKey.new()
    esc.keycode = KEY_ESCAPE
    esc.pressed = true
    root.push_input(esc, true)
    check(game.character_panel.visible, false, "Esc closes panel")
    game._set_speed(0.0)
    game._save_game()
    game._automatic_farming()
    game._open_character(Interactions.OFFICIAL_ID)
    game._load_game()
    check(game.character_panel.visible, false, "load closes previous panel")
    game._open_character(Interactions.OFFICIAL_ID)
    check(game.character_panel.body_label.text.contains("panen 5"), true, "report uses loaded model")
    game._close_character()
    game.camera_offset = Vector2(80, -30)
    for zoom: float in [0.6, 1.0, 1.8]:
        game.camera_zoom = zoom
        var target: Vector2 = game._character_screen_position(Interactions.OFFICIAL_ID)
        check(game._character_at(target), Interactions.OFFICIAL_ID, "transformed marker hit")
        touch(target, true)
        touch(target, false)
        check(game.character_panel.visible, true, "touch opens transformed marker")
        game._close_character()
    game.camera_zoom = 1.0
    game.camera_offset = Vector2.ZERO
    mouse(game._character_screen_position(Interactions.PLAYER_ID))
    check(game.character_panel.title_label.text, "Kepala desa (Anda)", "same panel for player")
    check(game.character_panel.food_button.visible, false, "player has no official topics")
    check(game.settlement.population, 8, "markers do not add population")
    game._close_character()
    game._open_character(Interactions.OFFICIAL_ID)
    await process_frame
    await process_frame
    await native_touch(game.character_panel.workers_button.get_global_rect().get_center())
    check(game.character_panel.body_label.text.contains("Batas 1 petani"), true, "native touch changes topic")
    await native_touch(game.character_panel.close_button.get_global_rect().get_center())
    check(game.character_panel.visible, false, "native touch closes safely")
    check(game.settlement.buildings.size(), 3, "interaction sequence never builds")
    game._open_character(Interactions.OFFICIAL_ID)
    # Longer shortage text must also fit without hiding the close action.
    var saved_food: int = game.settlement.stocks.food
    game.settlement.stocks.food = 0
    game.settlement.set_farm_worker_target(0)
    for topic: String in ["food_report", "workforce_report"]:
        game._character_topic(topic)
        await process_frame
        await process_frame
        check(game.character_panel.card.get_global_rect().end.y <= 720, true, "shortage card fits " + topic)
        check(game.character_panel.body_label.get_minimum_size().y <= game.character_panel.body_label.size.y, true, "shortage text fits " + topic)
    game.settlement.stocks.food = saved_food
    game.settlement.set_farm_worker_target(1)
    game._character_topic("food_report")
    await process_frame
    await process_frame
    var panel = game.character_panel
    check(panel.card.get_global_rect().end.x <= 1280 and panel.card.get_global_rect().end.y <= 720, true, "card fits viewport")
    check(panel.body_label.get_minimum_size().y <= panel.body_label.size.y, true, "body text fits")
    for control: Button in [panel.food_button, panel.workers_button, panel.close_button]:
        check(control.size.y >= 44 and control.get_global_rect().end.y <= 720, true, "dialog touch target fits")
    if OS.get_cmdline_user_args().has("--render-smoke"):
        DirAccess.make_dir_recursive_absolute("res://.godot/official-tests")
        check(root.get_texture().get_image().save_png("res://.godot/official-tests/official-ui.png"), OK, "rendered official capture")
    game.free()
    return true

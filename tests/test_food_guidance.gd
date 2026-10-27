extends SceneTree
const Quest = preload("res://scripts/narrative/food_guidance.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
const Store = preload("res://scripts/persistence/save_store.gd")
const Autosave = preload("res://scripts/persistence/autosave_controller.gd")
class TimestampStore extends "res://scripts/persistence/save_store.gd":
    var counter: int = 100
    var writes: int = 0
    func capture(model: RefCounted, clock: RefCounted) -> Dictionary:
        var data := super.capture(model, clock)
        counter += 1
        data.saved_at_utc = counter
        if data.has("village"): data.village.saved_at_utc = counter
        return data
    func save_game(model: RefCounted, clock: RefCounted) -> Dictionary:
        writes += 1
        return super.save_game(model, clock)
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
    directory = "res://.godot/food-quest-tests/" + str(Time.get_ticks_usec())
    if OS.get_cmdline_user_args().has("--restart-write") or OS.get_cmdline_user_args().has("--restart-read"):
        if test_restart() != true: failed += 1
    else:
        for method: String in ["test_model", "test_validation_and_save", "test_autosave"]:
            if call(method) != true: failed += 1
        if await test_ui() != true: failed += 1
        if await test_visual_session() != true: failed += 1
    print("Food quest: %d passed, %d failed" % [passed, failed])
    quit(1 if failed else 0)

func good_report() -> Dictionary:
    return {"workers": 2, "produced": 10, "consumed": 3, "unmet": 0}

func test_model() -> bool:
    var quest := Quest.new()
    quest.observe_day(2, good_report())
    check(quest.is_pristine(), true, "unaccepted guidance never advances")
    var before := quest.capture()
    check(quest.choose("complete", 1).ok, false, "cannot complete unearned guidance")
    check(quest.choose("missing", 1).error, "invalid_choice", "unknown choice rejected")
    check(quest.capture(), before, "invalid choices preserve state")
    check(quest.choose("accept", 1).ok, true, "accept offered guidance")
    quest.observe_day(1, good_report())
    check(quest.state, "active", "same-day report cannot satisfy objective")
    quest.observe_day(2, {"workers": 0, "produced": 0, "consumed": 3, "unmet": 0})
    check(quest.state, "active", "no workers cannot qualify")
    quest.observe_day(2, good_report())
    check(quest.state, "active", "duplicate day cannot replace a failed harvest")
    quest.observe_day(3, good_report())
    check(quest.state, "ready", "successful subsequent harvest recorded")
    check(quest.harvest_day, 3, "actual harvest day stored")
    quest.observe_day(4, good_report())
    check(quest.harvest_day, 3, "ready state not re-awarded each day")
    check(quest.choose("complete", 2).ok, false, "stale completion day rejected")
    check(quest.choose("complete", 3).ok, true, "explicit completion")
    check(quest.resolution_id, "food_guidance.completed", "stable completion effect id")
    before = quest.capture()
    check(quest.choose("complete", 3).error, "already_resolved", "duplicate completion rejected")
    check(quest.choose("decline", 3).ok, false, "completed result cannot be changed")
    check(quest.capture(), before, "terminal state is idempotent")
    var declined := Quest.new()
    check(declined.choose("decline", 1).ok, true, "offered guidance may be declined")
    check(declined.resolution_id, "food_guidance.declined", "distinct opt-out result")
    declined.observe_day(2, good_report())
    check(declined.state, "declined", "declined guidance never auto-completes")
    check(declined.choose("accept", 2).ok, false, "no reactivation after opt-out")
    check(Quest.restore(declined.capture(), 2).state, "declined", "declined state validates")
    return true

func test_validation_and_save() -> bool:
    var model := Settlement.new()
    var clock := Clock.new()
    clock.speed = 0.0
    var store := Store.new(directory + "/save.json")
    check(store.capture(model, clock).schema_version, 2, "pristine legacy format retained")
    check(store.save_game(model, clock).ok, true, "write original save")
    var old_text: String = FileAccess.get_file_as_string(store.path)
    check(store.load_game().settlement.food_quest.is_pristine(), true, "v2 loads fresh offered guidance")
    check(FileAccess.get_file_as_string(store.path), old_text, "load never rewrites old bytes")
    var legacy: Dictionary = store.capture(model, clock)
    legacy.schema_version = 1
    legacy.content_version = "prototype-1"
    legacy.settlement.erase("farm_worker_target")
    check(store.validate(legacy).settlement.food_quest.state, "offered", "v1 defaults offered")
    model.food_quest.choose("accept", 1)
    check(store.capture(model, clock).schema_version, 4, "changed quest uses v4")
    check(store.save_game(model, clock).ok, true, "save active quest")
    check(store.load_game().settlement.food_quest.state, "active", "active roundtrip")
    check(store.load_game(true).settlement.food_quest.state, "offered", "prior snapshot retains prior stage")
    clock.day = 2
    model.food_quest.observe_day(2, good_report())
    store.save_game(model, clock)
    check(store.load_game().settlement.food_quest.state, "ready", "ready roundtrip")
    model.food_quest.choose("complete", 2)
    store.save_game(model, clock)
    var loaded: Dictionary = store.load_game()
    check(loaded.settlement.food_quest.resolution_id, "food_guidance.completed", "resolution restored")
    check(loaded.settlement.food_quest.choose("complete", 2).ok, false, "reload does not reapply resolution")
    check(loaded.settlement.stocks, model.stocks, "quest does not add resource rewards")
    var saved := store.capture(model, clock)
    var original := saved.duplicate(true)
    check(store.validate(saved).ok, true, "valid v4")
    check(saved, original, "validation never mutates source")
    var cases: Array = []
    for change: Dictionary in [{"id": "unknown"}, {"state": "unknown"}, {"resolution_id": ""}, {"harvest_day": 1}, {"observed_day": 3}, {"accepted_day": true}, {"harvest_day": 1.5}]:
        var bad := saved.duplicate(true)
        bad.food_quest.merge(change, true)
        cases.append(bad)
    var nested := saved.duplicate(true)
    nested.village = saved.duplicate(true)
    cases.append(nested)
    var extra := saved.duplicate(true)
    extra.food_quest.bonus = 100
    cases.append(extra)
    var missing := saved.duplicate(true)
    missing.food_quest.erase("resolution_id")
    cases.append(missing)
    var bad_village := saved.duplicate(true)
    bad_village.village.settlement.stocks.food = -1
    cases.append(bad_village)
    for bad: Dictionary in cases:
        check(store.validate(bad).ok, false, "invalid history/envelope rejected")
    var future := saved.duplicate(true)
    future.schema_version = 5
    store._write_text(store.path, JSON.stringify(future))
    check(store.save_game(model, clock).error, "protected_save", "future save protected")
    model.start_visual_village()
    var visual := store.capture(model, clock)
    check(visual.village.schema_version, 3, "quest preserves visual snapshot")
    check(store.validate(visual).settlement.layout_id, "nusantara-1", "visual quest roundtrip")
    model.food_quest = Quest.new()
    check(store.capture(model, clock).schema_version, 3, "pristine visual schema still supported")
    return true

func test_autosave() -> bool:
    var model := Settlement.new()
    var clock := Clock.new()
    clock.speed = 0.0
    var auto := Autosave.new(directory + "/auto.json")
    var store := TimestampStore.new(directory + "/auto.json")
    auto.store = store
    auto.prime(model, clock)
    model.food_quest.choose("decline", 1)
    check(auto.advance(60, model, clock).ok, true, "paused choice makes autosave dirty")
    check(store.load_game().settlement.food_quest.state, "declined", "autosave restores outcome")
    auto.advance(60, model, clock)
    check(store.writes, 1, "nested timestamps do not create false dirty state")
    check(FileAccess.file_exists(store.path + ".bak"), false, "unchanged outcome does not churn backups")
    return true

func mouse(button: Button) -> void:
    if not button.is_visible_in_tree():
        check(false, true, "cannot click hidden quest action")
        return
    var position: Vector2 = button.get_global_rect().get_center()
    var motion := InputEventMouseMotion.new()
    motion.position = position
    root.push_input(motion, true)
    for down: bool in [true, false]:
        var event := InputEventMouseButton.new()
        event.position = position
        event.button_index = MOUSE_BUTTON_LEFT
        event.pressed = down
        root.push_input(event, true)

func native_touch(button: Button) -> void:
    for down: bool in [true, false]:
        var event := InputEventScreenTouch.new()
        event.position = button.get_global_rect().get_center()
        event.pressed = down
        Input.parse_input_event(event)
        Input.flush_buffered_events()
        await process_frame

func test_ui() -> bool:
    root.size = Vector2i(1280,720)
    game = load("res://scenes/main.tscn").instantiate()
    game.save_store = Store.new(directory + "/ui.json")
    game.autosave = Autosave.new(directory + "/ui-auto.json")
    root.add_child(game)
    game.set_process(false)
    await process_frame
    await process_frame
    game.app_active = true
    game._set_speed(0)
    game._open_character(game.Interactions.OFFICIAL_ID)
    await process_frame
    await process_frame
    mouse(game.character_panel.guidance_button)
    await process_frame
    await process_frame
    check(game.interaction_action, "food_guidance", "guidance topic opens")
    await native_touch(game.character_panel.choice_buttons.accept)
    check(game.settlement.food_quest.state, "active", "native touch accepts guidance")
    game._process(16)
    check(game.clock.day, 1, "paused guidance does not advance calendar")
    check(game.settlement.food_quest.state, "active", "pause cannot satisfy harvest")
    game._close_character()
    game._change_farm_workers(-2)
    game._set_speed(1)
    game._process(8)
    check(game.settlement.food_quest.state, "active", "failed real harvest remains active")
    game._automatic_farming()
    game._process(8)
    check(game.settlement.food_quest.state, "ready", "real successful daily tick makes ready")
    check(game.status_label.text.contains("laporkan panen"), true, "completion opportunity visible")
    game._set_speed(0)
    game._open_character(game.Interactions.OFFICIAL_ID)
    game._character_topic("food_guidance")
    await process_frame
    await process_frame
    var stocks: Dictionary = game.settlement.stocks.duplicate()
    mouse(game.character_panel.choice_buttons.complete)
    check(game.settlement.food_quest.state, "completed", "explicit claim completes")
    check(game.settlement.stocks, stocks, "completion changes no economy")
    game._quest_choice("complete")
    check(game.settlement.food_quest.resolution_id, "food_guidance.completed", "stale UI click is idempotent")
    game._close_character()
    game._save_game()
    game._load_game()
    check(game.settlement.food_quest.state, "completed", "UI save/load retains result")
    game._open_character(game.Interactions.OFFICIAL_ID)
    game._character_topic("food_guidance")
    await process_frame
    await process_frame
    check(game.character_panel.choice_row.visible, false, "resolved choices hidden")
    check(game.character_panel.body_label.text.contains("Panduan selesai"), true, "terminal response visible")
    check(game.character_panel.card.get_global_rect().end.y <= 720, true, "completed text/card fit")
    check(game.character_panel.body_label.get_minimum_size().y <= game.character_panel.body_label.size.y, true, "completed body fits")
    game._close_character()
    var fresh := Settlement.new()
    game._apply_loaded({"settlement":fresh, "clock":Clock.new()})
    game.clock.speed = 0
    game._open_character(game.Interactions.OFFICIAL_ID)
    game._character_topic("food_guidance")
    await process_frame
    await process_frame
    mouse(game.character_panel.choice_buttons.decline)
    check(game.settlement.food_quest.state, "declined", "UI opt-out is distinct")
    game._close_character()
    check(game.settlement.try_place("house", Vector2i.ZERO), "ok", "decline does not block building")
    game.free()
    return true

func test_visual_session() -> bool:
    var scene = load("res://scenes/visual_village.tscn").instantiate()
    root.add_child(scene)
    scene.session.set_process(false)
    scene.session.autosave = Autosave.new(directory + "/visual-auto.json")
    scene.session.autosave.enabled = false
    scene.session.save_store = Store.new(directory + "/visual.json")
    scene.session.clock.speed = 0
    scene.session.app_active = true
    await process_frame
    await process_frame
    var session = scene.session
    session._open_character(session.Interactions.OFFICIAL_ID)
    session._character_topic("food_guidance")
    await process_frame
    await process_frame
    mouse(session.character_panel.choice_buttons.accept)
    check(session.settlement.food_quest.state, "active", "F5 session shares quest command")
    session._close_character()
    session._set_speed(3)
    session._process(8)
    check(session.clock.day, 4, "multi-day tick advances clock")
    check(session.settlement.food_quest.harvest_day, 2, "catchup records first real successful day")
    session._set_speed(0)
    session._open_character(session.Interactions.OFFICIAL_ID)
    session._character_topic("food_guidance")
    await process_frame
    await process_frame
    mouse(session.character_panel.choice_buttons.complete)
    check(session.settlement.food_quest.state, "completed", "F5 session completes guidance")
    session._close_character()
    session._save_game()
    check(session.save_store.load_game().settlement.food_quest.state, "completed", "visual v4 save restores quest")
    session._load_game()
    check(session.settlement.food_quest.state, "completed", "visual load retains outcome")
    session._open_character(session.Interactions.OFFICIAL_ID)
    session._character_topic("food_guidance")
    await process_frame
    await process_frame
    if OS.get_cmdline_user_args().has("--render-smoke"):
        DirAccess.make_dir_recursive_absolute("res://.godot/food-quest-tests")
        check(root.get_texture().get_image().save_png("res://.godot/food-quest-tests/quest-ui.png"), OK, "rendered F5 quest capture")
    scene.free()
    return true

func test_restart() -> bool:
    var store := Store.new("res://.godot/food-quest-tests/restart.json")
    if OS.get_cmdline_user_args().has("--restart-write"):
        var model := Settlement.new()
        var clock := Clock.new()
        model.food_quest.choose("accept",1)
        model.food_quest.observe_day(2,good_report())
        clock.day = 2
        model.food_quest.choose("complete",2)
        check(store.save_game(model,clock).ok,true,"write quest in first process")
    else:
        var result := store.load_game()
        check(result.ok,true,"quest loads in fresh process")
        check(result.settlement.food_quest.state,"completed","outcome survives process restart")
        check(result.settlement.food_quest.choose("complete",result.clock.day).ok,false,"fresh process cannot repeat resolution")
    return true

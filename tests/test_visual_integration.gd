extends SceneTree
const Store = preload("res://scripts/persistence/save_store.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
var scene: Control
var passed := 0
var failed := 0
func _initialize() -> void:
    call_deferred("run")
func check(value: bool, message: String) -> void:
    if value: passed += 1
    else:
        failed += 1
        push_error(message)
func screen(cell: Vector2) -> Vector2:
    return (scene.world.iso(cell)*scene.zoom_level+scene.world.position)*scene.size/Vector2(640,360)
func click(point: Vector2) -> void:
    var motion := InputEventMouseMotion.new()
    motion.position = point
    Input.parse_input_event(motion)
    await process_frame
    var event := InputEventMouseButton.new()
    event.position = point
    event.button_index = MOUSE_BUTTON_LEFT
    event.pressed = true
    Input.parse_input_event(event)
    await process_frame
    event = event.duplicate()
    event.pressed = false
    Input.parse_input_event(event)
    await process_frame
func run() -> void:
    root.size = Vector2i(1280,720)
    scene = load("res://scenes/visual_village.tscn").instantiate()
    root.add_child(scene)
    scene.session.autosave.enabled = false
    scene.session.set_process(false)
    scene.session._set_speed(0)
    var store := Store.new("res://.godot/integration-tests/%d/save.json" % Time.get_ticks_usec())
    scene.session.save_store = store
    scene.session.autosave.store = Store.new(store.path+".auto")
    await process_frame
    var model: RefCounted = scene.session.settlement
    check(model.buildings.size() == 3 and model.initial_buildings.size() == 3,"Three economic starter buildings only")
    check(model.workforce().production == 10 and model.population == 8,"Sprites do not add workers or production")
    var original: Dictionary = store.capture(model,scene.session.clock)
    check(store.validate(original).ok,"Initial v3 validates")
    for entry in [[Vector2i(2,10),"occupied"],[Vector2i(2,11),"building_gap"],[Vector2i(9,16),"reserved"],[Vector2i(16,7),"reserved"],[Vector2i(39,39),"outside_map"]]:
        check(model.try_place("house",entry[0]) == entry[1],"Reject invalid footprint " + str(entry))
    check(store.capture(model,scene.session.clock) == original,"Invalid placements have zero side effects")
    # Exercise viewport click/release in the F5 frontend, at a legal authored village plot.
    scene.preview_build("house","Rumah")
    scene.update_preview(screen(Vector2(2,13)))
    check(scene.world.preview_valid and scene.world.preview_cells.size() == 4,"Green preview uses all four cells")
    await click(screen(Vector2(2,13)))
    check(model.buildings.get(Vector2i(2,13)) == "house" and model.stocks.wood == 90 and model.population == 10,"Viewport placement debits once while paused")
    check(Vector2i(2,13) not in model.initial_buildings,"New house distinct from starter")
    await click(screen(Vector2(2,13)))
    check(model.stocks.wood == 90,"Second click cannot double-build")
    scene.preview_build("field","Sawah")
    await click(screen(Vector2(14,10)))
    check(model.buildings.get(Vector2i(14,10)) == "rice_field" and model.workforce().assigned == 3,"Field joins authoritative workforce")
    scene.preview_build("granary","Lumbung")
    await click(screen(Vector2(11,12)))
    check(model.buildings.get(Vector2i(11,12)) == "granary" and model.stocks.wood == 25,"Granary placed from catalog cost")
    var count := 0
    for obj: Dictionary in scene.world.objects:
        if obj.has("model_id"): count += 1
    check(count == model.buildings.size(),"Exactly one sprite per model building")
    scene.preview_build("house","Rumah")
    await click(screen(Vector2(5,13)))
    check(model.stocks.wood == 25 and not model.buildings.has(Vector2i(5,13)),"Insufficient wood preserves state")
    scene.cancel_build()
    scene.session._change_farm_workers(-1)
    check(model.workforce().assigned == 2,"Manual worker cap")
    scene.session._set_speed(2)
    scene.session.app_active = true
    scene.session._process(4)
    check(scene.session.clock.day == 2 and model.stocks.food == 67,"Integrated clock advances model economy")
    scene.session._set_speed(0)
    scene.session._open_character(scene.session.Interactions.OFFICIAL_ID)
    check(scene.session.character_panel.body_label.text.contains("67"),"Laras reads actual stocks")
    scene.session._character_topic("workforce_report")
    check(scene.session.character_panel.body_label.text.contains("Batas 2"),"Laras reads current policy")
    var before_modal: Dictionary = store.capture(model,scene.session.clock)
    scene.preview_kind = "rice_field"
    await click(screen(Vector2(5,13)))
    var after_modal: Dictionary = store.capture(model,scene.session.clock)
    after_modal.saved_at_utc = before_modal.saved_at_utc
    check(after_modal == before_modal,"Modal blocks placement")
    scene.session._close_character()
    scene.cancel_build()
    scene.session._save_game()
    check(store.load_game().ok,"Integrated manual save")
    model.set_farm_worker_target(0)
    scene.session._load_game()
    model = scene.session.settlement
    check(model.farm_worker_target == 2 and model.buildings.size() == 6 and model.initial_buildings.size() == 3,"Load rebuilds authoritative state and initial flags")
    check(scene.preview_kind.is_empty() and not scene.session.character_panel.visible,"Load resets interaction modes")
    # Save validation protects visual spatial invariants.
    var valid: Dictionary = store.capture(model,scene.session.clock)
    var bad: Dictionary = valid.duplicate(true)
    bad.settlement.buildings.append({"id":"house","x":3,"y":9})
    check(not store.validate(bad).ok,"Reject overlapping save")
    bad = valid.duplicate(true)
    bad.settlement.initial_buildings.append({"x":38,"y":38})
    check(not store.validate(bad).ok,"Reject dangling initial reference")
    bad = valid.duplicate(true)
    bad.settlement.buildings.append({"id":"house","x":9,"y":16})
    check(not store.validate(bad).ok,"Save cannot close gateway corridor")
    # Native touch drag must not place; taps place only once through raw touch path.
    scene.preview_build("field","Sawah")
    var touch := InputEventScreenTouch.new()
    touch.index = 0
    touch.position = screen(Vector2(5,13))
    touch.pressed = true
    scene._input(touch)
    var drag := InputEventScreenDrag.new()
    drag.index = 0
    drag.position = touch.position+Vector2(30,0)
    scene._input(drag)
    touch.pressed = false
    touch.position = drag.position
    scene._input(touch)
    check(model.buildings.size() == 6,"Native touch drag cannot build")
    scene.reset_view()
    touch.position = screen(Vector2(5,13))
    touch.pressed = true
    scene._input(touch)
    touch = touch.duplicate()
    touch.pressed = false
    scene._input(touch)
    check(model.buildings.size() == 7 and model.stocks.wood == 5,"Native touch tap builds exactly once")
    scene.cancel_build()
    scene.pan = Vector2(42,-35)
    scene.set_zoom(1.25)
    check(scene.screen_to_cell(screen(Vector2(11,12))) == Vector2i(11,12),"Placement coordinate inverse after camera transform")
    scene.reset_view()
    # Integrated automatic slot and failure preservation use the same store contract.
    scene.session.autosave.enabled = true
    scene.session.autosave.prime(model,scene.session.clock)
    model.set_farm_worker_target(1)
    scene.session.app_active = true
    scene.session._process(60)
    check(scene.session.autosave.store.load_game().ok,"Integrated autosave after paused command")
    model.set_farm_worker_target(0)
    scene.session._load_autosave()
    model = scene.session.settlement
    check(model.farm_worker_target == 1 and model.buildings.size() == 7,"Automatic load rebuilds visual state")
    scene.session.autosave.enabled = false
    var held_model: RefCounted = model
    var broken := FileAccess.open(store.path,FileAccess.WRITE)
    broken.store_string("broken")
    broken.close()
    scene.session._load_game()
    check(scene.session.settlement == held_model,"Failed load preserves live session")
    # Migration uses a staging model, no source mutation and no count/resource loss.
    var legacy := Settlement.new()
    legacy.buildings.clear()
    for y in range(10):
        for x in range(10): legacy.buildings[Vector2i(x,y)] = "rice_field" if (x+y)%2 == 0 else "house"
    legacy.farm_worker_target = 3
    var legacy_data: Dictionary = store.capture(legacy,Clock.new())
    var legacy_copy: Dictionary = legacy_data.duplicate(true)
    var restored: Dictionary = store.validate(legacy_data)
    restored.settlement.layout.convert_legacy(restored.settlement)
    check(restored.settlement.buildings.size() == 100,"Full legacy save retains all 100 buildings")
    check(restored.settlement.stocks == legacy.stocks and restored.settlement.population == legacy.population and restored.settlement.farm_worker_target == 3,"Migration preserves economy and workforce")
    check(legacy_data == legacy_copy,"Legacy payload not mutated")
    check(store.validate(store.capture(restored.settlement,restored.clock)).ok,"Migrated full village passes footprint validation")
    var again: Dictionary = store.validate(legacy_data)
    again.settlement.layout.convert_legacy(again.settlement)
    check(again.settlement.buildings == restored.settlement.buildings,"Migration deterministic")
    var v1 := legacy_data.duplicate(true)
    v1.schema_version = 1
    v1.content_version = "prototype-1"
    v1.settlement.erase("farm_worker_target")
    var migrated_v1: Dictionary = store.validate(v1)
    migrated_v1.settlement.layout.convert_legacy(migrated_v1.settlement)
    check(migrated_v1.settlement.farm_worker_target == -1 and migrated_v1.settlement.buildings.size() == 100,"v1 migration remains automatic")
    var legacy_store := Store.new(store.path+".legacy")
    check(legacy_store.save_game(legacy,Clock.new()).ok,"Write v2 fixture")
    var original_bytes := FileAccess.get_file_as_bytes(legacy_store.path)
    scene.session.save_store = legacy_store
    scene.session._load_game()
    check(scene.session.settlement.buildings.size() == 100 and scene.session.settlement.layout_id == "nusantara-1","Frontend loads full legacy file")
    check(FileAccess.get_file_as_bytes(legacy_store.path) == original_bytes,"Loading leaves original file bytes unchanged")
    scene.session._save_game()
    check(legacy_store.load_game().data.schema_version == 3 and legacy_store.load_game(true).data.schema_version == 2,"Explicit save upgrades primary and retains v2 backup")
    scene.session._load_game(true)
    check(scene.session.settlement.buildings.size() == 100,"Legacy backup still loads through frontend")
    scene.session._apply_loaded({"settlement":model,"clock":Clock.new()})
    scene.session._set_speed(0)
    scene.status.text = "Desa playable: bangunan, pekerja dan simpanan terhubung."
    # Display original integrated session after building; no production art screenshots overwritten.
    scene.info_panel.hide()
    await process_frame
    if DisplayServer.get_name() != "headless":
        await RenderingServer.frame_post_draw
        check(root.get_texture().get_image().save_png("res://docs/screenshots/integration_playable.png") == OK,"Rendered evidence")
        scene.management_panel.show()
        await process_frame
        await RenderingServer.frame_post_draw
        check(scene.management_panel.get_rect().end.y < 650,"Management panel fits 720p")
        root.get_texture().get_image().save_png("res://docs/screenshots/integration_controls.png")
    print("INTEGRATED PLAYABLE: ",passed," passed, ",failed," failed")
    quit(failed)

extends Node2D
## Settlement presentation and input; simulation lives in scripts/simulation.
## It intentionally does NOT claim to implement full NPC AI, economy, or combat.

const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 10
const TILE_HALF_WIDTH: float = 40.0
const TILE_HALF_HEIGHT: float = 20.0
const MAP_ORIGIN: Vector2 = Vector2(640, 132)

const Catalog = preload("res://scripts/simulation/building_catalog.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
const SaveStore = preload("res://scripts/persistence/save_store.gd")
const Autosave = preload("res://scripts/persistence/autosave_controller.gd")
const Gestures = preload("res://scripts/presentation/world_gestures.gd")
const Interactions = preload("res://scripts/characters/village_interactions.gd")
const CharacterPanel = preload("res://scripts/presentation/character_panel.gd")
var settlement := Settlement.new()
var clock := Clock.new()
var save_store := SaveStore.new()
var autosave := Autosave.new()
var gestures := Gestures.new()
var blocked_touches: Dictionary = {}
var app_active: bool = true
var session_ready: bool = false
var current_building: String = "Sawah"
var camera_offset := Vector2.ZERO
var camera_zoom: float = 1.0
var panning: bool = false
const CAMERA_CENTER := Vector2(640, 340)

var animation_time: float = 0.0

var status_label: Label
var resource_label: Label
var time_label: Label
var help_label: Label
var autosave_label: Label
var autosave_button: Button
var hud_header: PanelContainer
var hud_footer: PanelContainer
var farm_minus_button: Button
var farm_plus_button: Button
var farm_auto_button: Button
var interactions := Interactions.new()
var character_panel := CharacterPanel.new()
var interaction_target: String = ""
var interaction_action: String = ""


func _ready() -> void:
    get_tree().auto_accept_quit = false
    _setup_hud()
    character_panel.quest_choice_requested.connect(_quest_choice)
    _update_hud()
    autosave.prime(settlement, clock)
    _update_autosave_controls()
    session_ready = true
    queue_redraw()


func _process(delta: float) -> void:
    if not app_active:
        return
    animation_time += delta * clock.speed
    var days: int = clock.advance(delta)
    var guidance_ready: bool = false
    for i in days:
        settlement.advance_day()
        var previous_quest_state: String = settlement.food_quest.state
        settlement.food_quest.observe_day(clock.day - days + i + 1, settlement.last_day_report)
        guidance_ready = guidance_ready or (previous_quest_state == "active" and settlement.food_quest.state == "ready")
    if days > 0:
        var report: Dictionary = settlement.last_day_report
        status_label.text = "Hari %d: panen +%d, konsumsi %d, kurang %d; pangan bersih %+d." % [clock.day, report.produced, report.consumed, report.unmet, report.net]
        if guidance_ready:
            status_label.text += " Panduan: laporkan panen kepada Laras."
        _update_hud()
    _accept_autosave_result(autosave.advance(delta, settlement, clock))
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("#b9e3d0"))
    # Behind map: simple scenery; future work replaces this with authored pixel art.
    draw_circle(Vector2(165, 160), 72, Color("#91c7a2"))
    draw_circle(Vector2(1100, 410), 95, Color("#91c7a2"))
    draw_circle(Vector2(1180, 205), 45, Color("#9bd5ae"))
    draw_set_transform(CAMERA_CENTER + camera_offset - CAMERA_CENTER * camera_zoom, 0.0, Vector2.ONE * camera_zoom)
    for y in GRID_HEIGHT:
        for x in GRID_WIDTH:
            var cell := Vector2i(x, y)
            var tile_center := _cell_to_screen(cell)
            var tile_color := Color("#83bf7a") if (x + y) % 2 == 0 else Color("#8cc982")
            _diamond(tile_center, tile_color)
    # Draw all ground first so later tiles cannot cover an earlier building.
    for y in GRID_HEIGHT:
        for x in GRID_WIDTH:
            var cell := Vector2i(x, y)
            var tile_center := _cell_to_screen(cell)
            if settlement.buildings.has(cell):
                _draw_building(tile_center, Catalog.DEFINITIONS[settlement.buildings[cell]].name)
    # Individual interaction markers; drawings still do not drive worker production.
    for id: String in Interactions.CHARACTERS:
        var definition: Dictionary = Interactions.CHARACTERS[id]
        var anchor: Vector2 = _cell_to_screen(definition.cell) + Vector2(0, -8)
        _draw_villager(anchor, Color("#5d466d") if id == Interactions.OFFICIAL_ID else Color("#b85f4e"))
        draw_rect(Rect2(anchor + Vector2(-23, -42), Vector2(46, 16)), Color("#35594c"))
        draw_string(ThemeDB.fallback_font, anchor + Vector2(-19, -30), definition.label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)
    var mouse_cell := _screen_to_cell(get_viewport().get_mouse_position())
    if _is_in_map(mouse_cell):
        _diamond(_cell_to_screen(mouse_cell), Color(1.0, 0.92, 0.42, 0.28), true)


func _diamond(center: Vector2, color: Color, outline: bool = false) -> void:
    var points := PackedVector2Array([
        center + Vector2(0, -TILE_HALF_HEIGHT),
        center + Vector2(TILE_HALF_WIDTH, 0),
        center + Vector2(0, TILE_HALF_HEIGHT),
        center + Vector2(-TILE_HALF_WIDTH, 0),
    ])
    draw_colored_polygon(points, color)
    if outline:
        var line_points := PackedVector2Array([points[0], points[1], points[2], points[3], points[0]])
        draw_polyline(line_points, Color("#df9834"), 2.0)


func _draw_building(center: Vector2, kind: String) -> void:
    if kind == "Sawah":
        _diamond(center, Color("#d6bf64"))
        for i in 4:
            var dx := float(i - 2) * 9.0
            draw_line(center + Vector2(dx - 6, -6), center + Vector2(dx + 6, 6), Color("#598047"), 2.0)
        return
    var body_color := Color("#e8c38e") if kind == "Rumah" else Color("#bd9b77")
    var roof_color := Color("#925342") if kind == "Rumah" else Color("#645146")
    draw_rect(Rect2(center + Vector2(-15, -23), Vector2(30, 25)), body_color)
    draw_colored_polygon(PackedVector2Array([
        center + Vector2(-21, -22), center + Vector2(0, -40),
        center + Vector2(21, -22), center + Vector2(0, -16),
    ]), roof_color)
    draw_rect(Rect2(center + Vector2(-4, -13), Vector2(8, 15)), Color("#765c48"))


func _draw_villager(center: Vector2, shirt: Color) -> void:
    draw_circle(center + Vector2(0, -12), 5.0, Color("#e7ba91"))
    draw_rect(Rect2(center + Vector2(-5, -6), Vector2(10, 11)), shirt)
    draw_line(center + Vector2(-2, 5), center + Vector2(-3, 10), Color("#403f41"), 2.0)
    draw_line(center + Vector2(2, 5), center + Vector2(3, 10), Color("#403f41"), 2.0)


func _cell_to_screen(cell: Vector2i) -> Vector2:
    return MAP_ORIGIN + Vector2(
        float(cell.x - cell.y) * TILE_HALF_WIDTH,
        float(cell.x + cell.y) * TILE_HALF_HEIGHT
    )


func _screen_to_cell(pos: Vector2) -> Vector2i:
    var world: Vector2 = (pos - CAMERA_CENTER - camera_offset) / camera_zoom + CAMERA_CENTER
    var rel: Vector2 = world - MAP_ORIGIN
    var x: float = (rel.x / TILE_HALF_WIDTH + rel.y / TILE_HALF_HEIGHT) / 2.0
    var y: float = (rel.y / TILE_HALF_HEIGHT - rel.x / TILE_HALF_WIDTH) / 2.0
    return Vector2i(roundi(x), roundi(y))


func _is_in_map(cell: Vector2i) -> bool:
    return cell.x >= 0 and cell.x < GRID_WIDTH and cell.y >= 0 and cell.y < GRID_HEIGHT


func _unhandled_input(event: InputEvent) -> void:
    if character_panel.visible:
        get_viewport().set_input_as_handled()
        return
    # UI still receives emulated mouse events; world actions use raw touch only.
    if event.device == InputEvent.DEVICE_ID_EMULATION or not gestures.touches.is_empty() or not blocked_touches.is_empty():
        return
    if event is InputEventMouseMotion and panning:
        camera_offset += event.relative
        camera_offset = camera_offset.clamp(Vector2(-600, -300), Vector2(600, 300))
        return
    if not event is InputEventMouseButton:
        return
    if event.button_index == MOUSE_BUTTON_MIDDLE:
        panning = event.pressed
        return
    if not event.pressed:
        return
    if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
        var factor: float = 1.1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1.0 / 1.1
        camera_zoom = clampf(camera_zoom * factor, 0.6, 1.8)
        return
    if event.button_index != MOUSE_BUTTON_LEFT or panning:
        return
    _place_at(event.position)


func _place_at(position: Vector2) -> void:
    if character_panel.visible:
        return
    var character_id: String = _character_at(position)
    if not character_id.is_empty():
        _open_character(character_id)
        return
    var cell: Vector2i = _screen_to_cell(position)
    var id: String = Catalog.id_for_name(current_building)
    var result: String = settlement.try_place(id, cell)
    match result:
        "ok":
            status_label.text = "%s dibangun pada (%d, %d)." % [current_building, cell.x, cell.y]
        "occupied":
            status_label.text = "Petak terisi. Pilih petak kosong."
        "insufficient_wood":
            status_label.text = "Kayu kurang! Butuh %d kayu." % Catalog.DEFINITIONS[id].wood
        _:
            status_label.text = "Pilih petak di dalam desa."
    _update_hud()


func _input(event: InputEvent) -> void:
    # Release must clear a drag even when the pointer ends over a consuming HUD.
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE and not event.pressed:
        panning = false
    if not app_active:
        return
    if character_panel.visible and event.is_action_pressed("ui_cancel") and not event.is_echo():
        _close_character()
        get_viewport().set_input_as_handled()
        return
    if event is InputEventScreenTouch:
        if event.pressed and (_over_hud(event.position) or not blocked_touches.is_empty()):
            blocked_touches[event.index] = true
            gestures.cancel()
            return
        if blocked_touches.has(event.index):
            blocked_touches.erase(event.index)
            return
        if _over_hud(event.position):
            gestures.cancel()
            return
        _apply_gesture(gestures.handle(event))
    elif event is InputEventScreenDrag:
        if _over_hud(event.position):
            gestures.cancel()
            return
        _apply_gesture(gestures.handle(event))


func _over_hud(position: Vector2) -> bool:
    return character_panel.visible or (is_instance_valid(hud_header) and hud_header.get_global_rect().has_point(position)) or (is_instance_valid(hud_footer) and hud_footer.get_global_rect().has_point(position))


func _character_screen_position(id: String) -> Vector2:
    var world: Vector2 = _cell_to_screen(Interactions.CHARACTERS[id].cell) + Vector2(0, -8)
    return (world - CAMERA_CENTER) * camera_zoom + CAMERA_CENTER + camera_offset


func _character_at(position: Vector2) -> String:
    for id: String in Interactions.CHARACTERS:
        if Rect2(_character_screen_position(id) + Vector2(-22, -32), Vector2(44, 44)).has_point(position):
            return id
    return ""


func _open_character(id: String) -> void:
    if not Interactions.CHARACTERS.has(id):
        return
    interaction_target = id
    interaction_action = "identity" if id == Interactions.PLAYER_ID else "food_report"
    _cancel_gestures()
    _refresh_character_report()


func _refresh_character_report() -> void:
    var response: Dictionary = interactions.report(Interactions.PLAYER_ID, interaction_target, interaction_action, settlement, clock)
    if response.ok:
        character_panel.show_report(response)


func _character_topic(action: String) -> void:
    var response: Dictionary = interactions.report(Interactions.PLAYER_ID, interaction_target, action, settlement, clock)
    if response.ok:
        interaction_action = action
        character_panel.show_report(response)


func _quest_choice(choice_id: String) -> void:
    if interaction_target != Interactions.OFFICIAL_ID or interaction_action != "food_guidance":
        return
    var result: Dictionary = settlement.food_quest.choose(choice_id, clock.day)
    if not result.ok:
        status_label.text = "Pilihan panduan tidak tersedia. Periksa keadaan terbaru."
    _refresh_character_report()


func _close_character() -> void:
    character_panel.hide()
    interaction_target = ""
    interaction_action = ""
    _cancel_gestures()


func _apply_gesture(command: Dictionary) -> void:
    if command.has("tap"):
        _place_at(command.tap)
    if command.has("pan"):
        camera_offset = (camera_offset + command.pan).clamp(Vector2(-600, -300), Vector2(600, 300))
    if command.has("zoom"):
        var anchor: Vector2 = command.anchor
        var world: Vector2 = (anchor - CAMERA_CENTER - camera_offset) / camera_zoom
        camera_zoom = clampf(camera_zoom * command.zoom, 0.6, 1.8)
        camera_offset = (command.target - CAMERA_CENTER - world * camera_zoom).clamp(Vector2(-600, -300), Vector2(600, 300))


func _cancel_gestures() -> void:
    gestures.cancel()
    blocked_touches.clear()
    panning = false


func _notification(what: int) -> void:
    if what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED]:
        _cancel_gestures()
        app_active = false
        if session_ready:
            _accept_autosave_result(autosave.flush(settlement, clock))
    elif what in [NOTIFICATION_APPLICATION_FOCUS_IN, NOTIFICATION_APPLICATION_RESUMED]:
        app_active = true
    elif what == NOTIFICATION_WM_CLOSE_REQUEST and session_ready:
        if _save_before_close():
            get_tree().quit()


func _save_before_close() -> bool:
    _close_character()
    var result: Dictionary = autosave.flush(settlement, clock)
    _accept_autosave_result(result)
    if not result.is_empty() and not result.ok:
        app_active = true
        status_label.text = "Autosave gagal. Game tetap terbuka; coba Simpan atau nonaktifkan autosave untuk keluar."
        return false
    return true


func _setup_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var header := PanelContainer.new()
    hud_header = header
    header.position = Vector2(20, 16)
    header.size = Vector2(1240, 67)
    layer.add_child(header)
    var top := HBoxContainer.new()
    top.add_theme_constant_override("separation", 15)
    header.add_child(top)

    var title := Label.new()
    title.text = "SATRIYA VILLAGE  |  Prototype 0.3"
    title.add_theme_font_size_override("font_size", 19)
    top.add_child(title)
    var space := Control.new()
    space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    top.add_child(space)
    resource_label = Label.new()
    top.add_child(resource_label)
    time_label = Label.new()
    top.add_child(time_label)

    var footer := PanelContainer.new()
    hud_footer = footer
    footer.position = Vector2(20, 516)
    footer.size = Vector2(1240, 188)
    layer.add_child(footer)
    var vertical := VBoxContainer.new()
    vertical.add_theme_constant_override("separation", 5)
    footer.add_child(vertical)
    var controls := HBoxContainer.new()
    controls.add_theme_constant_override("separation", 12)
    vertical.add_child(controls)

    var build_label := Label.new()
    build_label.text = "Bangun:"
    controls.add_child(build_label)
    for id: String in Catalog.DEFINITIONS:
        var kind: String = Catalog.DEFINITIONS[id].name
        var build_button := Button.new()
        build_button.custom_minimum_size = Vector2(44, 44)
        build_button.text = "%s (%d kayu)" % [kind, Catalog.DEFINITIONS[id].wood]
        build_button.pressed.connect(_select_building.bind(kind))
        controls.add_child(build_button)

    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    controls.add_child(spacer)
    for entry in [["Pause", 0.0], ["1x", 1.0], ["2x", 2.0], ["3x", 3.0]]:
        var speed_button := Button.new()
        speed_button.custom_minimum_size = Vector2(44, 44)
        speed_button.text = entry[0]
        speed_button.pressed.connect(_set_speed.bind(entry[1]))
        controls.add_child(speed_button)

    var files := HBoxContainer.new()
    files.add_theme_constant_override("separation", 10)
    vertical.add_child(files)
    for entry in [["Simpan", _save_game], ["Muat", _load_game.bind(false)], ["Cadangan", _load_game.bind(true)], ["Muat Otomatis", _load_autosave.bind(false)], ["Cadangan Otomatis", _load_autosave.bind(true)]]:
        var button := Button.new()
        button.custom_minimum_size = Vector2(44, 44)
        button.text = entry[0]
        button.add_to_group("persistence_controls")
        button.pressed.connect(entry[1])
        button.tooltip_text = "Simpan desa saat ini" if entry[0] == "Simpan" else "Ganti sesi aktif dengan snapshot tersimpan"
        files.add_child(button)
    autosave_button = Button.new()
    autosave_button.custom_minimum_size = Vector2(44, 44)
    autosave_button.add_to_group("persistence_controls")
    autosave_button.pressed.connect(_toggle_autosave)
    autosave_button.tooltip_text = "Mengaktifkan autosave akan memperbarui slot otomatis dengan sesi ini setiap 60 detik bila ada perubahan."
    files.add_child(autosave_button)
    autosave_label = Label.new()
    autosave_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    files.add_child(autosave_label)

    var workers := HBoxContainer.new()
    workers.add_theme_constant_override("separation", 10)
    vertical.add_child(workers)
    for entry in [["Petani -", _change_farm_workers.bind(-1)], ["Petani +", _change_farm_workers.bind(1)], ["Otomatis", _automatic_farming]]:
        var button := Button.new()
        button.custom_minimum_size = Vector2(44, 44)
        button.text = entry[0]
        button.add_to_group("workforce_controls")
        button.pressed.connect(entry[1])
        button.tooltip_text = "Satu petani mengaktifkan satu sawah; tanpa petani tidak ada panen."
        workers.add_child(button)
        match entry[0]:
            "Petani -": farm_minus_button = button
            "Petani +": farm_plus_button = button
            "Otomatis": farm_auto_button = button
    var talk_button := Button.new()
    talk_button.text = "Bicara: Laras"
    talk_button.custom_minimum_size = Vector2(44, 44)
    talk_button.add_to_group("interaction_controls")
    talk_button.pressed.connect(_open_character.bind(Interactions.OFFICIAL_ID))
    workers.add_child(talk_button)
    help_label = Label.new()
    help_label.tooltip_text = "Tap/klik: bangun | Geser jari/mouse tengah: kamera | Cubit/roda: zoom"
    workers.add_child(help_label)
    status_label = Label.new()
    status_label.text = "Selamat datang! Pilih bangunan, lalu klik petak kosong di desa."
    vertical.add_child(status_label)
    layer.add_child(character_panel)
    character_panel.topic_requested.connect(_character_topic)
    character_panel.closed.connect(_close_character)


func _select_building(kind: String) -> void:
    current_building = kind
    status_label.text = "Dipilih: %s. Klik petak kosong untuk membangun." % kind
    _update_hud()


func _set_speed(value: float) -> void:
    clock.set_speed(value)
    status_label.text = "Waktu dijeda." if clock.speed == 0.0 else "Kecepatan waktu: %sx." % str(int(clock.speed))
    _update_hud()


func _change_farm_workers(delta: int) -> void:
    var workers: Dictionary = settlement.workforce()
    var target: int = clampi(int(workers.assigned) + delta, 0, int(workers.capacity))
    if settlement.set_farm_worker_target(target):
        status_label.text = "Batas petani: %d. Berlaku untuk panen berikutnya." % target
        _update_hud()


func _automatic_farming() -> void:
    settlement.set_farm_worker_target(-1)
    status_label.text = "Petani dialokasikan otomatis sesuai warga dan sawah yang tersedia."
    _update_hud()


func _save_game() -> void:
    var result: Dictionary = save_store.save_game(settlement, clock)
    status_label.text = "Desa tersimpan." if result.ok else _save_error_message(result.error, true)


func _load_game(backup: bool = false) -> void:
    var result: Dictionary = save_store.load_game(backup)
    if not result.ok:
        status_label.text = _save_error_message(result.error, false)
        if not backup and save_store.load_game(true).ok:
            status_label.text += " Klik Cadangan untuk pemulihan."
        return
    _apply_loaded(result)
    status_label.text = "Cadangan dimuat." if backup else "Desa dimuat."


func _apply_loaded(result: Dictionary) -> void:
    # Swap only after the entire snapshot has been parsed and validated.
    _close_character()
    settlement = result.settlement
    clock = result.clock
    _cancel_gestures()
    camera_offset = Vector2.ZERO
    camera_zoom = 1.0
    animation_time = 0.0
    _update_hud()
    queue_redraw()


func _load_autosave(backup: bool = false) -> void:
    var result: Dictionary = autosave.store.load_game(backup)
    if not result.ok:
        status_label.text = _save_error_message(result.error, false)
        if not backup and autosave.store.load_game(true).ok:
            status_label.text += " Klik Cadangan Otomatis."
        return
    _apply_loaded(result)
    autosave.enabled = true
    autosave.prime(settlement, clock)
    _update_autosave_controls()
    status_label.text = "Cadangan otomatis dimuat." if backup else "Simpanan otomatis dimuat."


func _toggle_autosave() -> void:
    autosave.enabled = not autosave.enabled
    autosave.elapsed = 0.0
    _update_autosave_controls()


func _update_autosave_controls() -> void:
    autosave_button.text = "Autosave: Aktif" if autosave.enabled else "Autosave: Mati"
    autosave_label.text = "Otomatis tiap 60 dtk" if autosave.enabled else "Slot otomatis dilindungi"


func _accept_autosave_result(result: Dictionary) -> void:
    if result.is_empty():
        return
    autosave_label.text = "Otomatis tersimpan" if result.ok else "Autosave gagal; coba lagi 60 dtk"
    if not result.ok:
        status_label.text = _save_error_message(result.error, true)


func _save_error_message(reason: String, writing: bool) -> String:
    if reason == "missing":
        return "Belum ada simpanan ini. Desa aktif tetap tersedia."
    if reason in ["version", "content", "fields", "protected_save"]:
        return "Format simpanan berbeda. Gunakan versi game yang sesuai; desa aktif tetap tersedia."
    if writing:
        return "Simpan gagal. Periksa ruang penyimpanan dan izin folder, lalu coba lagi."
    return "Simpanan tidak dapat dibaca. Desa aktif tidak berubah."


func _update_hud() -> void:
    if resource_label != null:
        resource_label.text = "Kayu: %d   Pangan: %d   Uang: %d   Warga: %d" % [settlement.stocks.wood, settlement.stocks.food, settlement.stocks.coins, settlement.population]
    if time_label != null:
        time_label.text = "Hari %d  |  %sx" % [clock.day, str(int(clock.speed))]
    if help_label != null:
        var workers: Dictionary = settlement.workforce()
        var projection: Dictionary = settlement.food_projection()
        var mode: String = "Auto" if settlement.farm_worker_target == -1 else "Batas %d" % settlement.farm_worker_target
        help_label.text = "Petani %d/%d | Bebas %d | Pangan +%d -%d = %+d/hari | %s | %s" % [workers.assigned, workers.slots, workers.idle, projection.produced, projection.consumed, projection.net, mode, current_building]
        farm_minus_button.disabled = workers.assigned == 0
        farm_plus_button.disabled = workers.assigned >= workers.capacity
        farm_auto_button.disabled = settlement.farm_worker_target == -1
    if character_panel.visible:
        _refresh_character_report()

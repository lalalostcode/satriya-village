extends Node2D
## Settlement presentation and input; simulation lives in scripts/simulation.
## It intentionally does NOT claim to implement full NPC AI, economy, combat, or saving.

const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 10
const TILE_HALF_WIDTH: float = 40.0
const TILE_HALF_HEIGHT: float = 20.0
const MAP_ORIGIN: Vector2 = Vector2(640, 132)

const Catalog = preload("res://scripts/simulation/building_catalog.gd")
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
var settlement := Settlement.new()
var clock := Clock.new()
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


func _ready() -> void:
    _setup_hud()
    _update_hud()
    queue_redraw()


func _process(delta: float) -> void:
    animation_time += delta * clock.speed
    var days: int = clock.advance(delta)
    for i in days:
        settlement.advance_day()
    if days > 0:
        _update_hud()
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
    # Decorative villagers are visual-only; no autonomous NPC simulation yet.
    var pos_a := _cell_to_screen(Vector2i(5, 3)) + Vector2(sin(animation_time * 1.5) * 13.0, -8.0)
    var pos_b := _cell_to_screen(Vector2i(2, 6)) + Vector2(cos(animation_time * 1.1) * 12.0, -5.0)
    _draw_villager(pos_a, Color("#5d466d"))
    _draw_villager(pos_b, Color("#b85f4e"))
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
    var cell: Vector2i = _screen_to_cell(event.position)
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


func _notification(what: int) -> void:
    if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
        panning = false


func _setup_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var header := PanelContainer.new()
    header.position = Vector2(20, 16)
    header.size = Vector2(1240, 67)
    layer.add_child(header)
    var top := HBoxContainer.new()
    top.add_theme_constant_override("separation", 15)
    header.add_child(top)

    var title := Label.new()
    title.text = "SATRIYA VILLAGE  |  Prototype 0.2"
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
    footer.position = Vector2(20, 585)
    footer.size = Vector2(1240, 116)
    layer.add_child(footer)
    var vertical := VBoxContainer.new()
    vertical.add_theme_constant_override("separation", 7)
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
        build_button.text = "%s (%d kayu)" % [kind, Catalog.DEFINITIONS[id].wood]
        build_button.pressed.connect(_select_building.bind(kind))
        controls.add_child(build_button)

    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    controls.add_child(spacer)
    for entry in [["Pause", 0.0], ["1x", 1.0], ["2x", 2.0], ["3x", 3.0]]:
        var speed_button := Button.new()
        speed_button.text = entry[0]
        speed_button.pressed.connect(_set_speed.bind(entry[1]))
        controls.add_child(speed_button)

    help_label = Label.new()
    vertical.add_child(help_label)
    status_label = Label.new()
    status_label.text = "Selamat datang! Pilih bangunan, lalu klik petak kosong di desa."
    vertical.add_child(status_label)


func _select_building(kind: String) -> void:
    current_building = kind
    status_label.text = "Dipilih: %s. Klik petak kosong untuk membangun." % kind
    _update_hud()


func _set_speed(value: float) -> void:
    clock.set_speed(value)
    status_label.text = "Waktu dijeda." if clock.speed == 0.0 else "Kecepatan waktu: %sx." % str(int(clock.speed))
    _update_hud()


func _update_hud() -> void:
    if resource_label != null:
        resource_label.text = "Kayu: %d   Pangan: %d   Uang: %d   Warga: %d" % [settlement.stocks.wood, settlement.stocks.food, settlement.stocks.coins, settlement.population]
    if time_label != null:
        time_label.text = "Hari %d  |  %sx" % [clock.day, str(int(clock.speed))]
    if help_label != null:
        help_label.text = "Dipilih: %s  |  Klik petak kosong | Geser: mouse tengah | Zoom: roda mouse | 1 hari = 8 detik (1x)" % current_building

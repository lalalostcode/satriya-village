extends Node2D
## Visual prototype only: isometric tiles, basic building placement, and time/resource HUD.
## It intentionally does NOT claim to implement full NPC AI, economy, combat, or saving.

const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 10
const TILE_HALF_WIDTH: float = 40.0
const TILE_HALF_HEIGHT: float = 20.0
const MAP_ORIGIN: Vector2 = Vector2(640, 132)
const SECONDS_PER_DAY: float = 8.0

const BUILD_COST: Dictionary = {
    "Rumah": 30,
    "Sawah": 20,
    "Lumbung": 45,
}

var buildings: Dictionary = {
    Vector2i(4, 4): "Rumah",
    Vector2i(3, 4): "Sawah",
    Vector2i(4, 5): "Sawah",
}
var current_building: String = "Sawah"
var wood: int = 120
var food: int = 60
var coins: int = 150
var population: int = 8
var day: int = 1
var speed: float = 1.0
var elapsed: float = 0.0
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
    animation_time += delta
    elapsed += delta * speed
    while elapsed >= SECONDS_PER_DAY:
        elapsed -= SECONDS_PER_DAY
        _advance_day()
    queue_redraw()


func _advance_day() -> void:
    day += 1
    var fields: int = 0
    for building in buildings.values():
        if building == "Sawah":
            fields += 1
    # Prototype economy: each field produces 5 food, villagers consume 3 total.
    food += fields * 5 - 3
    coins += 2
    _update_hud()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("#b9e3d0"))
    # Behind map: simple scenery; future work replaces this with authored pixel art.
    draw_circle(Vector2(165, 160), 72, Color("#91c7a2"))
    draw_circle(Vector2(1100, 410), 95, Color("#91c7a2"))
    draw_circle(Vector2(1180, 205), 45, Color("#9bd5ae"))
    for y in GRID_HEIGHT:
        for x in GRID_WIDTH:
            var cell := Vector2i(x, y)
            var tile_center := _cell_to_screen(cell)
            var tile_color := Color("#83bf7a") if (x + y) % 2 == 0 else Color("#8cc982")
            _diamond(tile_center, tile_color)
            if buildings.has(cell):
                _draw_building(tile_center, buildings[cell])
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
    var rel: Vector2 = pos - MAP_ORIGIN
    var x: float = (rel.x / TILE_HALF_WIDTH + rel.y / TILE_HALF_HEIGHT) / 2.0
    var y: float = (rel.y / TILE_HALF_HEIGHT - rel.x / TILE_HALF_WIDTH) / 2.0
    return Vector2i(roundi(x), roundi(y))


func _is_in_map(cell: Vector2i) -> bool:
    return cell.x >= 0 and cell.x < GRID_WIDTH and cell.y >= 0 and cell.y < GRID_HEIGHT


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var cell: Vector2i = _screen_to_cell(event.position)
        if not _is_in_map(cell):
            return
        if buildings.has(cell):
            status_label.text = "Petak terisi. Pilih petak kosong."
            return
        var cost: int = BUILD_COST[current_building]
        if wood < cost:
            status_label.text = "Kayu kurang! Butuh %d kayu." % cost
            return
        wood -= cost
        buildings[cell] = current_building
        if current_building == "Rumah":
            population += 2
        status_label.text = "%s dibangun pada (%d, %d)." % [current_building, cell.x, cell.y]
        _update_hud()


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
    title.text = "SATRIYA VILLAGE  |  Prototype 0.1"
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
    for kind in BUILD_COST.keys():
        var build_button := Button.new()
        build_button.text = "%s (%d kayu)" % [kind, BUILD_COST[kind]]
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
    speed = value
    status_label.text = "Waktu dijeda." if speed == 0.0 else "Kecepatan waktu: %sx." % str(int(speed))
    _update_hud()


func _update_hud() -> void:
    if resource_label != null:
        resource_label.text = "Kayu: %d   Pangan: %d   Uang: %d   Warga: %d" % [wood, food, coins, population]
    if time_label != null:
        time_label.text = "Hari %d  |  %sx" % [day, str(int(speed))]
    if help_label != null:
        help_label.text = "Dipilih: %s  |  Klik petak kosong untuk membangun  |  1 hari = 8 detik pada 1x" % current_building

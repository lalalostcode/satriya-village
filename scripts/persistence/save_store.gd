extends RefCounted
## Plain-data persistence. No load operation mutates the active session.
const Settlement = preload("res://scripts/simulation/settlement_state.gd")
const Clock = preload("res://scripts/simulation/simulation_clock.gd")
const Catalog = preload("res://scripts/simulation/building_catalog.gd")
const MAX_BYTES: int = 1024 * 1024
const MAX_VALUE: int = 1000000000
var path: String

func _init(save_path: String = "user://saves/village.json") -> void:
    path = save_path

func capture(settlement: RefCounted, clock: RefCounted) -> Dictionary:
    var buildings: Array = []
    for cell: Vector2i in settlement.buildings:
        buildings.append({"id": settlement.buildings[cell], "x": cell.x, "y": cell.y})
    var snapshot: Dictionary = {
        "schema_version": 2, "content_version": "prototype-2",
        "saved_at_utc": int(Time.get_unix_time_from_system()),
        "clock": {"day": clock.day, "elapsed": clock.elapsed, "speed": clock.speed},
        "settlement": {
            "id": "village-1", "width": 10, "height": 10,
            "population": settlement.population, "stocks": settlement.stocks.duplicate(),
            "farm_worker_target": settlement.farm_worker_target,
            "buildings": buildings,
        },
    }
    if settlement.layout_id == settlement.Layout.ID:
        snapshot.schema_version = 3
        snapshot.content_version = "visual-1"
        snapshot.settlement.layout = settlement.layout_id
        snapshot.settlement.width = settlement.Layout.SIZE.x
        snapshot.settlement.height = settlement.Layout.SIZE.y
        snapshot.settlement.initial_buildings = []
        for cell: Vector2i in settlement.initial_buildings:
            snapshot.settlement.initial_buildings.append({"x": cell.x,"y": cell.y})
    return snapshot


func _failure(reason: String) -> Dictionary:
    return {"ok": false, "error": reason}

func _keys(value: Variant, keys: Array) -> bool:
    if not value is Dictionary or value.size() != keys.size():
        return false
    for key: String in keys:
        if not value.has(key):
            return false
    return true

func _number(value: Variant) -> bool:
    return (value is int or value is float) and is_finite(float(value))

func _integer(value: Variant, low: int, high: int) -> bool:
    return _number(value) and value >= low and value <= high and floor(float(value)) == float(value)

func validate(data: Variant) -> Dictionary:
    if not data is Dictionary:
        return _failure("format")
    if not _integer(data.get("schema_version"), 1, 3):
        return _failure("version")
    var content: String = "prototype-1" if data.schema_version == 1 else "prototype-2"
    var visual: bool = data.schema_version == 3
    if visual: content = "visual-1"
    if data.get("content_version") != content:
        return _failure("content")
    if not _keys(data, ["schema_version", "content_version", "saved_at_utc", "clock", "settlement"]):
        return _failure("fields")
    if data.schema_version == 1:
        if not _keys(data.settlement, ["id", "width", "height", "population", "stocks", "buildings"]):
            return _failure("settlement")
        var upgraded: Dictionary = data.duplicate(true)
        upgraded.schema_version = 2
        upgraded.content_version = "prototype-2"
        upgraded.settlement.farm_worker_target = -1
        return validate(upgraded)
    if not _integer(data.saved_at_utc, 0, 9999999999):
        return _failure("timestamp")
    var c: Variant = data.clock
    if not _keys(c, ["day", "elapsed", "speed"]):
        return _failure("clock")
    if not _integer(c.day, 1, MAX_VALUE) or not _number(c.elapsed):
        return _failure("clock")
    if c.elapsed < 0.0 or c.elapsed >= Clock.SECONDS_PER_DAY or not _integer(c.speed, 0, 3):
        return _failure("clock")
    var s: Variant = data.settlement
    var fields := ["id", "width", "height", "population", "stocks", "buildings", "farm_worker_target"]
    if visual: fields.append_array(["layout", "initial_buildings"])
    if not _keys(s, fields):
        return _failure("settlement")
    var extent: int = 40 if visual else 10
    if visual and s.layout != Settlement.Layout.ID: return _failure("map")
    if s.id != "village-1" or not _integer(s.width, extent, extent) or not _integer(s.height, extent, extent):
        return _failure("map")
    if not _integer(s.population, 0, MAX_VALUE) or not _keys(s.stocks, ["wood", "food", "coins"]):
        return _failure("inventory")
    if not _integer(s.farm_worker_target, -1, int(s.population)):
        return _failure("workforce")
    for value: Variant in s.stocks.values():
        if not _integer(value, 0, MAX_VALUE):
            return _failure("inventory")
    if not s.buildings is Array or s.buildings.size() > (400 if visual else 100):
        return _failure("buildings")
    var model := Settlement.new()
    model.buildings.clear()
    for building: Variant in s.buildings:
        if not _keys(building, ["id", "x", "y"]):
            return _failure("building")
        if not building.id is String or not Catalog.DEFINITIONS.has(building.id):
            return _failure("building_id")
        if not _integer(building.x, 0, extent-1) or not _integer(building.y, 0, extent-1):
            return _failure("cell")
        var cell := Vector2i(int(building.x), int(building.y))
        if model.buildings.has(cell):
            return _failure("duplicate_cell")
        if visual and model.layout.validate_placement(building.id,cell,model.buildings) != "ok":
            return _failure("footprint")
        model.buildings[cell] = building.id
    if visual:
        model.layout_id = Settlement.Layout.ID
        if not s.initial_buildings is Array or s.initial_buildings.size() > s.buildings.size(): return _failure("initial")
        for entry: Variant in s.initial_buildings:
            if not _keys(entry,["x","y"]): return _failure("initial")
            if not _integer(entry.x,0,extent-1) or not _integer(entry.y,0,extent-1): return _failure("initial")
            var cell := Vector2i(int(entry.x),int(entry.y))
            if not model.buildings.has(cell) or cell in model.initial_buildings: return _failure("initial")
            model.initial_buildings.append(cell)
    for key: String in s.stocks:
        model.stocks[key] = int(s.stocks[key])
    model.population = int(s.population)
    model.farm_worker_target = int(s.farm_worker_target)
    var restored_clock := Clock.new()
    restored_clock.day = int(c.day)
    restored_clock.elapsed = float(c.elapsed)
    restored_clock.set_speed(float(c.speed))
    return {"ok": true, "settlement": model, "clock": restored_clock, "data": data}

func read_file(file_path: String) -> Dictionary:
    if not FileAccess.file_exists(file_path):
        return _failure("missing")
    var file := FileAccess.open(file_path, FileAccess.READ)
    if file == null:
        return _failure("read")
    if file.get_length() > MAX_BYTES:
        file.close()
        return _failure("too_large")
    var text := file.get_as_text()
    var error := file.get_error()
    file.close()
    if error != OK and error != ERR_FILE_EOF:
        return _failure("read")
    var json := JSON.new()
    if json.parse(text) != OK:
        return _failure("json")
    return validate(json.data)

func load_game(backup: bool = false) -> Dictionary:
    return read_file(path + ".bak" if backup else path)

func _write_text(destination: String, text: String) -> Error:
    var file := FileAccess.open(destination, FileAccess.WRITE)
    if file == null:
        return FileAccess.get_open_error()
    file.store_string(text)
    file.flush()
    var error := file.get_error()
    file.close()
    return error

func _rename(source: String, destination: String) -> Error:
    return DirAccess.rename_absolute(source, destination)

func _write_verified(destination: String, data: Dictionary) -> bool:
    var text := JSON.stringify(data)
    if text.to_utf8_buffer().size() > MAX_BYTES or _write_text(destination, text) != OK:
        return false
    var result := read_file(destination)
    return result.ok and result.data == JSON.parse_string(text)

func save_game(settlement: RefCounted, clock: RefCounted) -> Dictionary:
    var data := capture(settlement, clock)
    if not validate(data).ok:
        return _failure("invalid_state")
    var previous := read_file(path)
    var backup := read_file(path + ".bak")
    for result: Dictionary in [previous, backup]:
        if not result.ok and result.error in ["version", "content", "fields", "read"]:
            return _failure("protected_save")
    if DirAccess.make_dir_recursive_absolute(path.get_base_dir()) != OK:
        return _failure("directory")
    if not _write_verified(path + ".tmp", data):
        return _failure("write_candidate")
    if previous.ok:
        if not _write_verified(path + ".bak.tmp", previous.data):
            return _failure("write_backup")
        if _rename(path + ".bak.tmp", path + ".bak") != OK:
            return _failure("promote_backup")
    elif FileAccess.file_exists(path):
        # Retain corrupt bytes before replacing; never rotate corruption into backup.
        var rejected := path + ".rejected-" + str(Time.get_unix_time_from_system()) + "-" + str(Time.get_ticks_usec())
        if DirAccess.copy_absolute(path, rejected) != OK:
            return _failure("preserve_corrupt")
    if _rename(path + ".tmp", path) != OK:
        return _failure("promote_save")
    var published := read_file(path)
    if not published.ok or published.data != JSON.parse_string(JSON.stringify(data)):
        return _failure("verify_save")
    return {"ok": true}

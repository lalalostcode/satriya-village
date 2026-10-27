extends RefCounted
## Shared spatial contract for simulation placement, save validation and presentation.
const ID := "nusantara-1"
const SIZE := Vector2i(40,40)
const INITIAL := {Vector2i(2,9): "house", Vector2i(14,7): "rice_field", Vector2i(17,7): "rice_field"}
const LANDMARKS := {Vector2i(5,5): "pendopo", Vector2i(12,3): "joglo", Vector2i(8,16): "gate"}
var rules: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/visual/footprint_rules.json"))
var roads: Dictionary = {}
var water: Dictionary = {}

func _init() -> void:
    for y in range(3,20): roads[Vector2i(9,y)] = true
    for y in range(8,16): roads[Vector2i(4,y)] = true
    for x in range(4,10): roads[Vector2i(x,12)] = true
    for x in range(4,19): roads[Vector2i(x,9)] = true
    for x in range(9,14): roads[Vector2i(x,14)] = true
    for x in range(20): water[Vector2i(x,18)] = true
    for y in range(6,14): water[Vector2i(16,y)] = true
    for x in range(13,20): water[Vector2i(x,12)] = true
    water.erase(Vector2i(16,9))

func art_kind(id: String) -> String:
    return "field" if id == "rice_field" else id

func footprint(id: String) -> Vector2i:
    var data: Array = rules.footprints[art_kind(id)].size
    return Vector2i(data[0],data[1])

func cells(id: String, origin: Vector2i) -> Array[Vector2i]:
    var result: Array[Vector2i] = []
    var extent := footprint(id)
    for y in range(origin.y,origin.y+extent.y):
        for x in range(origin.x,origin.x+extent.x):
            result.append(Vector2i(x,y))
    return result

func validate_placement(id: String, origin: Vector2i, buildings: Dictionary) -> String:
    var rect := Rect2i(origin,footprint(id))
    for cell in cells(id,origin):
        if cell.x < 0 or cell.y < 0 or cell.x >= SIZE.x or cell.y >= SIZE.y:
            return "outside_map"
        if roads.has(cell) or water.has(cell):
            return "reserved"
    for cell: Vector2i in LANDMARKS:
        var fixed := Rect2i(cell,footprint(LANDMARKS[cell]))
        if rect.intersects(fixed.grow(int(rules.default_building_gap))):
            return "reserved"
    for cell: Vector2i in buildings:
        var other := Rect2i(cell,footprint(buildings[cell]))
        if rect.intersects(other): return "occupied"
        if rect.intersects(other.grow(int(rules.default_building_gap))): return "building_gap"
    return "ok"

func convert_legacy(model: RefCounted) -> void:
    if model.layout_id == ID: return
    var old_cells: Array = model.buildings.keys()
    old_cells.sort_custom(func(a: Vector2i,b: Vector2i) -> bool: return a.y < b.y if a.y != b.y else a.x < b.x)
    var rebuilt: Dictionary = {}
    # All current economic footprints are 2x2. Use legal plots in stable workforce order.
    var cursor := 0
    for old: Vector2i in old_cells:
        var id: String = model.buildings[old]
        while cursor < SIZE.x*SIZE.y:
            var cell := Vector2i(cursor % SIZE.x, cursor / SIZE.x)
            cursor += 1
            if validate_placement(id,cell,rebuilt) == "ok":
                rebuilt[cell] = id
                break
    assert(rebuilt.size() == model.buildings.size(), "Legacy migration must retain every building")
    model.buildings = rebuilt
    model.initial_buildings = rebuilt.keys()
    model.layout_id = ID

extends RefCounted
const Catalog = preload("res://scripts/simulation/building_catalog.gd")
const FoodGuidance = preload("res://scripts/narrative/food_guidance.gd")
const Layout = preload("res://scripts/simulation/village_layout.gd")
var layout := Layout.new()
var layout_id: String = "legacy"
var initial_buildings: Array = []
const WIDTH: int = 10
const HEIGHT: int = 10
var buildings: Dictionary = {
    Vector2i(4, 4): "house",
    Vector2i(3, 4): "rice_field",
    Vector2i(4, 5): "rice_field",
}
var stocks: Dictionary = {"wood": 120, "food": 60, "coins": 150}
var population: int = 8
var farm_worker_target: int = -1 # -1 = automatic allocation; otherwise a manual cap.
var last_day_report: Dictionary = {}
var food_quest := FoodGuidance.new()

func contains(cell: Vector2i) -> bool:
    var extent: Vector2i = Layout.SIZE if layout_id == Layout.ID else Vector2i(WIDTH,HEIGHT)
    return cell.x >= 0 and cell.x < extent.x and cell.y >= 0 and cell.y < extent.y

func transact(changes: Dictionary) -> bool:
    # Validate the whole transaction before changing any stock.
    for key: Variant in changes:
        if not stocks.has(key) or not changes[key] is int:
            return false
        if stocks[key] + changes[key] < 0:
            return false
    for key: Variant in changes:
        stocks[key] += changes[key]
    return true

func try_place(id: String, cell: Vector2i) -> String:
    if not Catalog.DEFINITIONS.has(id):
        return "unknown_building"
    if not contains(cell):
        return "outside_map"
    if layout_id == Layout.ID:
        var spatial: String = layout.validate_placement(id,cell,buildings)
        if spatial != "ok": return spatial
    elif buildings.has(cell):
        return "occupied"
    var definition: Dictionary = Catalog.DEFINITIONS[id]
    if not transact({"wood": -int(definition.wood)}):
        return "insufficient_wood"
    buildings[cell] = id
    population += int(definition.population)
    return "ok"

func set_farm_worker_target(target: int) -> bool:
    if target < -1 or target > population:
        return false
    farm_worker_target = target
    return true

func workforce() -> Dictionary:
    var cells: Array = buildings.keys()
    cells.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
        return a.y < b.y if a.y != b.y else a.x < b.x)
    var budget: int = population if farm_worker_target == -1 else mini(population, farm_worker_target)
    var allocations: Dictionary = {}
    var assigned: int = 0
    var slots: int = 0
    var production: int = 0
    for cell: Vector2i in cells:
        var definition: Dictionary = Catalog.DEFINITIONS[buildings[cell]]
        var available: int = int(definition.worker_slots)
        if available == 0:
            continue
        slots += available
        var workers: int = mini(available, maxi(0, budget - assigned))
        allocations[cell] = workers
        assigned += workers
        if workers == available:
            production += int(definition.food)
    return {"assigned": assigned, "idle": population - assigned, "slots": slots,
        "capacity": mini(population, slots), "production": production, "allocations": allocations}

func food_projection() -> Dictionary:
    var workers := workforce()
    var consumed: int = mini(stocks.food + int(workers.production), 3)
    return {"produced": int(workers.production), "consumed": consumed,
        "unmet": 3 - consumed, "net": int(workers.production) - consumed,
        "coins": 2, "workers": int(workers.assigned)}

func advance_day() -> void:
    var report := food_projection()
    if transact({"food": report.net, "coins": report.coins}):
        last_day_report = report

func start_visual_village() -> void:
    layout_id = Layout.ID
    buildings = Layout.INITIAL.duplicate()
    initial_buildings = buildings.keys()

extends RefCounted
const Catalog = preload("res://scripts/simulation/building_catalog.gd")
const WIDTH: int = 10
const HEIGHT: int = 10
var buildings: Dictionary = {
    Vector2i(4, 4): "house",
    Vector2i(3, 4): "rice_field",
    Vector2i(4, 5): "rice_field",
}
var stocks: Dictionary = {"wood": 120, "food": 60, "coins": 150}
var population: int = 8

func contains(cell: Vector2i) -> bool:
    return cell.x >= 0 and cell.x < WIDTH and cell.y >= 0 and cell.y < HEIGHT

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
    if buildings.has(cell):
        return "occupied"
    var definition: Dictionary = Catalog.DEFINITIONS[id]
    if not transact({"wood": -int(definition.wood)}):
        return "insufficient_wood"
    buildings[cell] = id
    population += int(definition.population)
    return "ok"

func advance_day() -> void:
    var production: int = 0
    for id: String in buildings.values():
        production += int(Catalog.DEFINITIONS[id].food)
    var consumed: int = mini(stocks.food + production, 3)
    transact({"food": production - consumed, "coins": 2})

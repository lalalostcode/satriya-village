extends RefCounted
## Stable IDs and prototype rules, not final balancing.
const DEFINITIONS: Dictionary = {
    "house": {"name": "Rumah", "wood": 30, "population": 2, "food": 0, "worker_slots": 0},
    "rice_field": {"name": "Sawah", "wood": 20, "population": 0, "food": 5, "worker_slots": 1},
    "granary": {"name": "Lumbung", "wood": 45, "population": 0, "food": 0, "worker_slots": 0},
}

static func id_for_name(display_name: String) -> String:
    for id: String in DEFINITIONS:
        if DEFINITIONS[id].name == display_name:
            return id
    return ""

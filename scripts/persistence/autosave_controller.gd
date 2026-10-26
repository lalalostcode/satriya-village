extends RefCounted
const Store = preload("res://scripts/persistence/save_store.gd")
const INTERVAL: float = 60.0
var store: RefCounted
var enabled: bool = true
var elapsed: float = 0.0
var last_snapshot: Dictionary = {}

func _init(save_path: String = "user://saves/village-autosave.json") -> void:
    store = Store.new(save_path)
    enabled = not FileAccess.file_exists(save_path) and not FileAccess.file_exists(save_path + ".bak")

func _domain(settlement: RefCounted, clock: RefCounted) -> Dictionary:
    var snapshot: Dictionary = store.capture(settlement, clock)
    snapshot.erase("saved_at_utc")
    return snapshot

func prime(settlement: RefCounted, clock: RefCounted) -> void:
    last_snapshot = _domain(settlement, clock)
    elapsed = 0.0

func advance(delta: float, settlement: RefCounted, clock: RefCounted) -> Dictionary:
    if not enabled or not is_finite(delta) or delta <= 0.0:
        return {}
    elapsed += delta
    if elapsed < INTERVAL:
        return {}
    elapsed = 0.0
    return flush(settlement, clock)

func flush(settlement: RefCounted, clock: RefCounted) -> Dictionary:
    if not enabled:
        return {}
    var snapshot := _domain(settlement, clock)
    if snapshot == last_snapshot:
        return {}
    var result: Dictionary = store.save_game(settlement, clock)
    if result.ok:
        last_snapshot = snapshot
    elapsed = 0.0
    return result

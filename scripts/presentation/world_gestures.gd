extends RefCounted
## Converts raw world touches to tap/pan/zoom commands; no simulation or HUD references.
const DRAG_THRESHOLD: float = 12.0
var touches: Dictionary = {}
var starts: Dictionary = {}
var tap_allowed: bool = false

func cancel() -> void:
    touches.clear()
    starts.clear()
    tap_allowed = false

func handle(event: InputEvent) -> Dictionary:
    if event is InputEventScreenTouch:
        if event.pressed:
            touches[event.index] = event.position
            starts[event.index] = event.position
            tap_allowed = touches.size() == 1
            return {}
        if not touches.has(event.index):
            return {}
        var tap: bool = tap_allowed and touches.size() == 1 and not event.canceled
        tap = tap and event.position.distance_to(starts[event.index]) < DRAG_THRESHOLD
        touches.erase(event.index)
        starts.erase(event.index)
        tap_allowed = false
        return {"tap": event.position} if tap else {}
    if not event is InputEventScreenDrag or not touches.has(event.index):
        return {}
    var before: Vector2 = touches[event.index]
    if touches.size() == 1:
        touches[event.index] = event.position
        if tap_allowed and event.position.distance_to(starts[event.index]) < DRAG_THRESHOLD:
            return {}
        # Include the threshold movement on the first drag to avoid a dead jump.
        var previous: Vector2 = starts[event.index] if tap_allowed else before
        tap_allowed = false
        return {"pan": event.position - previous}
    tap_allowed = false
    var ids: Array = touches.keys()
    var a: Vector2 = touches[ids[0]]
    var b: Vector2 = touches[ids[1]]
    touches[event.index] = event.position
    if touches.size() != 2 or event.index not in [ids[0], ids[1]]:
        return {}
    var new_a: Vector2 = touches[ids[0]]
    var new_b: Vector2 = touches[ids[1]]
    var distance: float = a.distance_to(b)
    if distance < 1.0:
        return {}
    return {"zoom": new_a.distance_to(new_b) / distance, "anchor": (a + b) / 2.0, "target": (new_a + new_b) / 2.0}

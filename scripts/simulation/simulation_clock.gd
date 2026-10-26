extends RefCounted
const SECONDS_PER_DAY: float = 8.0
var day: int = 1
var speed: float = 1.0
var elapsed: float = 0.0

func set_speed(value: float) -> void:
    if value in [0.0, 1.0, 2.0, 3.0]:
        speed = value

func advance(delta: float) -> int:
    if not is_finite(delta) or delta <= 0.0 or speed == 0.0:
        return 0
    elapsed += delta * speed
    var days: int = int(elapsed / SECONDS_PER_DAY)
    elapsed -= days * SECONDS_PER_DAY
    day += days
    return days

extends "res://scripts/main.gd"
## Transitional controller adapter: reuse tested clock, commands and persistence.
## No second simulation or hidden legacy HUD is instantiated.
var frontend: Control

func _setup_hud() -> void:
    pass

func _draw() -> void:
    pass

func _input(_event: InputEvent) -> void:
    pass

func _unhandled_input(_event: InputEvent) -> void:
    pass

func _update_hud() -> void:
    frontend.refresh_hud()
    if character_panel.visible:
        _refresh_character_report()

func _apply_loaded(result: Dictionary) -> void:
    result.settlement.layout.convert_legacy(result.settlement)
    super._apply_loaded(result)
    frontend.session_loaded()

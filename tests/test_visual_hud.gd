extends SceneTree
var failures := 0
func _initialize() -> void:
    call_deferred("run")
func check(value: bool, message: String) -> void:
    if not value:
        failures += 1
        push_error(message)
func run() -> void:
    var scene = load("res://scenes/visual_village.tscn").instantiate()
    root.add_child(scene)
    scene.session.autosave.enabled = false
    scene.session.set_process(false)
    scene.session.clock.set_speed(0)
    scene.session._process(8)
    check(scene.session.clock.day == 1, "Paused clock")
    scene.session._set_speed(1)
    scene.session._process(8)
    check(scene.session.clock.day == 2 and scene.session.settlement.stocks.food == 67, "Existing model advances +7 food")
    check(scene.resource_label.text.contains("67") and scene.time_label.text.contains("2"), "Live HUD")
    scene.session._change_farm_workers(-1)
    check(scene.worker_label.text.contains("1/2"), "Live workers")
    await process_frame
    if DisplayServer.get_name() != "headless":
        await RenderingServer.frame_post_draw
        root.get_texture().get_image().save_png("res://docs/screenshots/integration_hud.png")
    print("HUD INTEGRATION: 4 checks, failures=",failures)
    quit(failures)

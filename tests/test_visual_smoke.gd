extends SceneTree
var failures: int = 0
func check(ok: bool,message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)
	else: print("PASS: ",message)
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280,720)
	var scene = load("res://scenes/visual_village.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	check(not scene.info_panel.visible and not scene.build_panel.visible,"Panels hidden on startup")
	check(scene.world.sprites.size() == scene.world.objects.size(),"All objects use Sprite2D PNGs")
	check(scene.world.catalog.size() == 16,"16 asset definitions loaded")
	check(scene.viewport.size == Vector2i(640,360),"Pixel world viewport")
	scene.preview_build("house","Rumah")
	check(scene.world.selected >= 0 and scene.info_panel.visible,"Build preview")
	scene.show_quest()
	check(scene.info.get_child(0).text == "Cadangan menipis","Quest mockup")
	scene.set_zoom(8)
	check(scene.zoom_level == 1.5,"Zoom limit")
	scene.reset_view()
	check(scene.zoom_level == 1.0 and scene.pan == Vector2.ZERO,"Reset framing")
	for kind in ["leader","house","field","gate"]:
		scene.select_kind(kind)
		var i: int = scene.world.selected
		check(scene.world.sprites[i].texture != null,"PNG loaded " + kind)
	scene.info_panel.hide()
	scene.select_kind("leader")
	var leader_pos: Vector2 = (scene.world.iso(scene.world.objects[scene.world.selected].cell) + scene.world.position + Vector2(0,-8)) * 2
	scene.world.selected = -1
	var motion := InputEventMouseMotion.new()
	motion.position = leader_pos
	Input.parse_input_event(motion)
	await process_frame
	var click := InputEventMouseButton.new()
	click.position = leader_pos
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	Input.parse_input_event(click)
	await process_frame
	click = click.duplicate()
	click.pressed = false
	Input.parse_input_event(click)
	await process_frame
	check(scene.world.selected >= 0,"Actual viewport mouse selection")
	check(scene.info.get_child(0).text.contains("Raras"),"Character detail from click")
	scene.world.selected = -1
	scene.world.queue_redraw()
	scene.info_panel.hide()
	await process_frame
	await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		check(root.get_texture().get_image().save_png("res://docs/screenshots/visual_after.png") == OK,"AFTER screenshot saved")
	print("VISUAL SMOKE FAILURES: ",failures)
	quit(failures)

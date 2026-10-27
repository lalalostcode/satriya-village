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
	scene.session.autosave.enabled = false
	scene.session._set_speed(0)
	await process_frame
	await process_frame
	check(not scene.info_panel.visible and not scene.build_panel.visible,"Panels hidden on startup")
	check(scene.world.sprites.size() == scene.world.objects.size(),"All objects use Sprite2D PNGs")
	check(scene.world.catalog.size() == 16,"16 asset definitions loaded")
	check(scene.viewport.size == Vector2i(640,360),"Pixel world viewport")
	check(scene.world.tile_half*4 == Vector2(48,24),"Tile is 48x24 screen pixels at 100 percent")
	var footprints: Array[Dictionary] = []
	var cells: Dictionary = {}
	var non_overlapping := true
	var inside := true
	for obj in scene.world.objects:
		if not obj.has("origin"): continue
		footprints.append(obj)
		for cell in scene.world.footprint_cells(obj):
			if cells.has(cell): non_overlapping = false
			cells[cell] = true
			if cell.x<0 or cell.y<0 or cell.x>=20 or cell.y>=20: inside = false
	check(non_overlapping and inside,"All footprint cells unique and inside the map")
	var spacing := true
	for i in range(footprints.size()):
		for j in range(i+1,footprints.size()):
			var a := Rect2i(footprints[i].origin,footprints[i].footprint)
			var b := Rect2i(footprints[j].origin,footprints[j].footprint)
			if not (a.end.x<b.position.x or b.end.x<a.position.x or a.end.y<b.position.y or b.end.y<a.position.y): spacing = false
	check(spacing,"At least one empty tile separates major footprints")
	var road_clear := true
	for cell in scene.world.roads:
		if scene.world.blocked.has(cell): road_clear = false
	check(road_clear,"Road cells do not cross solid footprint cells")
	check(scene.world.roads.has(Vector2i(9,16)) and not scene.world.blocked.has(Vector2i(9,16)),"Gateway center remains a walkable road cell")
	check(scene.world.blocked.has(Vector2i(8,16)) and scene.world.blocked.has(Vector2i(10,16)),"Gateway outer cells contain pillars")
	scene.preview_build("house","Rumah")
	check(scene.preview_kind == "house" and not scene.info_panel.visible,"Placement mode uses catalog ID")
	scene.cancel_build()
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
	check(scene.session.character_panel.visible and scene.session.character_panel.title_label.text.contains("Anda"),"Live character detail from click")
	scene.session._close_character()
	# A gap in the gate artwork must select through; both opaque pillars map to one object.
	scene.select_kind("gate")
	var gate_index: int = scene.world.selected
	var left: Sprite2D = scene.world.sprites[gate_index]
	var right: Sprite2D = scene.world.extra_sprites[0].sprite
	check(scene.world.pick(left.position+Vector2(0,-12)) == gate_index and scene.world.pick(right.position+Vector2(0,-12)) == gate_index,"Both gateway pillars select the gateway")
	check(scene.world.pick(scene.world.iso(Vector2(9,16))) != gate_index,"Gateway center selects through")
	scene.world.selected = -1
	scene.world.queue_redraw()
	scene.info_panel.hide()
	await process_frame
	await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		check(root.get_texture().get_image().save_png("res://docs/screenshots/integration_village.png") == OK,"Proportion AFTER screenshot saved")
		scene.world.show_footprints = true
		scene.world.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		check(root.get_texture().get_image().save_png("res://docs/screenshots/integration_footprints.png") == OK,"Footprint overlay screenshot saved")
	print("VISUAL SMOKE FAILURES: ",failures)
	quit(failures)

extends Control
## Pixel-art frontend bound to the existing settlement session controller.
const Session = preload("res://scripts/presentation/village_session.gd")
const Gestures = preload("res://scripts/presentation/world_gestures.gd")
var gestures := Gestures.new()
var blocked_touches: Dictionary = {}
var session: Node2D
var resource_label: Label
var time_label: Label
var worker_label: Label
var management_panel: PanelContainer
const Art = preload("res://scripts/visual/village_art.gd")
var world: Node2D
var viewport: SubViewport
var info: VBoxContainer
var info_panel: PanelContainer
var build_panel: PanelContainer
var quest_panel: PanelContainer
var status: Label
var zoom_label: Label
var zoom_level: float = 1.0
var pan := Vector2.ZERO
var dragging: bool = false
var drag_start := Vector2.ZERO
var moved: bool = false
var preview_kind: String = ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	session = Session.new()
	session.frontend = self
	session.settlement.start_visual_village()
	_build_world()
	_build_ui()
	add_child(session)
	world.sync_settlement(session.settlement)
	resized.connect(_layout_world)
	_layout_world()

func _build_world() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("426b45")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	viewport = SubViewport.new()
	viewport.size = Vector2i(640,360)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	world = Art.new()
	viewport.add_child(world)
	var image := TextureRect.new()
	image.texture = viewport.get_texture()
	image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)

func _layout_world() -> void:
	world.position = Vector2(320,66) + pan
	world.scale = Vector2.ONE * zoom_level

func style(bg: String, border: String = "b79a59") -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = Color(bg)
	box.border_color = Color(border)
	box.set_border_width_all(2)
	box.set_corner_radius_all(0)
	box.content_margin_left = 14
	box.content_margin_right = 14
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	return box

func panel(parent: Node, rect: Rect2) -> PanelContainer:
	var node := PanelContainer.new()
	node.position = rect.position
	node.size = rect.size
	node.add_theme_stylebox_override("panel",style("f5f0df"))
	parent.add_child(node)
	return node

func stack(parent: Node) -> VBoxContainer:
	var node := VBoxContainer.new()
	node.add_theme_constant_override("separation",9)
	parent.add_child(node)
	return node

func label(parent: Node, value: String, font_size: int = 17, color: String = "403d30") -> Label:
	var node := Label.new()
	node.text = value
	node.add_theme_font_size_override("font_size",font_size)
	node.add_theme_color_override("font_color",Color(color))
	parent.add_child(node)
	return node

func button(parent: Node, value: String, action: Callable) -> Button:
	var node := Button.new()
	node.text = value
	node.custom_minimum_size = Vector2(64,46)
	node.pressed.connect(action)
	parent.add_child(node)
	return node

func _build_ui() -> void:
	var ui := Control.new()
	ui.name = "HUD"
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ui)
	var t := Theme.new()
	t.default_font_size = 17
	t.set_stylebox("normal","Button",style("e2bd79","735431"))
	t.set_stylebox("hover","Button",style("f3d99b","dca957"))
	t.set_stylebox("pressed","Button",style("c79853","735431"))
	t.set_stylebox("focus","Button",style("f3d99b","fff0b5"))
	for state in ["font_color","font_hover_color","font_pressed_color"]:
		t.set_color(state,"Button",Color("372c22"))
	ui.theme = t
	ui.size = Vector2(1280,720)
	resized.connect(func() -> void: ui.scale = size / Vector2(1280,720))
	ui.scale = size / Vector2(1280,720)
	var top := panel(ui,Rect2(12,10,1256,48))
	top.add_theme_stylebox_override("panel",style("48382b","b68748"))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",28)
	top.add_child(row)
	label(row,"SATRIYA  /  WARINGIN",18,"f3d99b").size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resource_label = label(row,"",17,"fff0d1")
	time_label = label(row,"",17,"fff0d1")
	var tag := panel(ui,Rect2(16,68,360,32))
	tag.add_theme_stylebox_override("panel",style("3a5135","64814b"))
	worker_label = label(tag,"",13,"e4edcb")
	info_panel = panel(ui,Rect2(948,112,316,340))
	info = stack(info_panel)
	info_panel.hide()
	build_panel = panel(ui,Rect2(16,558,620,80))
	var build := HBoxContainer.new()
	build.add_theme_constant_override("separation",10)
	build_panel.add_child(build)
	for entry in [["Rumah","house"],["Sawah","field"],["Lumbung","granary"]]:
		button(build,entry[0],preview_build.bind(entry[1],entry[0])).custom_minimum_size.x = 140
	button(build,"Tutup",func() -> void: build_panel.hide())
	build_panel.hide()
	var actions := panel(ui,Rect2(16,650,576,60))
	actions.add_theme_stylebox_override("panel",style("48382b","b68748"))
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation",8)
	actions.add_child(bar)
	button(bar,"Bangun",func() -> void: build_panel.visible = not build_panel.visible)
	button(bar,"Kelola",func() -> void: management_panel.visible = not management_panel.visible)
	button(bar,"−",func() -> void: set_zoom(zoom_level-0.25))
	zoom_label = label(bar,"100%",16,"f3d99b")
	button(bar,"+",func() -> void: set_zoom(zoom_level+0.25))
	button(bar,"Reset",reset_view)
	status = label(ui,"Klik objek · Geser peta · Scroll zoom\nG: footprint / Esc: batal / Spasi: pause",14,"e4edcb")
	status.position = Vector2(640,650)
	status.size = Vector2(620,60)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_build_management(ui)

func show_info(title: String, subtitle: String, body: String) -> void:
	for child in info.get_children():
		info.remove_child(child)
		child.queue_free()
	label(info,title,20)
	label(info,subtitle,14,"8e4530")
	label(info,body,16)
	button(info,"Tutup informasi",func() -> void: info_panel.hide())
	info_panel.show()

func preview_build(kind: String, _title: String) -> void:
	preview_kind = "rice_field" if kind == "field" else kind
	info_panel.hide()
	build_panel.hide()
	management_panel.hide()
	status.text = "%s: %d kayu. Klik tanah kosong; Esc membatalkan." % [session.Catalog.DEFINITIONS[preview_kind].name,session.Catalog.DEFINITIONS[preview_kind].wood]

func select_kind(kind: String) -> void:
	for i in range(world.objects.size()):
		if world.objects[i].kind == kind:
			world.selected = i
			world.queue_redraw()
			return

func screen_to_world(screen: Vector2) -> Vector2:
	return (screen / size * Vector2(640,360)-world.position)/zoom_level

func screen_to_cell(screen: Vector2) -> Vector2i:
	var point := screen_to_world(screen)
	return Vector2i(roundi((point.x/world.tile_half.x+point.y/world.tile_half.y)/2),roundi((point.y/world.tile_half.y-point.x/world.tile_half.x)/2))

func update_preview(screen: Vector2) -> void:
	world.preview_cells.clear()
	if not preview_kind.is_empty():
		var cell := screen_to_cell(screen)
		var model: RefCounted = session.settlement
		world.preview_cells = model.layout.cells(preview_kind,cell)
		world.preview_valid = model.layout.validate_placement(preview_kind,cell,model.buildings) == "ok" and model.stocks.wood >= session.Catalog.DEFINITIONS[preview_kind].wood
	world.queue_redraw()

func select_at(screen: Vector2) -> void:
	if session.character_panel.visible: return
	var index: int = world.pick(screen_to_world(screen))
	# Named characters win over placement; their sprites do not add workers.
	if index >= 0:
		var obj: Dictionary = world.objects[index]
		if obj.kind == "leader" or (obj.kind == "farmer" and obj.cell == Vector2(13,9)):
			world.selected = index
			cancel_build()
			management_panel.hide()
			session._open_character(session.Interactions.PLAYER_ID if obj.kind == "leader" else session.Interactions.OFFICIAL_ID)
			return
	if not preview_kind.is_empty():
		var result: String = session.settlement.try_place(preview_kind,screen_to_cell(screen))
		var messages := {"ok":"Bangunan selesai.","occupied":"Footprint sudah terisi.","building_gap":"Sisakan satu tile antargedung.","reserved":"Jalan, air atau area landmark harus tetap terbuka.","outside_map":"Seluruh footprint harus di dalam peta.","insufficient_wood":"Kayu tidak cukup."}
		status.text = messages.get(result,result)
		if result == "ok":
			world.sync_settlement(session.settlement)
			refresh_hud()
		update_preview(screen)
		return
	world.selected = index
	world.queue_redraw()
	if index < 0:
		info_panel.hide()
		return
	var obj: Dictionary = world.objects[index]
	if obj.has("model_id"):
		var definition: Dictionary = session.Catalog.DEFINITIONS[obj.model_id]
		var assigned: int = session.settlement.workforce().allocations.get(obj.origin,0)
		var body := "Footprint %d x %d\n" % [obj.footprint.x,obj.footprint.y]
		if obj.model_id == "rice_field": body += "Petani %d/1; panen %d/hari." % [assigned,int(definition.food) if assigned > 0 else 0]
		elif obj.model_id == "house": body += "Pembangunan menambah 2 warga."
		else: body += "Lumbung belum memberi bonus\nkapasitas pada model saat ini."
		show_info(obj.title,"AWAL / IMPOR" if obj.initial else "BANGUNAN BARU",body)
	else:
		show_info(obj.title,"LANDMARK / DEKORASI", "Tidak menghasilkan sumber daya.\nTidak menambah pekerja.\n\nInspirasi Nusantara; bukan\nrekonstruksi sejarah.")

func cancel_build() -> void:
	preview_kind = ""
	status.text = "Mode lihat: klik bangunan atau tokoh. Bangun untuk memilih konstruksi."
	world.preview_cells.clear()
	world.queue_redraw()

func set_zoom(value: float) -> void:
	zoom_level = clampf(value,0.75,1.5)
	zoom_label.text = "%d%%" % int(zoom_level*100)
	_layout_world()

func reset_view() -> void:
	pan = Vector2.ZERO
	set_zoom(1.0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		session._close_character()
		cancel_build()
		info_panel.hide()
		build_panel.hide()
		management_panel.hide()
		dragging = false
		gestures.cancel()
		get_viewport().set_input_as_handled()
		return
	if session.character_panel.visible:
		dragging = false
		gestures.cancel()
		return
	if event is InputEventScreenTouch:
		if event.pressed and over_ui(event.position):
			blocked_touches[event.index] = true
			gestures.cancel()
			return
		if blocked_touches.has(event.index):
			if not event.pressed: blocked_touches.erase(event.index)
			return
		if over_ui(event.position):
			gestures.cancel()
			return
		apply_gesture(gestures.handle(event))
	elif event is InputEventScreenDrag:
		if over_ui(event.position) or not blocked_touches.is_empty(): gestures.cancel()
		else: apply_gesture(gestures.handle(event))
	if event.device == InputEvent.DEVICE_ID_EMULATION: return
	# Release is observed even above HUD so a world drag cannot become stuck.
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index in [MOUSE_BUTTON_LEFT,MOUSE_BUTTON_MIDDLE]:
			if dragging and not moved and event.button_index == MOUSE_BUTTON_LEFT:
				if not over_ui(event.position): select_at(event.position)
			dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if session.character_panel.visible or event.device == InputEvent.DEVICE_ID_EMULATION or not gestures.touches.is_empty() or not blocked_touches.is_empty(): return
	if event is InputEventMouseMotion: update_preview(event.position)
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_G:
			world.show_footprints = not world.show_footprints
			world.queue_redraw()
		if event.keycode == KEY_ESCAPE:
			info_panel.hide()
			build_panel.hide()
		if event.keycode == KEY_SPACE:
			session._set_speed(1.0 if session.clock.speed == 0 else 0.0)
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP: set_zoom(zoom_level+0.25)
			MOUSE_BUTTON_WHEEL_DOWN: set_zoom(zoom_level-0.25)
			MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE:
				dragging = true
				moved = false
				drag_start = event.position
	if event is InputEventMouseMotion and dragging:
		if event.position.distance_to(drag_start)>6: moved = true
		if moved:
			pan += event.relative / size * Vector2(640,360)
			pan = pan.clamp(Vector2(-500,-400),Vector2(500,150))
			_layout_world()

func _build_management(ui: Control) -> void:
	management_panel = panel(ui,Rect2(16,115,560,280))
	var column := stack(management_panel)
	label(column,"Waktu, pekerja & simpanan",20)
	var speeds := HBoxContainer.new()
	column.add_child(speeds)
	for entry in [["Pause",0.0],["1x",1.0],["2x",2.0],["3x",3.0]]:
		button(speeds,entry[0],session._set_speed.bind(entry[1]))
	var workers := HBoxContainer.new()
	column.add_child(workers)
	button(workers,"Petani -",session._change_farm_workers.bind(-1))
	button(workers,"Petani +",session._change_farm_workers.bind(1))
	button(workers,"Otomatis",session._automatic_farming)
	button(workers,"Laras",session._open_character.bind(session.Interactions.OFFICIAL_ID))
	var files := HBoxContainer.new()
	column.add_child(files)
	button(files,"Simpan",session._save_game)
	button(files,"Muat",session._load_game.bind(false))
	button(files,"Cadangan",session._load_game.bind(true))
	var automatic := HBoxContainer.new()
	column.add_child(automatic)
	button(automatic,"Muat otomatis",session._load_autosave.bind(false))
	button(automatic,"Cadangan auto",session._load_autosave.bind(true))
	session.autosave_button = button(column,"",session._toggle_autosave)
	session.autosave_button.tooltip_text = "Aktifkan untuk memakai slot otomatis bagi sesi ini."
	session.autosave_label = label(column,"",14)
	button(column,"Tutup",func() -> void: management_panel.hide())
	management_panel.hide()
	session.status_label = status
	ui.add_child(session.character_panel)
	session.character_panel.topic_requested.connect(session._character_topic)
	session.character_panel.closed.connect(session._close_character)

func refresh_hud() -> void:
	var model: RefCounted = session.settlement
	resource_label.text = "Pangan %d   Kayu %d   Uang %d   Warga %d" % [model.stocks.food,model.stocks.wood,model.stocks.coins,model.population]
	time_label.text = "Hari %d / %dx" % [session.clock.day,int(session.clock.speed)]
	var workers: Dictionary = model.workforce()
	worker_label.text = "Petani %d/%d / Bebas %d / Pangan %+d/hari" % [workers.assigned,workers.slots,workers.idle,model.food_projection().net]
	world.animate = session.clock.speed > 0

func session_loaded() -> void:
	cancel_build()
	gestures.cancel()
	blocked_touches.clear()
	dragging = false
	world.sync_settlement(session.settlement)
	info_panel.hide()
	reset_view()

func over_ui(point: Vector2) -> bool:
	if session.character_panel.visible: return true
	var design := point / size * Vector2(1280,720)
	if Rect2(12,10,1256,58).has_point(design) or Rect2(16,650,600,60).has_point(design): return true
	for control: Control in [info_panel,build_panel,management_panel]:
		if control.visible and Rect2(control.position,control.size).has_point(design): return true
	return false

func apply_gesture(command: Dictionary) -> void:
	if command.has("tap"): select_at(command.tap)
	if command.has("pan"):
		pan = (pan+command.pan / size * Vector2(640,360)).clamp(Vector2(-500,-400),Vector2(500,150))
		_layout_world()
	if command.has("zoom"): set_zoom(zoom_level*command.zoom)

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED]:
		dragging = false
		gestures.cancel()
		blocked_touches.clear()
		if is_instance_valid(world): world.animate = false
	elif what in [NOTIFICATION_APPLICATION_FOCUS_IN,NOTIFICATION_APPLICATION_RESUMED]:
		if is_instance_valid(session) and is_instance_valid(worker_label): refresh_hud()

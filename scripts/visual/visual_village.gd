extends Control
## Frontend-only scene: no simulation, save writes, production or quest execution.
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
	_build_world()
	_build_ui()
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
	world.position = Vector2(320,60) + pan
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
	for value in ["Pangan 128", "Kayu 86", "Warga 24", "Hari 07 · Pagi"]:
		label(row,value,17,"fff0d1")
	var tag := panel(ui,Rect2(16,68,360,32))
	tag.add_theme_stylebox_override("panel",style("3a5135","64814b"))
	label(tag,"SPRITE KANDIDAT · DATA CONTOH",13,"e4edcb")
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
	button(bar,"Krisis pangan",show_quest)
	button(bar,"−",func() -> void: set_zoom(zoom_level-0.25))
	zoom_label = label(bar,"100%",16,"f3d99b")
	button(bar,"+",func() -> void: set_zoom(zoom_level+0.25))
	button(bar,"Reset",reset_view)
	status = label(ui,"Klik objek · Geser peta · Scroll zoom\nEsc: tutup panel  /  Spasi: idle",14,"e4edcb")
	status.position = Vector2(792,658)

func show_info(title: String, subtitle: String, body: String) -> void:
	for child in info.get_children():
		info.remove_child(child)
		child.queue_free()
	label(info,title,20)
	label(info,subtitle,14,"8e4530")
	label(info,body,16)
	button(info,"Tutup informasi",func() -> void: info_panel.hide())
	info_panel.show()

func show_quest() -> void:
	show_info("Cadangan menipis", "QUEST CONTOH · belum aktif", "Sari meminta bantuan:\n\n“Persediaan padi menipis.\nMari rawat sawah bersama.”\n\nTarget contoh: 150 ikat padi.\nHadiah contoh: kepercayaan.")
	button(info,"Tinjau sawah",func() -> void: select_kind("field"))

func preview_build(kind: String, title: String) -> void:
	preview_kind = kind
	select_kind(kind)
	show_info("Rencana " + title, "PRATINJAU · bukan pembangunan", "Contoh bentuk disorot di desa.\n\nBiaya dan produksi belum\ntersambung pada demo ini.\n\nTidak mengubah stok atau save.")

func select_kind(kind: String) -> void:
	for i in range(world.objects.size()):
		if world.objects[i].kind == kind:
			world.selected = i
			world.queue_redraw()
			return

func select_at(screen: Vector2) -> void:
	var point := screen / size * Vector2(640,360)
	var index: int = world.pick((point-world.position)/zoom_level)
	world.selected = index
	world.queue_redraw()
	if index < 0: return
	var obj: Dictionary = world.objects[index]
	var role: String = obj.kind
	if role in ["leader","farmer","citizen"]:
		show_info(obj.title,"KARAKTER CONTOH", "Suasana hati: tenang\nKegiatan: animasi dekoratif\n\n“Selamat pagi! Mari singgah\ndi pendopo desa.”\n\nBelum terhubung ke AI.")
	else:
		var descriptions := {
			"joglo":"Rumah Jawa beratap tajug.\nInspirasi joglo; periode\nTumapel perlu riset.",
			"house":"Dinding kayu dan bambu.\nAtap hangat, teras sederhana.\n\nPenghuni contoh: 4 warga.",
			"field":"Padi muda dan pematang.\nSaluran air melewati sawah.\n\nHasil contoh: 12 ikat / hari.",
			"granary":"Lantai panggung dan tangga.\nTempat menyimpan hasil padi.\n\nKapasitas contoh: 200 ikat.",
			"pendopo":"Balai terbuka beratap susun.\nTempat warga berkumpul.\n\nInspirasi joglo Nusantara.",
			"gate":"Gapura bata sebagai\npenanda masuk desa.\n\nInspirasi gaya Nusantara.",
			"shrine":"Pelataran batu bertingkat.\nAksen budaya desa fiktif."}
		show_info(obj.title,"SPRITE KANDIDAT · belum disetujui",descriptions.get(role,"Vegetasi tropis dekoratif.\nBagian dari komposisi desa.")+"\n\nBukan rekonstruksi sejarah.")

func set_zoom(value: float) -> void:
	zoom_level = clampf(value,0.75,1.5)
	zoom_label.text = "%d%%" % int(zoom_level*100)
	_layout_world()

func reset_view() -> void:
	pan = Vector2.ZERO
	set_zoom(1.0)

func _input(event: InputEvent) -> void:
	# Release is observed even above HUD so a world drag cannot become stuck.
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index in [MOUSE_BUTTON_LEFT,MOUSE_BUTTON_MIDDLE]:
			if dragging and not moved and event.button_index == MOUSE_BUTTON_LEFT:
				if not get_viewport().gui_get_hovered_control(): select_at(event.position)
			dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			info_panel.hide()
			build_panel.hide()
		if event.keycode == KEY_SPACE:
			world.animate = not world.animate
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
			pan = pan.clamp(Vector2(-180,-100),Vector2(180,100))
			_layout_world()



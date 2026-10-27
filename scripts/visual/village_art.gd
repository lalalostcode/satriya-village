extends Node2D
## Derived sprite view; shared layout supplies footprint geometry.
const MANIFEST := "res://assets/visual/sprite_manifest.json"
const RULES := "res://assets/visual/footprint_rules.json"
const Layout = preload("res://scripts/simulation/village_layout.gd")
var map_size := Vector2i(20,20)
var layout := Layout.new()
var scenery: Array[Dictionary] = []
var preview_cells: Array[Vector2i] = []
var preview_valid: bool = false
var tile_half := Vector2(12,6)
var objects: Array[Dictionary] = []
var sprites: Array[Sprite2D] = []
var extra_sprites: Array[Dictionary] = []
var selected: int = -1
var animate: bool = true
var show_footprints: bool = false
var phase: float = 0.0
var catalog: Dictionary = {}
var rules: Dictionary = {}
var textures: Dictionary = {}
var roads: Dictionary = {}
var water: Dictionary = {}
var blocked: Dictionary = {}

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	catalog = JSON.parse_string(FileAccess.get_file_as_string(MANIFEST))
	rules = JSON.parse_string(FileAccess.get_file_as_string(RULES))
	tile_half = Vector2(rules.screen_tile_at_1280[0],rules.screen_tile_at_1280[1]) / float(rules.world_pixel_scale) / 2.0
	objects = [plot("house",2,9,"Rumah rumbia"),plot("house",2,13,"Rumah bambu"),
		plot("pendopo",5,5,"Balai Waringin · 4×4"),plot("joglo",12,3,"Rumah Jawa · 3×3"),
		plot("granary",11,12,"Lumbung panggung"),plot("gate",8,16,"Gapura desa · 3×1"),
		plot("field",14,7,"Sawah timur"),plot("field",17,7,"Petak padi"),
		plot("field",14,10,"Sawah irigasi"),plot("field",17,10,"Sawah hijau"),
		item("bridge",9,18,"Jembatan kayu"),item("leader",8.7,11.4,"Kepala desa (Anda)"),
		item("farmer",13,9,"Laras · Pejabat pertanian"),item("farmer",17.2,12.3,"Jaya · Petani"),
		item("citizen",4,11.5,"Wening · Warga"),item("citizen",9,6,"Banu · Warga")]
	for cell in [Vector2(0.5,3),Vector2(0,8),Vector2(0.4,13),Vector2(4,1),Vector2(8,1),Vector2(13,1),Vector2(17,3),Vector2(19,6),Vector2(19,17),Vector2(15,16.5),Vector2(4,18),Vector2(1,17)]:
		objects.append(item("tree",cell.x,cell.y,"Pohon tropis"))
	for cell in [Vector2(1,4.2),Vector2(6,1.6),Vector2(16,1.6),Vector2(1.2,18.2)]:
		objects.append(item("palm",cell.x,cell.y,"Kelapa"))
	for cell in [Vector2(0.7,10),Vector2(10,2.5),Vector2(13,4),Vector2(18.5,14.5)]:
		objects.append(item("banana",cell.x,cell.y,"Pisang"))
	for cell in [Vector2(1.2,2),Vector2(11,1.2),Vector2(19,4),Vector2(19,12.8)]:
		objects.append(item("bamboo",cell.x,cell.y,"Bambu"))
	for cell in [Vector2(1,6.2),Vector2(3.5,8.5),Vector2(3.5,12),Vector2(5.2,11.7),Vector2(7.5,11.8),Vector2(10.5,8),Vector2(12.5,8.5),Vector2(13.2,12),Vector2(11,14.3),Vector2(15,14),Vector2(5.5,14.5),Vector2(7,16.3),Vector2(11.4,16.3),Vector2(3.2,5),Vector2(6,4.8),Vector2(13.8,5.5)]:
		objects.append(item("flowers",cell.x,cell.y,"Taman kecil"))
	for cell in [Vector2(1.2,8),Vector2(1.5,12.5),Vector2(3,13.2),Vector2(10,3.3),Vector2(11.5,3.3),Vector2(13.5,14)]:
		objects.append(item("fence",cell.x,cell.y,"Pagar bambu"))
	_build_ground_plan()
	scenery = objects.duplicate(true)
	rebuild_sprites()

func rebuild_sprites() -> void:
	for sprite in sprites: sprite.free()
	for entry in extra_sprites: entry.sprite.free()
	sprites.clear()
	extra_sprites.clear()
	blocked.clear()
	selected = -1
	objects.sort_custom(func(a: Dictionary,b: Dictionary) -> bool: return iso(a.cell).y < iso(b.cell).y)
	for i in range(objects.size()):
		var obj: Dictionary = objects[i]
		if obj.kind == "gate":
			_create_gate(i)
			continue
		var sprite := create_sprite(obj.kind,iso(obj.cell),ground_depth(obj))
		sprites.append(sprite)
		if obj.has("origin"):
			for cell in footprint_cells(obj): blocked[cell] = i

func plot(kind: String,x: int,y: int,title: String) -> Dictionary:
	var size_data: Array = rules.footprints[kind].size
	var footprint := Vector2i(size_data[0],size_data[1])
	return {"kind":kind,"origin":Vector2i(x,y),"footprint":footprint,
		"cell":Vector2(x,y)+(Vector2(footprint)-Vector2.ONE)/2.0,"title":title}

func item(kind: String,x: float,y: float,title: String) -> Dictionary:
	return {"kind":kind,"cell":Vector2(x,y),"title":title}

func iso(cell: Vector2) -> Vector2:
	return Vector2((cell.x-cell.y)*tile_half.x,(cell.x+cell.y)*tile_half.y)

func footprint_cells(obj: Dictionary) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for y in range(obj.origin.y,obj.origin.y+obj.footprint.y):
		for x in range(obj.origin.x,obj.origin.x+obj.footprint.x): result.append(Vector2i(x,y))
	return result

func ground_depth(obj: Dictionary) -> float:
	if obj.has("footprint"): return (obj.footprint.x+obj.footprint.y)*tile_half.y/2.0
	return 0.0 if obj.kind in ["leader","farmer","citizen"] else 4.0

func presentation_texture(kind: String) -> Texture2D:
	if textures.has(kind): return textures[kind]
	var original: Texture2D = load(catalog[kind].texture)
	var image := original.get_image()
	var width: int = image.get_width()
	var height: int = image.get_height()
	if kind in ["leader","farmer","citizen"]:
		height = int(rules.character_height)
		width = roundi(float(image.get_width())/image.get_height()*height)
	else:
		width = int(rules.footprints[kind].sprite_width) if rules.footprints.has(kind) else int(rules.decoration_widths.get(kind,width))
		height = roundi(float(image.get_height())/image.get_width()*width)
	image.resize(width,height,Image.INTERPOLATE_NEAREST)
	textures[kind] = ImageTexture.create_from_image(image)
	return textures[kind]

func create_sprite(kind: String,point: Vector2,depth: float,texture: Texture2D = null) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = presentation_texture(kind) if texture == null else texture
	sprite.centered = false
	sprite.offset = Vector2(-floorf(sprite.texture.get_width()/2.0),-sprite.texture.get_height()+depth)
	sprite.position = point.round()
	# Sort by the front edge of the footprint so smaller foreground objects occlude correctly.
	sprite.z_index = 0 if kind in ["field","bridge"] else 100+roundi(point.y+depth)
	add_child(sprite)
	return sprite

func _create_gate(index: int) -> void:
	var obj: Dictionary = objects[index]
	var original: Texture2D = load(catalog.gate.texture)
	var source := original.get_image()
	for side in range(2):
		# Reuse the two approved pillar halves, aligned to the two outer footprint cells.
		var half_width := source.get_width()/2
		var crop := source.get_region(Rect2i(side*half_width,0,half_width,source.get_height()))
		var width: int = rules.footprints.gate.pillar_width
		crop.resize(width,roundi(float(crop.get_height())/crop.get_width()*width),Image.INTERPOLATE_NEAREST)
		var cell := Vector2(obj.origin)+Vector2(side*2,0)
		var sprite := create_sprite("gate",iso(cell),tile_half.y,ImageTexture.create_from_image(crop))
		blocked[Vector2i(cell)] = index
		if side == 0: sprites.append(sprite)
		else: extra_sprites.append({"sprite":sprite,"owner":index})

func _build_ground_plan() -> void:
	roads = layout.roads
	water = layout.water

func _process(delta: float) -> void:
	if not animate: return
	phase += delta
	for i in range(objects.size()):
		if objects[i].kind in ["leader","farmer","citizen"]:
			sprites[i].position = iso(objects[i].cell).round()+Vector2(0,roundf(sin(phase*2+i)*0.6))

func diamond_points(p: Vector2,half: Vector2) -> PackedVector2Array:
	return PackedVector2Array([p+Vector2(0,-half.y),p+Vector2(half.x,0),p+Vector2(0,half.y),p+Vector2(-half.x,0),p+Vector2(0,-half.y)])

func _draw() -> void:
	for y in range(map_size.y):
		for x in range(map_size.x):
			var cell := Vector2i(x,y)
			var p := iso(Vector2(cell))
			var color := Color("7b9f52")
			if roads.has(cell): color = Color("c8ad73")
			if water.has(cell): color = Color("548e91")
			draw_colored_polygon(diamond_points(p,tile_half),color)
			if roads.has(cell) and not water.has(cell):
				draw_rect(Rect2(p+Vector2((x*3+y)%9-4,0),Vector2(2,1)),Color("b39a67"))
			elif water.has(cell): draw_line(p+Vector2(-3,0),p+Vector2(3,2),Color("81b8b2"),1)
			elif (x*7+y*3)%4 == 0:
				draw_line(p+Vector2(4,1),p+Vector2(5,-2),Color("6e9349"),1)
			if show_footprints: draw_polyline(diamond_points(p,tile_half),Color("6d8a4b"),1)
	for i in range(objects.size()):
		if (show_footprints or selected == i) and objects[i].has("origin"):
			for cell in footprint_cells(objects[i]):
				var color := Color("f3d47c")
				if objects[i].kind == "gate" and cell.x == objects[i].origin.x+1: color = Color("a8e6de")
				draw_polyline(diamond_points(iso(Vector2(cell)),tile_half),color,1)

	for cell in preview_cells:
		draw_colored_polygon(diamond_points(iso(Vector2(cell)),tile_half),Color(0.3,1,0.4,0.55) if preview_valid else Color(1,0.2,0.15,0.6))

func hits_sprite(sprite: Sprite2D,local: Vector2) -> bool:
	var p := local-sprite.position-sprite.offset
	var image := sprite.texture.get_image()
	return p.x>=0 and p.y>=0 and p.x<image.get_width() and p.y<image.get_height() and image.get_pixelv(Vector2i(p)).a>0.5

func pick(local: Vector2) -> int:
	# Match visual depth, including the two independent gateway pillars.
	var best: int = -1
	var depth: int = -1
	for i in range(sprites.size()):
		if sprites[i].z_index>=depth and hits_sprite(sprites[i],local):
			best = i
			depth = sprites[i].z_index
	for entry in extra_sprites:
		if entry.sprite.z_index>=depth and hits_sprite(entry.sprite,local):
			best = entry.owner
			depth = entry.sprite.z_index
	return best

func sync_settlement(model: RefCounted) -> void:
	map_size = Layout.SIZE
	objects.clear()
	for obj: Dictionary in scenery:
		if obj.kind in ["house","field","granary"]: continue
		# Small scenery is dressing, removed from the view where an active building stands.
		var covered := false
		if not obj.has("origin") and obj.kind not in ["leader","farmer","citizen","bridge"]:
			for origin: Vector2i in model.buildings:
				if Rect2(Vector2(origin)-Vector2(0.5,0.5),Vector2(layout.footprint(model.buildings[origin]))).has_point(obj.cell): covered = true
		if not covered: objects.append(obj.duplicate(true))
	for origin: Vector2i in model.buildings:
		var id: String = model.buildings[origin]
		var obj := plot(layout.art_kind(id),origin.x,origin.y,model.Catalog.DEFINITIONS[id].name)
		obj.model_id = id
		obj.initial = origin in model.initial_buildings
		objects.append(obj)
	rebuild_sprites()
	queue_redraw()

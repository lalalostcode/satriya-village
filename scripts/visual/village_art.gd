extends Node2D
## Sprite-only objects; the ground remains an explicitly temporary tile renderer.
const MANIFEST := "res://assets/visual/sprite_manifest.json"
var objects: Array[Dictionary] = []
var sprites: Array[Sprite2D] = []
var selected: int = -1
var animate: bool = true
var phase: float = 0.0
var catalog: Dictionary = {}

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	catalog = JSON.parse_string(FileAccess.get_file_as_string(MANIFEST))
	objects = [item("house",2,5,"Rumah rumbia"),item("house",2,8,"Rumah bambu"),
		item("joglo",5,3,"Rumah Jawa"),item("pendopo",6,7,"Pendopo Waringin"),
		item("granary",10,3,"Lumbung panggung"),item("gate",8,11,"Gapura bata"),
		item("field",10,6,"Sawah timur"),item("field",12,6,"Petak padi"),
		item("field",10,8,"Sawah irigasi"),item("field",12,8,"Sawah hijau"),
		item("bridge",6,12,"Jembatan kayu"),item("leader",6.8,8.6,"Raras · Kepala desa"),
		item("farmer",9,6.7,"Sari · Petani"),item("farmer",12,9.5,"Jaya · Petani"),
		item("citizen",3.6,8,"Wening · Warga"),item("citizen",7.4,4.5,"Banu · Warga")]
	for cell in [Vector2(0,2),Vector2(0,5),Vector2(0,9),Vector2(3,0),Vector2(7,0),Vector2(11,0),Vector2(13,2),Vector2(13,11),Vector2(2,11),Vector2(4,12)]:
		objects.append(item("tree",cell.x,cell.y,"Pohon tropis"))
	for cell in [Vector2(1,3),Vector2(6,1),Vector2(12,2),Vector2(1,10)]:
		objects.append(item("palm",cell.x,cell.y,"Kelapa"))
	for cell in [Vector2(1,6),Vector2(4,1),Vector2(9,2),Vector2(11,10)]:
		objects.append(item("banana",cell.x,cell.y,"Pisang"))
	for cell in [Vector2(1,1),Vector2(8,1),Vector2(13,4)]:
		objects.append(item("bamboo",cell.x,cell.y,"Bambu"))
	for cell in [Vector2(3,6),Vector2(4,8),Vector2(7,7),Vector2(9,4),Vector2(2,9),Vector2(5,10),Vector2(8,10),Vector2(11,11)]:
		objects.append(item("flowers",cell.x,cell.y,"Taman kecil"))
	for cell in [Vector2(1,7),Vector2(2,10),Vector2(3.5,10),Vector2(9,1.5)]:
		objects.append(item("fence",cell.x,cell.y,"Pagar bambu"))
	objects.sort_custom(func(a: Dictionary,b: Dictionary) -> bool: return iso(a.cell).y < iso(b.cell).y)
	for obj in objects:
		var spec: Dictionary = catalog[obj.kind]
		var sprite := Sprite2D.new()
		sprite.texture = load(spec.texture)
		sprite.centered = false
		sprite.offset = Vector2(-sprite.texture.get_width()/2.0,-sprite.texture.get_height()+spec.ground_offset)
		sprite.position = iso(obj.cell).round()
		# Terrain crops must stay below the characters even where their footprints overlap.
		sprite.z_index = 0 if obj.kind in ["field","bridge"] else 1
		add_child(sprite)
		sprites.append(sprite)

func item(kind: String,x: float,y: float,title: String) -> Dictionary:
	return {"kind":kind,"cell":Vector2(x,y),"title":title}

func iso(cell: Vector2) -> Vector2:
	return Vector2((cell.x-cell.y)*20,(cell.x+cell.y)*10)

func _process(delta: float) -> void:
	if not animate: return
	phase += delta
	for i in range(objects.size()):
		if objects[i].kind in ["leader","farmer","citizen"]:
			sprites[i].position = iso(objects[i].cell).round() + Vector2(0,roundf(sin(phase*2+i)*0.6))

func diamond(p: Vector2,color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([p+Vector2(0,-10),p+Vector2(20,0),p+Vector2(0,10),p+Vector2(-20,0)]),color)

func _draw() -> void:
	for y in range(14):
		for x in range(14):
			var p := iso(Vector2(x,y))
			var path := x in [3,7,8] or y in [4,9,10]
			var color := Color("77a14e") if (x+y)%3 else Color("7ca651")
			if path: color = Color("c8ad73")
			if y == 12: color = Color("438c99")
			diamond(p,color)
			if path:
				for n in range(3):
					draw_rect(Rect2(p+Vector2(n*6-8,(x+y+n)%5-2),Vector2(2,1)),Color("b59b65"))
			elif y == 12:
				draw_line(p+Vector2(-6,0),p+Vector2(3,4),Color("7bc4c6"),1)
			else:
				draw_line(p+Vector2(4,1),p+Vector2(5,-2),Color("658d40"),1)
	if selected >= 0 and selected < objects.size():
		var p := iso(objects[selected].cell)
		draw_polyline(PackedVector2Array([p+Vector2(0,-12),p+Vector2(24,0),p+Vector2(0,12),p+Vector2(-24,0),p+Vector2(0,-12)]),Color("ffe694"),2)

func pick(local: Vector2) -> int:
	# Pixel alpha hit testing ignores transparent padding around each PNG.
	for i in range(sprites.size()-1,-1,-1):
		if objects[i].kind in ["field","bridge"]: continue
		if hits(i,local): return i
	for i in range(sprites.size()-1,-1,-1):
		if objects[i].kind in ["field","bridge"] and hits(i,local): return i
	return -1

func hits(i: int,local: Vector2) -> bool:
	var sprite := sprites[i]
	var p := local-sprite.position-sprite.offset
	var image := sprite.texture.get_image()
	return p.x>=0 and p.y>=0 and p.x<image.get_width() and p.y<image.get_height() and image.get_pixelv(Vector2i(p)).a>0.5


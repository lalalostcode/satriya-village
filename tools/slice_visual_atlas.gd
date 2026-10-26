extends SceneTree
## Deterministic atlas slicing/normalization; no procedural sprite painting.
func _initialize() -> void:
	var source := Image.load_from_file("res://assets/visual/source_atlas.png")
	var names := ["house","joglo","pendopo","granary","gate","field","palm","banana","bamboo","tree","fence","flowers","farmer","leader","citizen","bridge"]
	var widths := [74,88,96,70,66,76,62,48,46,66,40,28,20,18,18,66]
	# Measured on the generated 1254x1254 atlas; generated grids are not exact.
	var regions := [Rect2i(0,0,315,334),Rect2i(315,0,315,326),Rect2i(630,0,324,330),Rect2i(954,0,300,335),Rect2i(0,340,307,298),Rect2i(302,380,338,215),Rect2i(650,328,291,318),Rect2i(954,344,300,296),Rect2i(0,638,305,291),Rect2i(312,638,324,290),Rect2i(641,695,302,232),Rect2i(950,700,304,229),Rect2i(32,938,260,295),Rect2i(365,938,200,295),Rect2i(660,938,193,295),Rect2i(902,956,352,272)]
	var manifest: Dictionary = {}
	for i in range(16):
		var tile := source.get_region(regions[i])
		# Remove near-transparent generation noise before finding the occupied rectangle.
		for y in range(tile.get_height()):
			for x in range(tile.get_width()):
				var pixel := tile.get_pixel(x,y)
				if pixel.a < 0.5: tile.set_pixel(x,y,Color.TRANSPARENT)
				else: tile.set_pixel(x,y,Color(pixel.r,pixel.g,pixel.b,1.0))
		var bounds := tile.get_used_rect()
		var sprite := tile.get_region(bounds)
		var h := maxi(1,roundi(float(sprite.get_height())/sprite.get_width()*widths[i]))
		sprite.resize(widths[i],h,Image.INTERPOLATE_NEAREST)
		var path: String = "res://assets/visual/sprites/" + names[i] + ".png"
		var error := sprite.save_png(path)
		if error != OK:
			push_error("Cannot write " + path)
			quit(1)
			return
		manifest[names[i]] = {"texture":path,"width":widths[i],"height":h,"ground_offset":0 if i>=12 and i<=14 else 8,"status":"AI_GENERATED_CANDIDATE_NOT_APPROVED"}
		print(names[i],": ",widths[i],"x",h," alpha=",sprite.detect_alpha())
	var file := FileAccess.open("res://assets/visual/sprite_manifest.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(manifest,"\t"))
	quit()



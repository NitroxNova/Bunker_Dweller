extends Node3D

var EXTERIOR_CELL = load("res://game/blocks/room_mode/expandable_exterior.tscn")
var INTERIOR_CELL = load("res://game/blocks/room_mode/selected_interior.tscn")

func place_furniture():
	clear()
	var furniture_options :OptionButton = get_node("/root/Main/GameOverlay/%RoomTypeOptions")
	var furniture_name = furniture_options.get_item_text(furniture_options.get_selected_id())

	var furniture = load("res://ECS/Entity/"+furniture_name+"/Entity.tscn").instantiate()
	var mesh_instance = furniture.get_node("Mesh")
	furniture.remove_child(mesh_instance)
	#print(mesh_instance)   
	add_child(mesh_instance)
	
func select_room():
	clear()
	for entity_id in ECS.c_get("Room"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_room : Room_Component = entity.c_get("Room")
		var outline = get_room_outline(c_room)
		var poly = CSGPolygon3D.new()
		var material = StandardMaterial3D.new()
		material.albedo_color = Color(0,1,0,.5)
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		poly.material = material
		poly.polygon = outline
		poly.rotation.x = PI/2
		poly.position.y = c_room.y_axis+c_room.height-1.5
		var area = Area3D.new()
		var area_shape = CollisionPolygon3D.new()
		area_shape.polygon = outline
		area_shape.rotation.x = PI/2
		area_shape.position.y = c_room.y_axis+c_room.height-1.5
		area.add_child(area_shape)
		area.add_child(poly)
		add_child(area)
		area.input_event.connect(Input_System.room_selected.bind(entity))

#https://stackoverflow.com/questions/3501383/find-the-outline-of-a-union-of-grid-aligned-squares
func get_room_outline(c_room:Room_Component):
	var outline = []
	for tile in c_room.floor_tiles:
		var local_outline = [Vector2(tile),Vector2(tile.x+1,tile.y),Vector2(tile.x+1,tile.y+1),Vector2(tile.x,tile.y+1)]
		for i in 4:
			if not does_outline_overlap(outline,local_outline[i],local_outline[(i+1)%4]):
				outline.append([local_outline[i],local_outline[(i+1)%4]])
	
	var outline2 = {}
	for o in outline:
		outline2[o[0]] = o[1]
	
	var final_outline:PackedVector2Array = []
	final_outline.append(outline[0][0])
	var next_point = outline2[final_outline[0]]
	while next_point != final_outline[0]:
		final_outline.append(next_point)
		next_point = outline2[final_outline[-1]]
	
	return final_outline

func does_outline_overlap(outline:Array,start,end):
	if [end,start] in outline:
		outline.erase([end,start])
		return true
	return false

		
func new_room():
	clear()
	var camera_position = get_node("/root/Main/Camera3D").global_position
	for x in range(camera_position.x-20,camera_position.x+20):
		for y in range(camera_position.y-20,camera_position.y+20):
			for z in range(camera_position.z-20,camera_position.z+20):
				var cell_position := Vector3i(x,y,z)
				if is_valid_new_room_position(cell_position):
					var ext_cell = EXTERIOR_CELL.instantiate()
					ext_cell.position = cell_position
					ext_cell.position += Vector3(.5,.5,.5)
					Game.room_mode.add_child(ext_cell) 
					var area = ext_cell.get_node("Area3D")
					area.input_event.connect(Input_System.new_room_cell_clicked.bind(cell_position))

static func get_neighbor_floors(coords,corners:bool):
	var nb_tiles = []
	var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
	if corners:
		offsets.append_array([Vector2i(1,1),Vector2i(-1,1),Vector2i(-1,-1),Vector2i(1,-1)])
	for o in offsets:
		var nb_coords = coords
		nb_coords.x += o.x
		nb_coords.z += o.y
		if Game.blocks_gridmap.get_cell_item(nb_coords) != -1:
			nb_tiles.append(["floor",nb_coords])
		else:
			nb_tiles.append(["empty",nb_coords])
	return nb_tiles

func is_valid_new_room_position(cell_position:Vector3i)->bool:
	if Game.blocks_gridmap.get_cell_item(cell_position) != -1: #must be empty air block
		return false
	else:
		return has_neighboring_floor(cell_position)
	

static func is_selectable_exterior(cell_position:Vector3i)->bool:
	var c_room : Room_Component = Game.current_room.c_get("Room")
	var cell = Game.blocks_gridmap.get_cell_item(cell_position)
	if cell < 3: #block or empty (not floor)
		return true
	return false
	
static func has_neighboring_floor(cell_position:Vector3i):
	var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
	for o in offsets:
		var nb_coords = cell_position
		nb_coords.x += o.x
		nb_coords.z += o.y
		if Game.blocks_gridmap.get_cell_item(nb_coords) > Game.BLOCK_OPTIONS.scaffolding:
			return true
	return false	

static func get_exterior_tiles(coords):
	var nb_tiles = []
	var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
	for o in offsets:
		var nb_coords = coords
		nb_coords.x += o.x
		nb_coords.z += o.y
		if is_selectable_exterior(nb_coords):
			nb_tiles.append(nb_coords)
	return nb_tiles

func edit_room(room:Entity):
	clear()
	var c_room = room.c_get("Room")
	var ext_tiles = []
	for coords in c_room.floor_tiles:
		var coords_3d = Vector3i(coords.x,c_room.y_axis,coords.y)
		var nb_ext_tiles = get_exterior_tiles(coords_3d)
		if nb_ext_tiles.size() > 0:
			var inr_cell = INTERIOR_CELL.instantiate()
			inr_cell.position = coords_3d
			inr_cell.position += Vector3(.5,.5,.5)
			Game.room_mode.add_child(inr_cell) 	
			var area : Area3D = inr_cell.get_node("Area3D")
			area.input_event.connect(Input_System.interior_room_cell_clicked.bind(coords))
			
		for tile in nb_ext_tiles:
			if tile not in ext_tiles:
				ext_tiles.append(tile)
				
	for coords in ext_tiles:
		var out_cell = EXTERIOR_CELL.instantiate()
		out_cell.position = coords
		out_cell.position += Vector3(.5,.5,.5)
		Game.room_mode.add_child(out_cell) 	
		var area : Area3D = out_cell.get_node("Area3D")
		area.input_event.connect(Input_System.exterior_room_cell_clicked.bind(Vector2i(coords.x,coords.z)))

func clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	

	

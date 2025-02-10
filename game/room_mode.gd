extends Node3D

var EXTERIOR_CELL = load("res://game/blocks/room_mode/expandable_exterior.tscn")
var INTERIOR_CELL = load("res://game/blocks/room_mode/selected_interior.tscn")

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
		if Game.floor_gridmap.get_cell_item(nb_coords) != -1:
			nb_tiles.append(["floor",nb_coords])
		else:
			nb_tiles.append(["empty",nb_coords])
	return nb_tiles

func is_valid_new_room_position(cell_position:Vector3i)->bool:
	var nb_tiles = get_neighbor_floors(cell_position,true)
	for tile in nb_tiles: #immediate surrounding should be empty
		if tile[0] == "floor":
			return false
	#has to be a room one block away
	for tile_id in 4:
		var tile = nb_tiles[tile_id]
		for nb_tile in get_neighbor_floors(tile[1],false):
			if nb_tile[0] == "floor":
				return true
	return false
	

static func is_selectable_exterior(cell_position:Vector3i)->bool:
	var c_room : Room_Component = Game.current_room.c_get("Room")
	var cell = Game.floor_gridmap.get_cell_item(cell_position)
	if cell == -1:
		# make sure there is a gap between rooms (for pathing and wall clipping)
		for nb_tile in get_neighbor_floors(cell_position,true):
			if nb_tile[0] == "floor":
				if nb_tile[1] not in c_room.floor_tiles:
					return false
		return true
	return false
	
static func has_neighboring_floor(cell_position:Vector3i):
	var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
	for o in offsets:
		var nb_coords = cell_position
		nb_coords.x += o.x
		nb_coords.z += o.y
		if Game.floor_gridmap.get_cell_item(nb_coords) != -1:
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
			#make sure its at least 1 block away from other rooms
			var nb_nb_tiles = get_neighbor_floors(nb_coords,true)
			
			nb_tiles.append(nb_coords)
	return nb_tiles

func edit_room(room:Entity):
	clear()
	var c_room = room.c_get("Room")
	var ext_tiles = []
	for coords in c_room.floor_tiles:
		var nb_ext_tiles = get_exterior_tiles(coords)
		if nb_ext_tiles.size() > 0:
			var inr_cell = INTERIOR_CELL.instantiate()
			inr_cell.position = coords
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
		area.input_event.connect(Input_System.exterior_room_cell_clicked.bind(coords))

func clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	

	

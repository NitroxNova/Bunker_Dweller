extends Resource
class_name Room_Builder

static func build(entity:Entity):
	clear_room(entity)
	var c_room : Room_Component = entity.c_get("Room")
	for tile in c_room.floor_tiles:
		var coords : Vector3i
		coords.x = tile.x
		coords.y = c_room.y_axis
		coords.z = tile.y
		
		for y in c_room.height:
			var air_coords = Vector3i(coords)
			air_coords.y += y
			Game.blocks_gridmap.set_cell_item(air_coords,-1,0)
		
		
		if coords.x%4 == 0:
			if coords.z%3==0:
				Game.blocks_gridmap.set_cell_item(coords,Game.BLOCK_OPTIONS.white_floor_tab,0)
			else:
				Game.blocks_gridmap.set_cell_item(coords,Game.BLOCK_OPTIONS.white_floor_line,0)
		else:
			Game.blocks_gridmap.set_cell_item(coords,Game.BLOCK_OPTIONS.white_floor,0)
		
	for tile in c_room.floor_tiles:
		var coords : Vector3i
		coords.x = tile.x
		coords.y = c_room.y_axis
		coords.z = tile.y
		var nb_tiles = []
		
		var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
		for o in offsets:
			var nb_coords = tile
			nb_coords += o
			if nb_coords in c_room.floor_tiles:
				nb_tiles.append(["room",nb_coords])
			else:
				nb_tiles.append(["empty",nb_coords])
		
		var wall_coords = coords
		wall_coords.y = c_room.y_axis
		#three walls
		if nb_tiles[0][0] == "empty" and nb_tiles[1][0] == "empty" and nb_tiles[2][0] == "empty":
			set_three_walls(tile,16,c_room)
		elif nb_tiles[1][0] == "empty" and nb_tiles[2][0] == "empty" and nb_tiles[3][0] == "empty":
			set_three_walls(tile,0,c_room)
		elif nb_tiles[2][0] == "empty" and nb_tiles[3][0] == "empty" and nb_tiles[0][0] == "empty":
			set_three_walls(tile,22,c_room)
		elif nb_tiles[3][0] == "empty" and nb_tiles[0][0] == "empty" and nb_tiles[1][0] == "empty":
			set_three_walls(tile,10,c_room)
		#corners
		elif nb_tiles[0][0] == "empty" and nb_tiles[1][0] == "empty":
			set_corner(tile,16,c_room)
		elif nb_tiles[1][0] == "empty" and nb_tiles[2][0] == "empty":
			set_corner(tile,0,c_room)
		elif nb_tiles[2][0] == "empty" and nb_tiles[3][0] == "empty":
			set_corner(tile,22,c_room)
		elif nb_tiles[3][0] == "empty" and nb_tiles[0][0] == "empty":
			set_corner(tile,10,c_room)
		#straight wall
		elif nb_tiles[0][0] == "empty":
			set_wall(tile,16,c_room)
		elif nb_tiles[1][0] == "empty":
			set_wall(tile,0,c_room)
		elif nb_tiles[2][0] == "empty":
			set_wall(tile,22,c_room)
		elif nb_tiles[3][0] == "empty":
			set_wall(tile,10,c_room)
	Game.navigation_map.bake_navigation_mesh()

static func set_three_walls(floor_coords:Vector2i,rotation,c_room:Room_Component):
	for height_offset in c_room.height:	
		var wall_coords = Vector3i(floor_coords.x,height_offset+c_room.y_axis,floor_coords.y)
		if height_offset == 0:
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.three_walls_dark,rotation)
		else:
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.three_walls_white,rotation)


static func set_corner(floor_coords:Vector2i,rotation,c_room:Room_Component):
	for height_offset in c_room.height:	
		var wall_coords = Vector3i(floor_coords.x,height_offset+c_room.y_axis,floor_coords.y)
		if height_offset == 0:
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.corner_dark,rotation)
		else:
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.corner_white,rotation)

static func set_wall(floor_coords:Vector2i,rotation,c_room:Room_Component):
	for height_offset in c_room.height:	
		var wall_coords = Vector3i(floor_coords.x,height_offset+c_room.y_axis,floor_coords.y)
		if floor_coords in c_room.doors: #doors
			if height_offset == 0:
				Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.single_door_bottom,rotation)
			elif height_offset == 1:
				Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.single_door_top,rotation)
			else: #white wall above doorway
				Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.flat_white,rotation)
		elif height_offset == 0: #bottom layer, dark grey
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.flat_dark,rotation)
		else: #white on upper layers
			Game.wall_gridmap.set_cell_item(wall_coords,Game.WALL_OPTIONS.flat_white,rotation)
	

static func clear_room(entity:Entity):
	var c_room : Room_Component = entity.c_get("Room")
	for tile in c_room.floor_tiles:
		for y in range(c_room.y_axis,c_room.y_axis+c_room.height):
			var coords : Vector3i
			coords.x = tile.x
			coords.y = y
			coords.z = tile.y
			Game.blocks_gridmap.set_cell_item(coords,-1)
			Game.wall_gridmap.set_cell_item(coords,-1)

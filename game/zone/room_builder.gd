extends Resource
class_name Room_Builder

static func build(entity:Entity):
	var c_room : Room_Component = entity.c_get("Room")
	for coords in c_room.floor_tiles:
		var nb_tiles = get_neighbor_tiles(coords,c_room.floor_tiles)
		if coords.x%4 == 0:
			if coords.z%3==0:
				Game.floor_gridmap.set_cell_item(coords,2,0)
			else:
				Game.floor_gridmap.set_cell_item(coords,1,0)
		else:
			Game.floor_gridmap.set_cell_item(coords,0,0)
		
		if nb_tiles[0][0] == "empty" and nb_tiles[1][0] == "empty":
			Game.wall_gridmap.set_cell_item(coords,2,16)
		elif nb_tiles[1][0] == "empty" and nb_tiles[2][0] == "empty":
			Game.wall_gridmap.set_cell_item(coords,2,0)
		elif nb_tiles[2][0] == "empty" and nb_tiles[3][0] == "empty":
			Game.wall_gridmap.set_cell_item(coords,2,22)
		elif nb_tiles[3][0] == "empty" and nb_tiles[0][0] == "empty":
			Game.wall_gridmap.set_cell_item(coords,2,10)
		elif nb_tiles[0][0] == "empty":
			if coords.x % 3 == 1: #column
				Game.wall_gridmap.set_cell_item(coords,0,16)
			else:
				Game.wall_gridmap.set_cell_item(coords,1,16)
		elif nb_tiles[1][0] == "empty":
			if coords.z % 3 == 1:
				Game.wall_gridmap.set_cell_item(coords,0,0)
			else:
				Game.wall_gridmap.set_cell_item(coords,1,0)
		elif nb_tiles[2][0] == "empty":
			if coords.x % 3 == 1:
				Game.wall_gridmap.set_cell_item(coords,0,22)
			else:
				Game.wall_gridmap.set_cell_item(coords,1,22)
		elif nb_tiles[3][0] == "empty":
			if coords.z % 3 == 1:
				Game.wall_gridmap.set_cell_item(coords,0,10)
			else:
				Game.wall_gridmap.set_cell_item(coords,1,10)
	Game.get_node("/root/Main/%Floors_Navigation").bake_navigation_mesh()

static func clear_room(entity:Entity):
	var c_room : Room_Component = entity.c_get("Room")
	for coords in c_room.floor_tiles:
		Game.floor_gridmap.set_cell_item(coords,-1)
		Game.wall_gridmap.set_cell_item(coords,-1)
		

static func get_neighbor_tiles(coords,tiles):
	var nb_tiles = []
	var offsets = [Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)]
	for o in offsets:
		var nb_coords = coords
		nb_coords.x += o.x
		nb_coords.z += o.y
		if nb_coords in tiles:
			nb_tiles.append(["room",nb_coords])
		else:
			nb_tiles.append(["empty",nb_coords])
	return nb_tiles
			

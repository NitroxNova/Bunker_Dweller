extends Resource
class_name World_Builder

static var terrain_noise : FastNoiseLite

static func initialize() -> void:
	print("world builder init")
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = Game.seed
	Cave_Generator.initialize()

static func build_world(chunk_id:Vector3i):
	for x in range(chunk_id.x * 16,(chunk_id.x + 1) * 16):	
		for z in range(chunk_id.z * 16,(chunk_id.z + 1) * 16):
			for y in range(chunk_id.y * 16,(chunk_id.y + 1) * 16):
				var height = get_terrain_height(Vector2i(x,z))
				if y > height:
					break
				if y > height-3:
					Game.blocks_gridmap.set_cell_item(Vector3i(x,y,z),1,randi_range(0,24))
				else:
					var block = Cave_Generator.get_block(Vector3i(x,y,z))
					if block == Cave_Generator.BLOCKS.stone:
						Game.blocks_gridmap.set_cell_item(Vector3i(x,y,z),0,randi_range(0,24))
				#for y in range(height-2,height+1):
					#if y >= chunk_id.y*16 and y < (chunk_id.y+1)*16:
						#Game.blocks_gridmap.set_cell_item(Vector3i(x,y,z),1,randi_range(0,24))
				#if height-3 >= chunk_id.y*16:
				

static func get_terrain_height(block_pos:Vector2i)->int: #x and z
	var height : int 
	var noise_value : float = terrain_noise.get_noise_2dv(block_pos)
	height = noise_value * 50.0
	if noise_value < -0.1:
		height /= 3
	return height

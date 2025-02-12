extends Resource
class_name Cave_Generator

static var noise : FastNoiseLite 
enum BLOCKS {air,stone}

static func initialize():
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = Game.seed/2
	
static func get_block(position:Vector3i):
	var wall_value = noise.get_noise_3dv(position)
	if wall_value < -.1:
		return BLOCKS.air
	else:
		return BLOCKS.stone

func get_chunk(chunk_pos:Vector3i):
	var blocks = []
	for x in 16:
		for y in 16:
			for z in 16:
				var block_pos = Vector3i.ZERO
				block_pos.x = x + chunk_pos.x * 16
				block_pos.y = y + chunk_pos.y * 16
				block_pos.z = z + chunk_pos.z * 16
				block_pos *= 240
				var block = get_block(block_pos)
				blocks.append(block)
	return blocks

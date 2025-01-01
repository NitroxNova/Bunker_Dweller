extends Node3D


var grid := {}
var rooms := []
var cave_gen = Cave_Generator.new()
var threads : Array[Thread] = []

#func _physics_process(delta: float) -> void:
	#if 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_cave()
	
	#add_room(Vector3i(10,3,10),Vector3(-3,0,-3),[Vector2(0,3)])
	add_room(Vector3i(12,3,12),Vector3(-5,0,-5))
	
	var citizen_entity = await Entity_Spawner.citizen()
	citizen_entity.c_add(Position_Component.new(0,0,0))
	
	var citizen_entity2 = await Entity_Spawner.citizen()
	citizen_entity2.c_add(Position_Component.new(1,0,2))
	
	var bed_entity = Entity_Spawner.bed()
	bed_entity.c_add(Position_Component.new(3,0,-1))
	
	citizen_entity.c_get("Citizen").bed = bed_entity.id
	citizen_entity.c_get("Sleep_Need").value = 32
	
	citizen_entity2.c_get("Citizen").bed = bed_entity.id
	#set_hallway(Vector3i.ZERO)
	#set_hallway(Vector3i(1,0,1))
	#set_ramp(Vector3i(0,-1,1),TYPE.ramp_west)

func build_cave():
	render_chunk(Vector3i(1,0,1))
	render_chunk(Vector3i(1,0,2))
	render_chunk(Vector3i(2,0,1))
	render_chunk(Vector3i(2,0,2))

func render_chunk(chunk_pos:Vector3i):
	var chunk_blocks = cave_gen.get_chunk(chunk_pos)
	var block_idx = 0
	var grid_map : GridMap = $GridMap
	for x in 16:
		for y in 16:
			for z in 16:
				var block_pos = Vector3i.ZERO
				block_pos.x = x + chunk_pos.x * 16
				block_pos.y = y + chunk_pos.y * 16
				block_pos.z = z + chunk_pos.z * 16
				var block_type = chunk_blocks[block_idx]
				if block_type == Cave_Generator.BLOCKS.stone:
					#var stone_block = Entity_Spawner.stone_block()
					#stone_block.c_add(Position_Component.new(block_pos.x,block_pos.y,block_pos.z))
					grid_map.set_cell_item(block_pos,0,randi_range(0,24))
				block_idx += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_room(dimensions:Vector3i,position:Vector3,doors=[]):
	for x in dimensions.x:
		for z in dimensions.z:
			var coords = Vector3i()
			coords.y = position.y
			coords.x = position.x + x
			coords.z = position.z + z
			grid[coords] = {type="floor"}
			var hall_scene = load("res://game/blocks/hallway/hallway.tscn").instantiate()
			hall_scene.position = coords
			$Rooms.add_child(hall_scene)
			
			if Vector2(x,z) in doors:
				continue
			
			if z == 0:
				var wall_scene = load("res://game/blocks/room/wall.tscn").instantiate()
				wall_scene.position = coords
				$Rooms.add_child(wall_scene)
			elif z==dimensions.z-1:
				var wall_scene = load("res://game/blocks/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = PI
				$Rooms.add_child(wall_scene)
			
			if x == 0:
				var wall_scene = load("res://game/blocks/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = PI/2
				$Rooms.add_child(wall_scene)
			elif x==dimensions.x-1:
				var wall_scene = load("res://game/blocks/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = -PI/2
				$Rooms.add_child(wall_scene)
			
				
			
			
func toggle_hallway(coords:Vector3i):
	if coords in grid:
		pass
	else:
		grid[coords] = {type="floor"}
	
func set_hallway(coords:Vector3i):
	grid[coords] = {type="floor"}
	var hall_scene = load("res://game/blocks/hallway/hallway.tscn").instantiate()
	hall_scene.position = coords
	$Rooms.add_child(hall_scene)

func set_ramp(coords:Vector3i,direction:String):
	grid[coords] = {type="ramp",direction=direction}
	var ramp_scene = load("res://game/blocks/ramp/ramp.tscn").instantiate()
	ramp_scene.position = coords
	if direction == "north":
		pass
	elif direction == "east":
		ramp_scene.rotation.y = PI/2
	elif direction == "south":
		ramp_scene.rotation.y = PI
	elif direction == "west":
		ramp_scene.rotation.y = -PI/2
	$Rooms.add_child(ramp_scene)
	

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
	
	var tiles : Array[Vector3i] 
	for x in 15:
		for z in 15:
			tiles.append(Vector3i(x,0,z))
	var room_entity = Entity_Spawner.bunker_room(tiles,3)
	Game.current_room = room_entity
	
	var citizen_entity = await Entity_Spawner.citizen()
	var c_xform = Transform_Component.new()
	c_xform.set_position(1,0,1)
	citizen_entity.c_add(c_xform)
	
	var citizen_entity2 = await Entity_Spawner.citizen()
	c_xform = Transform_Component.new()
	c_xform.set_position(2,0,2)
	citizen_entity2.c_add(c_xform)
	
	var bed_entity = Entity_Spawner.space_bed_king()
	c_xform = Transform_Component.new()
	c_xform.set_position(5,0,7)
	bed_entity.c_add(c_xform)
	
	citizen_entity.c_get("Citizen").bed = bed_entity.id
	citizen_entity.c_get("Sleep_Need").value = 32
	
	citizen_entity2.c_get("Citizen").bed = bed_entity.id
	#set_hallway(Vector3i.ZERO)
	#set_hallway(Vector3i(1,0,1))
	#set_ramp(Vector3i(0,-1,1),TYPE.ramp_west)

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#var point = get_point_under_cursor()
		#print($GridMap.local_to_map(point))

func get_point_under_cursor() :
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return 

	var origin: Vector3 = camera.global_position     

	#Get a point projected away from the camera, offset by the cursor, extended to 1000 units
	var target: Vector3 = camera.project_ray_normal( get_viewport().get_mouse_position()) * 1000    

	#Perform a raycast across the 3D space    
	var ray_params := PhysicsRayQueryParameters3D.create(origin, target)    
	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)    

	#Try to get the position of the collision, if there was no collision, return Vector3.ZERO  
	var hit_position: Vector3 = ray_result.get("position", Vector3.ZERO)   

	return hit_position  

func build_cave():
	render_chunk(Vector3i(1,0,1))
	render_chunk(Vector3i(1,0,2))
	render_chunk(Vector3i(2,0,1))
	render_chunk(Vector3i(2,0,2))

func render_chunk(chunk_pos:Vector3i):
	var chunk_blocks = cave_gen.get_chunk(chunk_pos)
	var block_idx = 0
	var grid_map : GridMap = $Blocks_Gridmap
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
	

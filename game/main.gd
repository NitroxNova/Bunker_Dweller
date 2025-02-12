extends Node3D


var grid := {}
var rooms := []
var cave_gen = Cave_Generator.new()
var threads : Array[Thread] = []

#func _physics_process(delta: float) -> void:
	#if 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	World_Builder.initialize()
	for x in range(-1,1):
		for y in range(-1,1):
			for z in range(-1,1):
				World_Builder.build_world(Vector3i(x,y,z))
	Game.mode = Game.MODE_OPTIONS.place_ship
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Game.mode == Game.MODE_OPTIONS.place_ship:
			var point = get_point_under_cursor()
			Game.get_node("/root/Main/Target").position = point
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if Game.mode == Game.MODE_OPTIONS.place_ship:
			var point = get_point_under_cursor()
			var starter_ship : Entity = Entity_Spawner.starter_ship(point)
			starter_ship.rendered.connect(on_starter_ship_rendered.bind(starter_ship))
			#print($GridMap.local_to_map(point))
			Game.mode = Game.MODE_OPTIONS.live

func on_starter_ship_rendered(ship_entity:Entity):
	ship_entity.get_node().play_landing_sequence()
	#print("ship rendered")

func get_point_under_cursor() :
	var camera: Camera3D = get_node("Camera3D")
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
	

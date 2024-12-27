extends Node3D

enum TYPE {none,floor,ramp_north,ramp_east,ramp_south,ramp_west}

var grid := {}
var rooms := []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#print("zoom in")
			$Camera3D.position -= $Camera3D.basis.z.normalized() 
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#print("zoom out")
			$Camera3D.position += $Camera3D.basis.z.normalized() 
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			#print("middle mouse pressed")
			pass
	elif event is InputEventMouseMotion:
		if Input.is_action_pressed("MiddleMouse"):
			$Camera3D.rotation.y += event.relative.x * -.05
			$Camera3D.rotation.x += event.relative.y * -.05
			if $Camera3D.rotation.x > PI/2:
				$Camera3D.rotation.x = PI/2
			elif $Camera3D.rotation.x < -PI/2:
				$Camera3D.rotation.x = -PI/2
			

#func _physics_process(delta: float) -> void:
	#if 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_room(Vector3i(10,3,10),Vector3(-3,0,-3))
	#add_room(Vector3i(4,3,6),Vector3(-1,-2,0))
	var citizen_entity = Entity_Spawner.citizen()
	citizen_entity.c_add(Position_Component.new(0,1,0))
	var bed_entity = Entity_Spawner.bed()
	bed_entity.c_add(Position_Component.new(3,0,-1))
	#set_hallway(Vector3i.ZERO)
	#set_hallway(Vector3i(1,0,1))
	#set_ramp(Vector3i(0,-1,1),TYPE.ramp_west)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_room(dimensions:Vector3i,position:Vector3):
	for x in dimensions.x:
		for z in dimensions.z:
			var coords = Vector3i()
			coords.y = position.y
			coords.x = position.x + x
			coords.z = position.z + z
			grid[coords] = TYPE.floor
			var hall_scene = load("res://zone/hallway/hallway.tscn").instantiate()
			hall_scene.position = coords
			$Rooms.add_child(hall_scene)
			
			if z == 0:
				var wall_scene = load("res://zone/room/wall.tscn").instantiate()
				wall_scene.position = coords
				$Rooms.add_child(wall_scene)
			elif z==dimensions.z-1:
				var wall_scene = load("res://zone/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = PI
				$Rooms.add_child(wall_scene)
			
			if x == 0:
				var wall_scene = load("res://zone/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = PI/2
				$Rooms.add_child(wall_scene)
			elif x==dimensions.x-1:
				var wall_scene = load("res://zone/room/wall.tscn").instantiate()
				wall_scene.position = coords
				wall_scene.rotation.y = -PI/2
				$Rooms.add_child(wall_scene)
			
				
			
			
func toggle_hallway(coords:Vector3i):
	if coords in grid:
		pass
	else:
		grid[coords] = TYPE.floor
	
func set_hallway(coords:Vector3i):
	grid[coords] = TYPE.floor
	var hall_scene = load("res://zone/hallway/hallway.tscn").instantiate()
	hall_scene.position = coords
	$Rooms.add_child(hall_scene)

func set_ramp(coords:Vector3i,direction:int):
	grid[coords] = direction
	var ramp_scene = load("res://zone/ramp/ramp.tscn").instantiate()
	ramp_scene.position = coords
	if direction == TYPE.ramp_north:
		pass
	elif direction == TYPE.ramp_east:
		ramp_scene.rotation.y = PI/2
	elif direction == TYPE.ramp_south:
		ramp_scene.rotation.y = PI
	elif direction == TYPE.ramp_west:
		ramp_scene.rotation.y = -PI/2
	$Rooms.add_child(ramp_scene)
	

extends Camera3D

@export var human: Humanizer
@export_range(0.1, 1.) var look_speed: float = 0.4
@export_range(0.5, 5.) var move_speed: float = 1.

@onready var pitch: float = rotation.x
@onready var yaw: float = rotation.y
var simulating := false

func _ready():
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_key_pressed(KEY_W):
		position -= basis.z * move_speed * delta
	if Input.is_key_pressed(KEY_S):
		position += basis.z * move_speed * delta
	if Input.is_key_pressed(KEY_D):
		position += basis.x * move_speed * delta
	if Input.is_key_pressed(KEY_A):
		position -= basis.x * move_speed * delta
	if Input.is_key_pressed(KEY_Q):
		position -= basis.y * move_speed * delta
	if Input.is_key_pressed(KEY_E):
		position += basis.y * move_speed * delta
		

func _input(event):
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#print("zoom in")
			position -= basis.z.normalized() 
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#print("zoom out")
			position += basis.z.normalized()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			#print("middle mouse pressed")
			pass
	elif event is InputEventMouseMotion:
		if Input.is_action_pressed("MiddleMouse"):
			rotation.y += event.relative.x * -.05
			rotation.x += event.relative.y * -.05
			if rotation.x > PI/2:
				rotation.x = PI/2
			elif rotation.x < -PI/2:
				rotation.x = -PI/2

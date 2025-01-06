extends Node

var wall_gridmap : GridMap
var floor_gridmap : GridMap
var room_mode : Node3D
var current_room : Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wall_gridmap = get_node("/root/Main/Walls_GridMap")
	floor_gridmap = get_node("/root/Main/Floors_Gridmap")
	room_mode = get_node("/root/Main/Room_Mode")

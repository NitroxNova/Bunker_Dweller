extends Node

var wall_gridmap : GridMap
var floor_gridmap : GridMap
var blocks_gridmap : GridMap
var navigation_map : NavigationRegion3D
var room_mode : Node3D
enum MODE_OPTIONS {none,place_ship,live,build,new_room,edit_room}
var current_room : Entity
var seed : int = randi()

var mode = MODE_OPTIONS.none:
	set(value):
		#before setting value
		if mode == MODE_OPTIONS.place_ship:
			Game.get_node("/root/Main/Target").hide()
		mode = value
		if mode == MODE_OPTIONS.build:
			room_mode.show()
		elif mode == MODE_OPTIONS.new_room:
			room_mode.new_room()
		elif mode == MODE_OPTIONS.edit_room:
			room_mode.edit_room(current_room)
		elif mode == MODE_OPTIONS.place_ship:
			room_mode.hide()
			Game.get_node("/root/Main/Target").show()
		else:
			room_mode.hide()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wall_gridmap = get_node("/root/Main/Walls_GridMap")
	floor_gridmap = get_node("/root/Main/%Floors_Gridmap")
	room_mode = get_node("/root/Main/Room_Mode")
	blocks_gridmap = get_node("/root/Main/%Blocks_Gridmap")
	navigation_map = get_node("/root/Main/%Floors_Navigation")

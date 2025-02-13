extends Node

var wall_gridmap : GridMap
var floor_gridmap : GridMap
var blocks_gridmap : GridMap
var navigation_map : NavigationRegion3D
var room_mode : Node3D
var pause_menu : Control
enum MODE_OPTIONS {none,start_menu,pause,place_ship,live,build,new_room,edit_room}
var current_room : Entity
var seed : int 

var mode = MODE_OPTIONS.start_menu:
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
		elif mode==MODE_OPTIONS.pause:
			get_tree().paused = true
			pause_menu.show()
		elif mode==MODE_OPTIONS.start_menu:
			pause_menu.hide()
			get_tree().paused = false
			ECS.reset()
			get_tree().change_scene_to_file("res://menu/start/start_menu.tscn")
		elif mode==MODE_OPTIONS.live:
			pause_menu.hide()
			get_tree().paused = false
			
		

# Called when the node enters the scene tree for the first time.
func init_game_nodes() -> void:
	seed = randi()
	wall_gridmap = get_node("/root/Main/Walls_GridMap")
	floor_gridmap = get_node("/root/Main/%Floors_Gridmap")
	room_mode = get_node("/root/Main/Room_Mode")
	blocks_gridmap = get_node("/root/Main/%Blocks_Gridmap")
	navigation_map = get_node("/root/Main/%Floors_Navigation")
	pause_menu = get_node("/root/Main/%PauseMenu")

extends Node

var wall_gridmap : GridMap
var blocks_gridmap : GridMap
var navigation_map : NavigationRegion3D
var room_mode : Node3D
var pause_menu : Control
enum MODE_OPTIONS {none,start_menu,pause,place_ship,live,build,select_room,new_room,edit_room,place_doors,place_furniture,destroy_blocks}
enum WALL_OPTIONS {flat_white,flat_dark,corner_white,corner_dark,three_walls_white,three_walls_dark,single_door_bottom,single_door_top}
enum BLOCK_OPTIONS {rock,red_rock,scaffolding,white_floor,white_floor_line,white_floor_tab}

var current_room : Entity
var seed : int 

var mode = MODE_OPTIONS.start_menu:
	set(value):
		#before setting value
		if mode == MODE_OPTIONS.place_ship:
			Game.get_node("/root/Main/Target").hide()
		elif mode == MODE_OPTIONS.destroy_blocks:
			get_node("/root/Main/%Block_Selector").hide()
		elif mode in [MODE_OPTIONS.edit_room,MODE_OPTIONS.place_furniture]:
			room_mode.hide()
		mode = value
		if mode == MODE_OPTIONS.build:
			room_mode.show()
		elif  mode == MODE_OPTIONS.select_room:
			Game.get_node("/root/Main/GameOverlay/%RoomTypeOptions").hide()
			Game.get_node("/root/Main/GameOverlay/%RoomTypeLabel").hide()
			room_mode.show()
			room_mode.select_room()
		elif mode == MODE_OPTIONS.new_room:
			var type_options:OptionButton = Game.get_node("/root/Main/GameOverlay/%RoomTypeOptions")
			type_options.clear()
			for type in Room_Component.TYPE_OPTIONS.keys():
				type_options.add_item(type)	
			type_options.show()
			Game.get_node("/root/Main/GameOverlay/%RoomTypeLabel").show()
			room_mode.show()
			room_mode.new_room()
		elif mode == MODE_OPTIONS.edit_room:
			room_mode.show()
			room_mode.edit_room(current_room)
			Game.get_node("/root/Main/GameOverlay/%RoomOptionsButton").selected = 1
			var type_options:OptionButton = Game.get_node("/root/Main/GameOverlay/%RoomTypeOptions")
			type_options.clear()
			for type in Room_Component.TYPE_OPTIONS.keys():
				type_options.add_item(type)	
			var c_room :Room_Component = current_room.c_get("Room")
			type_options.selected = c_room.room_type
			type_options.show()
			Game.get_node("/root/Main/GameOverlay/%RoomTypeLabel").show()
		elif mode == MODE_OPTIONS.place_ship:
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
		elif mode == MODE_OPTIONS.destroy_blocks:
			var block_selector : MeshInstance3D = get_node("/root/Main/%Block_Selector")
			block_selector.get_surface_override_material(0).albedo_color = Color(1,0,0,.5)
			block_selector.show()
		elif mode == MODE_OPTIONS.place_furniture:
			#var furniture_type = get_node("/root/Main/GameOverlay/%RoomTypeOptions").get_selected_meta()
			var type_options:OptionButton = Game.get_node("/root/Main/GameOverlay/%RoomTypeOptions")
			type_options.clear()
			var c_room : Room_Component = current_room.c_get("Room")
			for f_name in c_room.get_furniture_options():
				type_options.add_item(f_name)	
			type_options.show()
			Game.get_node("/root/Main/GameOverlay/%RoomTypeLabel").show()
			room_mode.place_furniture()
			room_mode.show()
			
# Called when the node enters the scene tree for the first time.
func init_game_nodes() -> void:
	seed = randi()
	wall_gridmap = get_node("/root/Main/%Walls_GridMap")
	room_mode = get_node("/root/Main/Room_Mode")
	blocks_gridmap = get_node("/root/Main/%Blocks_Gridmap")
	navigation_map = get_node("/root/Main/%Floors_Navigation")
	pause_menu = get_node("/root/Main/%PauseMenu")

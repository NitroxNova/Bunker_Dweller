extends System
class_name Input_System

static func _on_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int, entity_id:int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			var target : Entity = ECS.get_player_selected()
			if target != null:
				target.c_remove("Player_Selected")
			target = ECS.get_entity(entity_id)
			target.c_add(Player_Selected_Component.new())
		
static func new_room_cell_clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int,coords:Vector3i):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var tiles : Array[Vector3i] = [Vector3i(coords)]
			var room = Entity_Spawner.bunker_room(tiles,3)
			Game.current_room = room
			Game.mode = Game.MODE_OPTIONS.edit_room

static func interior_room_cell_clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int,coords:Vector3i):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var c_room:Room_Component = Game.current_room.c_get("Room")
		Room_Builder.clear_room(Game.current_room)
		c_room.floor_tiles.erase(coords)
		Room_Builder.build(Game.current_room)
		Game.room_mode.edit_room(Game.current_room)

static func exterior_room_cell_clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int,coords:Vector3i):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var c_room:Room_Component = Game.current_room.c_get("Room")
		Room_Builder.clear_room(Game.current_room)
		c_room.floor_tiles.append(coords)
		Room_Builder.build(Game.current_room)
		Game.room_mode.edit_room(Game.current_room)

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
		

extends StaticBody3D

var is_landing:bool = false
var destination:float

func play_landing_sequence():
	destination = position.y
	position.y += 50
	is_landing = true
	
func _process(delta: float) -> void:
	if is_landing:
		var projected_position = position.y - delta * 10
		if projected_position < destination:
			position.y = destination
			is_landing = false
			spawn_settlers()
		else:
			position.y = projected_position

func spawn_settlers():
	Game.navigation_map.bake_navigation_mesh()
	for node in get_children():
		if node is Interaction_Point:
			Entity_Spawner.citizen(node.global_position)
		

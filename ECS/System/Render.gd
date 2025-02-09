extends System
class_name Render_System

# "rendering" is just adding an instance of the scene to the tree
static func run(delta):
	for entity_id in ECS.c_get("Needs_Render"):
		print("rendering " + str(entity_id))
		var entity :Entity = ECS.get_entity(entity_id)
		var c_needs_render :Needs_Render_Component = entity.c_get("Needs_Render")
		if entity.c_has("Room"):
			var c_room : Room_Component = entity.c_get("Room")
			var room_builder = Room_Builder.build(entity)
			
			Game.get_node("/root/Main/%Floors_Navigation").bake_navigation_mesh()
		else:	
			var c_transform : Transform_Component = entity.c_get("Transform")
			var c_node: Node_Component = entity.c_get("Node")
			var node:Node3D = c_node.node
			node.set_meta("entity_id",entity_id)
			node.input_event.connect(Input_System._on_body_3d_input_event.bind(entity_id))
			node.global_transform = c_transform.value
			if entity.c_has("Citizen"):
				var nav_agent = NavigationAgent3D.new()
				nav_agent.avoidance_enabled = true # not working?
				node.add_child(nav_agent,true)
			if node.has_node("NavigationObstacle3D"):
				#var c_nav_obs : Navigation_Obstacle_Component = entity.c_get("Navigation_Obstacle")
				var nav_obs = node.get_node("NavigationObstacle3D")
				node.remove_child(nav_obs)
				nav_obs.affect_navigation_mesh = true
				nav_obs.position = node.position
				Game.get_node("/root/Main/%Floors_Navigation").add_child(nav_obs)
				Game.get_node("/root/Main/%Floors_Navigation").bake_navigation_mesh()
				
			entity.c_add(Node_Component.new(node))
			ECS.spawn_entity_node(node)
		entity.c_remove("Needs_Render")
		

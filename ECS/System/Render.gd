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
		else:	
			var c_position : Position_Component = entity.c_get("Position")
			var c_node: Node_Component = entity.c_get("Node")
			var node:Node3D = c_node.node
			node.set_meta("entity_id",entity_id)
			node.input_event.connect(Input_System._on_body_3d_input_event.bind(entity_id))
			node.position.x = c_position.x
			node.position.y = c_position.y
			node.position.z = c_position.z
			entity.c_add(Node_Component.new(node))
			ECS.spawn_entity_node(node)
		entity.c_remove("Needs_Render")
		

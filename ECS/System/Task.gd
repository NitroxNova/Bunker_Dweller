extends System
class_name Task_System

static func run(delta:float):
	for entity_id in ECS.c_get("Task"):
		process_entity(entity_id,delta)

static func process_entity(entity_id:int,delta:float):
	var entity :Entity = ECS.get_entity(entity_id)
	var c_task :Task_Component = entity.c_get("Task")
	var c_node : Node_Component = entity.c_get("Node")
	var node :CharacterBody3D = c_node.node
	var animation_tree:AnimationTree = node.get_node("AnimationTree")
	var c_sleep_need : Sleep_Need_Component = entity.c_get("Sleep_Need")
	if c_task.queue.is_empty():
		if c_sleep_need.value < 30:
			c_task.go_to_sleep()
			return
		#if randi_range(0,1) == 0:
			#var map_id = NavigationServer3D.get_maps()[0]
			#var target_position = NavigationServer3D.map_get_random_point(map_id,1,false)
			#try_walk_to(target_position,entity)
			#return
		var idle_time = randf_range(3,10)
		c_task.stand_still(idle_time)
		return
	var current_task : Dictionary = c_task.queue[0]
	
	if current_task.name == "stand_still":
		node.moving = false
		current_task.time -= delta
		if current_task.time < 0:
			c_task.queue.pop_front()
			return
	elif current_task.name == "sleep":
		node.moving = false
		animation_tree.set("parameters/conditions/sit",true)
		animation_tree.set("parameters/conditions/stand",false)
		if c_sleep_need.value > 100:
			c_task.queue.pop_front() 
			c_task.queue.pop_front() #interact with
			animation_tree.set("parameters/conditions/sit",false)
			animation_tree.set("parameters/conditions/stand",true)
			return
	elif current_task.name == "go_to_sleep":
		var c_citizen : Citizen_Component = entity.c_get("Citizen")
		if c_sleep_need.value > 100:
			c_task.queue.pop_front() 
			return
		for interact_id in ECS.c_get("Interactable"):
			var interact_entity:Entity = ECS.get_entity(interact_id)
			var c_interact:Interactable_Component = interact_entity.c_get("Interactable")
			if c_interact.action_type in [Interaction_Point.TYPE.bed_left,Interaction_Point.TYPE.bed_right]:
				c_task.interact_with(interact_entity.id,"sleep")
		#var bed_id = c_citizen.bed
		#var bed_entity : Entity = ECS.get_entity(bed_id)
		#var interact : int = bed_entity.c_get("Interactions").list[0]
		#c_task.interact_with(interact,"sleep")
	elif current_task.name == "interact_with":
		var interact_task : Entity = ECS.get_entity(current_task.action_id)
		#var c_interactable : Interactable_Component = interact_task.c_get("Interactable")
		var c_xform : Transform_Component = interact_task.c_get("Transform")
		var interact_position = c_xform.get_position()
		var nav_agent : NavigationAgent3D = node.get_node("NavigationAgent3D")
		try_walk_to(interact_position,entity,true)
		if nav_agent.is_target_reached():
			c_task.queue.pop_front()
			node.moving = false
			c_task.call(current_task.action_name)
			return  
		
	elif current_task.name == "walk_to":
		var nav_agent : NavigationAgent3D = node.get_node("NavigationAgent3D")
		if nav_agent == null:
			print("nav agent is null")
			return #nav agent not loaded
		
		if nav_agent.is_target_reached():
			# walk_to complete
			c_task.queue.pop_front()
			node.moving = false
			return
			
			
		var prev_position :Vector3 = node.global_position
		var next_pos:Vector3 = nav_agent.get_next_path_position()
		
		if not nav_agent.is_target_reachable():
			print("cant reach target " + str(nav_agent.target_position))	
			var map_id =  NavigationServer3D.get_maps()[0]
			#node.global_position = NavigationServer3D.map_get_closest_point(map_id,node.global_position)	
			#nav_agent.target_position = NavigationServer3D.map_get_closest_point(map_id,nav_agent.target_position)
			next_pos = nav_agent.target_position
			#return 
		
		#previous distance
			
		
		var displacement : Vector3= next_pos - node.global_transform.origin
		var distance := displacement.length()	
		var direction := displacement / distance # With caveats, see below
		var max_speed := (distance / delta)
		node.velocity = direction * minf(node.move_speed, max_speed)
		node.transform.basis = Basis.looking_at(-direction)
		node.moving = true
		node.position += node.velocity*delta
		#node.move_and_slide()
		
		#if current_task.prev_position == node.global_position:
			##is stuck, teleport
			#print("is stuck")
			#node.global_position += node.velocity 
			#
		#else:
			#node.move_and_slide()
		##if stuck, will move forward and then back in the next frame
		#
		#current_task.prev_position = node.global_position
			

static func try_walk_to(target_position:Vector3,entity:Entity,force=false)->bool:
	var node = entity.get_node()
	var curr_position = node.global_position
	var nav_agent : NavigationAgent3D = node.get_node("NavigationAgent3D")
	if nav_agent == null:
		return false
	nav_agent.target_position = target_position
	if not nav_agent.is_target_reachable() and not force:
		nav_agent.target_position = curr_position
		return false
	var c_task :Task_Component = entity.c_get("Task")
	c_task.walk_to(target_position)
	return true
			

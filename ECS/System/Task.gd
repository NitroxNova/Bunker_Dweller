extends System
class_name Task_System

static func run(delta:float):
	for entity_id in ECS.c_get("Task"):
		process_entity(entity_id,delta)

static func process_entity(entity_id:int,delta:float):
	var entity :Entity = ECS.get_entity(entity_id)
	var c_task :Task_Component = entity.c_get("Task")
	var c_node : Node_Component = entity.c_get("Node")
	var c_sleep_need : Sleep_Need_Component = entity.c_get("Sleep_Need")
	if c_task.queue.is_empty():
		if c_sleep_need.value < 30:
			c_task.go_to_sleep()
			return
		if randi_range(0,1) == 0:
			var target_position = c_node.position 
			target_position.x += randi_range(-3,3)
			target_position.z += randi_range(-3,3)
			c_task.walk_to(target_position)
			return
		else:
			var idle_time = randf_range(3,10)
			c_task.stand_still(idle_time)
			return
	var current_task : Dictionary = c_task.queue[0]
	
	var node :CharacterBody3D = c_node.node
	if current_task.name == "stand_still":
		node.moving = false
		current_task.time -= delta
		if current_task.time < 0:
			c_task.queue.pop_front()
			return
	elif current_task.name == "sleep":
		node.moving = false
		if c_sleep_need.value > 100:
			c_task.queue.pop_front()
	elif current_task.name == "go_to_sleep":
		var c_citizen : Citizen_Component = entity.c_get("Citizen")
		var bed_id = c_citizen.bed
		var bed_entity : Entity = ECS.get_entity(bed_id)
		var bed_position = bed_entity.get_node().global_position
		if bed_position.distance_to(node.global_position) < 2:
			c_task.queue.pop_front()
			node.moving = false
			c_task.sleep()
			return
		c_task.walk_to(bed_position)
		return  
	elif current_task.name == "walk_to":
		var target : Vector3 = current_task.position
		var displacement := target - node.global_transform.origin
		var distance := displacement.length()
		if distance < .5:
			# walk_to complete
			c_task.queue.pop_front()
			node.moving = false
			return
		#previous distance
		if abs(current_task.prev_distance - distance) < .0000001:
			#cant reach, clear task
			c_task.queue.pop_front()
			node.moving = false
			return
		current_task.prev_distance = distance	
		var direction := displacement / distance # With caveats, see below
		var max_speed := (distance / delta)
		node.velocity = direction * minf(node.move_speed, max_speed)
		node.transform.basis = Basis.looking_at(-direction)
		node.moving = true
		node.move_and_slide()
		
		#print("walking to " + str(current_task[1]))
		

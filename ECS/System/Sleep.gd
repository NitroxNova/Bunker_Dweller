extends System
class_name Sleep_System

const sleep_decay = (100.0/(16 * 60 * 60)) #from full to zero in 16 hours

static func run(delta):
	for entity_id in ECS.c_get("Sleep_Need"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_sleep = entity.c_get("Sleep_Need")
		var c_task = entity.c_get("Task").queue
		if (not c_task.is_empty()) and c_task[0].name in ["sleep"]:
			c_sleep.value += delta * sleep_decay * 2 * ECS.time_modifier #8 hours to refill
		else:
			c_sleep.value -= delta * sleep_decay * ECS.time_modifier
		#c_sleep.value -= delta 

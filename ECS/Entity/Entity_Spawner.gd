extends Resource
class_name Entity_Spawner


static func citizen()->Entity:
	var entity :Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new("res://npc/citizen.tscn"))
	entity.c_add(Citizen_Component.new())
	entity.c_add(Task_Component.new())
	return entity
	
static func bed()->Entity:
	var entity: Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new("res://objects/bed/twin_bed.tscn"))
	return entity
	

extends Node

var entity_list := {}
var component_list := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for class_data in ProjectSettings.get_global_class_list():
		if class_data.base == "Component":
			var c_name = class_data.class.trim_suffix("_Component")
			component_list[c_name] = {}
	print("ECS Manager is ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Render_System.run()

func spawn_entity_node(node:Node3D):
	get_node("/root/Main/Entity").add_child(node)

func get_entity(id:int):
	return entity_list[id]

func new_entity():
	var id = randi()
	while id in entity_list:
		id = randi()
	var entity = Entity.new(id)
	entity_list[id] = entity
	return entity

func remove_entity(entity_id):
	var entity:Entity = get_entity(entity_id)
	for comp_name in entity.get_components():
		entity.c_remove(comp_name)
		entity_list.erase(entity_id)
	
func c_get(component_name:String):
	return component_list[component_name]	

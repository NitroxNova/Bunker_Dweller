extends Component
class_name Interactions_Component

var list : PackedInt64Array = [] #list of interaction entities

func _init(_list:Array):
	list = PackedInt64Array(_list) #can pass regular array

func add_interaction(entity_id:int):
	list.append(entity_id)

func get_interaction(idx:int)->Entity:
	var interact_id = list[idx]
	return ECS.get_entity(interact_id)

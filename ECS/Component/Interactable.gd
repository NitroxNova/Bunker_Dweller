extends Component
class_name Interactable_Component

var action_type : int
var object : int #entity id of the owner object
var user : int = -1 #entity id of the current user, or -1 if none

func _init(_object:int,_action_type:Interaction_Point.TYPE) -> void:
	object = _object
	action_type = _action_type #can pass in regular array

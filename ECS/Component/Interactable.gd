extends Component
class_name Interactable_Component

var actions : PackedStringArray
var object : int #entity id of the owner object

func _init(_object:int,_actions:Array) -> void:
	object = _object
	actions = PackedStringArray(_actions) #can pass in regular array

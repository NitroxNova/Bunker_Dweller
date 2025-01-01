extends Component
class_name NPC_Name_Component

var first : String
var last : String

func _init(_first:String,_last:String):
	first = _first
	last = _last

func get_display():
	return first + " " + last

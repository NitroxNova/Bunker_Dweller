extends Component
class_name Navigation_Obstacle_Component

var vertices : PackedVector3Array
var height : float

func _init(_vertices:Array,_height:float) -> void:
	height = _height
	vertices = PackedVector3Array(_vertices)
	

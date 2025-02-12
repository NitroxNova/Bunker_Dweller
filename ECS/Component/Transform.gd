extends Component
class_name Transform_Component

var value : Transform3D

func set_position(position:Vector3):
	value.origin = position

func get_position():
	return value.origin

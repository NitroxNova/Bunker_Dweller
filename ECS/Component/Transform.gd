extends Component
class_name Transform_Component

var value : Transform3D

func set_position(x:float,y:float,z:float):
	value.origin = Vector3(x,y,z)

func get_position():
	return value.origin

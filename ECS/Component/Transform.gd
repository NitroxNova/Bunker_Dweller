extends Component
class_name Transform_Component

var value : Transform3D

func _init(_transform:Transform3D=Transform3D.IDENTITY):
	value = _transform

func set_position(position:Vector3):
	value.origin = position

func get_position():
	return value.origin

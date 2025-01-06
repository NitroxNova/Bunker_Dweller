extends Component
class_name Room_Component

var floor_tiles : Array[Vector3i]
var height : int 

func _init(_tiles:Array[Vector3i],_height:int):
	floor_tiles = _tiles
	height = _height

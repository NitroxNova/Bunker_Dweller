extends Component
class_name Room_Component

var floor_tiles : Array[Vector2i]
var y_axis : int
var height : int 
var doors: Array[Vector2i] 
var room_type : int

enum TYPE_OPTIONS {airlock}

func _init(_tiles:Array[Vector2i],_y_axis:int,_height:int,_doors:Array[Vector2i],_room_type:int):
	y_axis = _y_axis
	floor_tiles = _tiles
	height = _height
	doors = _doors
	room_type = _room_type

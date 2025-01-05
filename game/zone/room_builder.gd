extends Resource
class_name Room_Builder

var walls_gridmap : GridMap
var floor_gridmap : GridMap

func add_room(dimensions:Vector3i,position:Vector3,doors=[]):
	for x in dimensions.x:
		for z in dimensions.z:
			var coords = Vector3i()
			coords.y = position.y
			coords.x = position.x + x
			coords.z = position.z + z
			if x%4 == 0:
				if z%3==0:
					floor_gridmap.set_cell_item(coords,2,0)
				else:
					floor_gridmap.set_cell_item(coords,1,0)
			else:
				floor_gridmap.set_cell_item(coords,0,0)
			
			if Vector2(x,z) in doors:
				continue
			
			if z==0 and x == 0:
				walls_gridmap.set_cell_item(coords,2,0)
			
			elif z==0 and x == dimensions.x-1:
				walls_gridmap.set_cell_item(coords,2,22)
			
			elif z==dimensions.z-1 and x == 0:
				walls_gridmap.set_cell_item(coords,2,16)
			
			elif z==dimensions.z-1 and x == dimensions.x-1:
				walls_gridmap.set_cell_item(coords,2,10)	
			
			elif z == 0:
				if x % 3 == 1:
					walls_gridmap.set_cell_item(coords,0,22)
				else:
					walls_gridmap.set_cell_item(coords,1,22)
				
			elif z==dimensions.z-1:
				if x % 3 == 1:
					walls_gridmap.set_cell_item(coords,0,16)
				else:
					walls_gridmap.set_cell_item(coords,1,16)
			
			elif x == 0:
				if z % 3 == 1:
					walls_gridmap.set_cell_item(coords,0,0)
				else:
					walls_gridmap.set_cell_item(coords,1,0)

			elif x==dimensions.x-1:
				if z % 3 == 1:
					walls_gridmap.set_cell_item(coords,0,10)
				else:
					walls_gridmap.set_cell_item(coords,1,10)

			
				

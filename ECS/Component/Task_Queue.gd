extends Component
class_name Task_Component

var queue = []

func walk_to(position:Vector3):
	queue.push_front({name="walk_to",
		position=position,
		prev_distance=-1})

func stand_still(time:float):
	queue.push_front({name="stand_still",
		time=time})

func sleep():
	queue.push_front({name="sleep"})

func go_to_sleep():
	queue.push_front({name="go_to_sleep"})

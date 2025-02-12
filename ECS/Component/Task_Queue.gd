extends Component
class_name Task_Component

var queue = []

func walk_to(position:Vector3):
	queue.push_front({name="walk_to",
		prev_position=Vector3.ZERO})

func stand_still(time:float):
	queue.push_front({name="stand_still",
		time=time})

func sleep():
	queue.push_front({name="sleep"})

func go_to_sleep():
	queue.push_front({name="go_to_sleep"})

func interact_with(action_id:int,action_name:String): #action_id is the entity id of the interact point
	queue.push_front({name="interact_with",action_id=action_id,action_name=action_name})
	

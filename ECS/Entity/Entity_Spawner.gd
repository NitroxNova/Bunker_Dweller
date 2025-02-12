extends Resource
class_name Entity_Spawner

const STONE_BLOCK = preload("res://game/blocks/stone/stone_block.tscn")

static func citizen(position:Vector3)->Entity:
	var entity :Entity = ECS.new_entity()
	var human_config = HumanConfig.new()
	human_config.rig = ProjectSettings.get_setting("addons/humanizer/default_skeleton")
	human_config.add_equipment(HumanizerEquipment.new("RightEye-LowPolyEyeball"))
	human_config.add_equipment(HumanizerEquipment.new("LeftEye-LowPolyEyeball"))
	var c_name = NPC_Name_Component.new("",Name_Generator.random_last())
	var gender = randi_range(0,1)
	human_config.targets["gender"] = gender
	if gender == 0:
		human_config.add_equipment(HumanizerEquipment.new("Body-Default","young_caucasian_female_special_suit"))
		c_name.first = Name_Generator.random_female()
	elif gender == 1:
		human_config.add_equipment(HumanizerEquipment.new("Body-Default","young_caucasian_male_special_suit"))
		c_name.first = Name_Generator.random_male()
	human_config.init_macros()	
	var humanizer = Humanizer.new()
	humanizer.load_config_async(human_config)
	await humanizer.done_generating_materials
	var human_scene = humanizer.get_CharacterBody3D(false)
	human_scene.camera = ECS.get_node("/root/Main/Camera3D")
	var animation_player:AnimationPlayer = human_scene.get_node("AnimationTree/AnimationPlayer")
	animation_player.add_animation_library("custom",load("res://humanizer_assets/animations/Output/animations.res"))
	#print(animation_player.get_animation_list())
	entity.c_add(Needs_Render_Component.new())
	entity.c_add(Node_Component.new(human_scene))
	entity.c_add(Citizen_Component.new())
	entity.c_add(c_name)
	entity.c_add(Task_Component.new())
	entity.c_add(Sleep_Need_Component.new())
	var x_form = Transform_Component.new()
	x_form.set_position(position)
	entity.c_add(x_form)
	return entity
	
static func bed()->Entity:
	var entity: Entity = ECS.new_entity()
	var bed_scene = load("res://game/objects/bed/twin_bed.tscn").instantiate()
	entity.c_add(Needs_Render_Component.new())
	entity.c_add(Node_Component.new(bed_scene))
	return entity

static func space_bed_king()->Entity:
	var entity: Entity = ECS.new_entity()
	var bed_scene = load("res://game/objects/bed/space_bed_king.tscn").instantiate()
	entity.c_add(Needs_Render_Component.new())
	entity.c_add(Node_Component.new(bed_scene))
	#entity.c_add(Navigation_Obstacle_Component.new())
	var left_interact = ECS.new_entity()
	var l_xform = Transform_Component.new()
	l_xform.set_position(Vector3(1,0,1))
	left_interact.c_add(l_xform)
	left_interact.c_add(Interactable_Component.new(entity.id,["sit","sleep"]))
	
	var c_interact = Interactions_Component.new([left_interact.id])
	#c_interact.add_interaction(Vector3(1,0,1),Vector3.LEFT,["sit","sleep"])
	entity.c_add(c_interact)
	return entity
	
		
static func stone_block()->Entity:
	var entity: Entity = ECS.new_entity()
	var block_scene = STONE_BLOCK.instantiate()
	entity.c_add(Needs_Render_Component.new())
	entity.c_add(Node_Component.new(block_scene))
	return entity

static func bunker_room(_tiles:Array[Vector3i],_height:int)->Entity:
	var entity: Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new())
	var c_room = Room_Component.new(_tiles,_height)
	entity.c_add(c_room)	
	return entity

static func starter_ship(position:Vector3)->Entity:
	var entity: Entity = ECS.new_entity()
	var ship_scene = load("res://game/objects/starter_ship/starter_ship.tscn").instantiate()
	entity.c_add(Needs_Render_Component.new())
	entity.c_add(Node_Component.new(ship_scene))
	var x_form = Transform_Component.new()
	x_form.set_position(position)
	entity.c_add(x_form)
	return entity
	

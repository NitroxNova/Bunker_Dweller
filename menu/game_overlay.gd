extends Control
var current_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_selected_overlay()
	current_time += delta * ECS.time_modifier
	$TopBar/Date_Time.text = Time.get_datetime_string_from_unix_time(current_time)

func update_selected_overlay():
	var selected = ECS.get_player_selected()
	if selected == null:
		$Selected.hide()
		return
	if selected.c_get("Task").queue.is_empty(): 
		$Selected/Panel/Task.text = ""
	else:
		$Selected/Panel/Task.text = selected.c_get("Task").queue[0].name
	$Selected/Panel/Display_Name.text = selected.c_get("NPC_Name").get_display()
	$Selected/Panel/Sleep_Need/ProgressBar.value = selected.c_get("Sleep_Need").value
	$Selected.show()
		

func _on_slower_pressed() -> void:
	Engine.time_scale /= 2
	$TopBar/Speed_Label.text = str(Engine.time_scale)+"x"


func _on_faster_pressed() -> void:
	Engine.time_scale *= 2
	$TopBar/Speed_Label.text = str(Engine.time_scale)+"x"

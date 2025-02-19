extends Control
var current_time = 0

func _ready():
	$%RoomModeBar.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_selected_overlay()
	current_time += delta * ECS.time_modifier
	%TopBar/Date_Time.text = Time.get_datetime_string_from_unix_time(current_time)

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
	%TopBar/Speed_Label.text = str(Engine.time_scale)+"x"


func _on_faster_pressed() -> void:
	Engine.time_scale *= 2
	%TopBar/Speed_Label.text = str(Engine.time_scale)+"x"

func _on_mode_button_item_selected(index: int) -> void:
	var button_text = %ModeButton.get_item_text(index)
	if button_text == "Live Mode":
		Game.mode = Game.MODE_OPTIONS.live
		%RoomModeBar.hide()
	elif button_text == "Room Mode":
		Game.mode = Game.MODE_OPTIONS.edit_room
		%RoomModeBar.show()
	elif button_text == "Block Mode":
		Game.mode = Game.MODE_OPTIONS.destroy_blocks
		%RoomModeBar.hide()

func _on_room_options_button_item_selected(index: int) -> void:
	var button_text = %RoomOptionsButton.get_item_text(index)
	if button_text == "New Room":
		Game.mode = Game.MODE_OPTIONS.new_room
	elif button_text == "Place Doors":
		Game.mode = Game.MODE_OPTIONS.place_doors
	elif button_text == "Edit Room":
		Game.mode = Game.MODE_OPTIONS.edit_room
	elif button_text == "Select Room":
		Game.mode = Game.MODE_OPTIONS.select_room
	elif button_text == "Furniture":
		Game.mode = Game.MODE_OPTIONS.place_furniture
		
func _on_room_type_options_item_selected(index: int) -> void:
	if Game.mode == Game.MODE_OPTIONS.edit_room:
		var c_room:Room_Component = Game.current_room.c_get("Room")
		c_room.room_type = index
	elif Game.mode == Game.MODE_OPTIONS.place_furniture:
		Game.room_mode.place_furniture()
		

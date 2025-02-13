extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	Game.mode = Game.MODE_OPTIONS.live

func _on_main_menu_button_pressed() -> void:
	Game.mode = Game.MODE_OPTIONS.start_menu

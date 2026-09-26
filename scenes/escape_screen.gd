extends Control
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog"):
		get_tree().paused = false
		queue_free()

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	get_tree().paused = false
	match item.name:
		"BackToGame":
			get_tree().paused = false
		"Restart":
			get_tree().reload_current_scene()
		"Quit":
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

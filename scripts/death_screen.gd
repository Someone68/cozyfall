extends Control

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"TryAgain":
			_on_try_again_pressed()
		"Quit":
			_on_quit_pressed()

func _on_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

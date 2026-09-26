extends Control

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	get_tree().paused = false
	match item.name:
		"TryAgain":
			get_tree().reload_current_scene()
		"Quit":
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

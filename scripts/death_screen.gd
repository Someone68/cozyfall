extends Control

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	if (item.name == "TryAgain"):
		get_tree().reload_current_scene()
	if (item.name == "Quit"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

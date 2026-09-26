extends MarginContainer

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"Start":
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		"Quit":
			get_tree().quit()

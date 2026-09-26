extends MarginContainer

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"Start":
			Gamemgr.load_current_level()
		"Quit":
			get_tree().quit()

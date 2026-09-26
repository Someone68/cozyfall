extends MarginContainer

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"Start":
			_on_start_pressed()
		"Quit":
			_on_quit_pressed()


func _on_start_pressed() -> void:
	Gamemgr.load_current_level()


func _on_quit_pressed() -> void:
	get_tree().quit()

extends MarginContainer

func _ready() -> void:
	if (Settings.level == 1):
		$VBoxContainer/MarginContainer/SelectMenu/Continue.visible = false
		$VBoxContainer/MarginContainer/SelectMenu.refresh()

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"Continue":
			_on_continue_pressed()
		"NewGame":
			_on_start_pressed()
		"Quit":
			_on_quit_pressed()


func _on_start_pressed() -> void:
	Settings.level = 1
	Settings.save()
	Gamemgr.load_current_level()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	Gamemgr.load_current_level()

extends Control

var is_child := false

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	match item.name:
		"Music":
			_on_music_pressed()
		"Sfx":
			_on_sfx_pressed()
		"Credits":
			_on_credits_pressed()
		"GoBack":
			_on_go_back_pressed()

func _on_music_pressed() -> void:
	Settings.music = not Settings.music
	$VBoxContainer/SelectMenu/Music.text = "music:  on" if Settings.music else "music:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_sfx_pressed() -> void:
	Settings.sfx = not Settings.sfx
	$VBoxContainer/SelectMenu/Sfx.text = "sfx:  on" if Settings.sfx else "sfx:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_credits_pressed() -> void:
	pass # Replace with function body.
	
func _on_go_back_pressed() -> void:
	if is_child:
		get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
		queue_free()
	else:
		Gamemgr.back_to_menu()

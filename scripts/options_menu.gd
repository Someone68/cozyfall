extends Control

var is_child := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog"):
		_on_go_back_pressed()

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	match item.name:
		"Music":
			_on_music_pressed()
		"Sfx":
			_on_sfx_pressed()
		"Fullscreen":
			_on_fullscreen_pressed()
		"Credits":
			_on_credits_pressed()
		"GoBack":
			_on_go_back_pressed()

func _ready() -> void:
	$VBoxContainer/SelectMenu/Music.text = "music:  on" if Settings.music else "music:  off"
	$VBoxContainer/SelectMenu/Sfx.text = "sfx:  on" if Settings.sfx else "sfx:  off"
	$VBoxContainer/SelectMenu/Fullscreen.text = "fullscreen:  on" if Settings.fullscreen else "fullscreen:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_music_pressed() -> void:
	Settings.music = not Settings.music
	Settings.save()
	$VBoxContainer/SelectMenu/Music.text = "music:  on" if Settings.music else "music:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_sfx_pressed() -> void:
	Settings.sfx = not Settings.sfx
	Settings.save()
	$VBoxContainer/SelectMenu/Sfx.text = "sfx:  on" if Settings.sfx else "sfx:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_fullscreen_pressed() -> void:
	Settings.fullscreen = not Settings.fullscreen
	Settings.save()
	Fullscreen.set_fullscreen(Settings.fullscreen)
	$VBoxContainer/SelectMenu/Fullscreen.text = "fullscreen:  on" if Settings.fullscreen else "fullscreen:  off"
	$VBoxContainer/SelectMenu.refresh()

func _on_credits_pressed() -> void:
	Gamemgr.go_to_credits()
	
func _on_go_back_pressed() -> void:
	if is_child:
		get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
		queue_free()
	else:
		Gamemgr.back_to_menu()

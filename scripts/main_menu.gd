extends Control

@export var WARN_SCREEN: PackedScene

func _ready() -> void:
	if Settings.level == 1:
		$MainMenu/VBoxContainer/SelectMenu/Continue.visible = false
		$MainMenu/VBoxContainer/SelectMenu.refresh()

func show_warning(action: String) -> void:
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	var loaded_warn_screen = WARN_SCREEN.instantiate()
	loaded_warn_screen.warning_action = action
	loaded_warn_screen.warning_text = """You will lose all
	your progress!"""
	add_child(loaded_warn_screen)

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"Continue":
			_on_continue_pressed()
		"NewGame":
			_on_start_pressed()
		"Quit":
			_on_quit_pressed()

func _on_start_pressed() -> void:
	if Settings.level == 1:
		Settings.level = 1
		Settings.save()
		Gamemgr.load_current_level()
	else:
		show_warning("newgame")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_continue_pressed() -> void:
	Gamemgr.load_current_level()

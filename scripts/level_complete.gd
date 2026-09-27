extends Control

@export var WARN_SCREEN : PackedScene

func fade_in():
	$VBoxContainer/VBoxContainer/StageCompletedText.text = "stage %s completed" % str(Settings.level-1)
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(self, "modulate:a", 1, 0.5)

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	if (index == 0):
		get_tree().paused = false
		Gamemgr.load_current_level()
	elif (index == 1):
		show_warning("restart")
	else:
		get_tree().paused = false
		Gamemgr.back_to_menu()

func show_warning(action: String) -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	var loaded_warn_screen = WARN_SCREEN.instantiate()
	loaded_warn_screen.warning_action = action
	add_child(loaded_warn_screen)

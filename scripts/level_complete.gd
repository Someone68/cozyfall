extends Control

func fade_in():
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(self, "modulate:a", 1, 0.5)

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	get_tree().paused = false
	if (index == 0):
		Gamemgr.next_level()
	elif (index == 1):
		get_tree().reload_current_scene()
	else:
		Gamemgr.back_to_menu()

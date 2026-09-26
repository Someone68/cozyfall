extends Control

var warning_action: String

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	match item.name:
		"Continue":
			get_tree().paused = false
			match warning_action:
				"restart":
					get_tree().reload_current_scene()
				"quit":
					get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		"GoBack":
			queue_free()

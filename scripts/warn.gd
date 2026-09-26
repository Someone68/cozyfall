extends Control

var warning_action: String

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	match item.name:
		"Continue":
			_on_continue_pressed()
		"GoBack":
			_on_go_back_pressed()

func _on_continue_pressed() -> void:
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	match warning_action:
		"restart":
			get_tree().reload_current_scene()
		"quit":
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_go_back_pressed() -> void:
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	queue_free()

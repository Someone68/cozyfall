extends Control

@export var WARN_SCREEN : PackedScene


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog"):
		get_tree().paused = false
		queue_free()

func show_warning(action: String) -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	var loaded_warn_screen = WARN_SCREEN.instantiate()
	loaded_warn_screen.warning_action = action
	add_child(loaded_warn_screen)

func _on_select_menu_item_selected(_index: int, item: Control) -> void:
	match item.name:
		"BackToGame":
			queue_free()
			get_tree().paused = false
		"Restart":
			show_warning("restart")
		"Quit":
			show_warning("quit")

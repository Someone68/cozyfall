extends Control

var warning_action: String
var warning_text := """You will lose your
progress for this level!"""

func _ready() -> void:
	$MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/WarningInfo.text = warning_text

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
		"newgame":
			Settings.level = 1
			Settings.save()
			Gamemgr.load_current_level()

func _on_go_back_pressed() -> void:
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	queue_free()

extends Node

const levels := [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
]

var current_level := 1

func load_current_level():
	if (current_level <= len(levels)):
		get_tree().change_scene_to_file(levels[current_level-1])

func next_level() -> bool:
	current_level += 1
	if (current_level <= len(levels)):
		load_current_level()
		return true
	else: return false

func get_amount_levels() -> int:
	return len(levels)

func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

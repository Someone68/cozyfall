extends Node

const levels := [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn",
	"res://scenes/levels/level4.tscn",
	"res://scenes/levels/level5.tscn",
	"res://scenes/levels/level6.tscn",
	"res://scenes/levels/level7.tscn",
	"res://scenes/levels/level8.tscn"
]

func load_current_level():
	Settings.level = clampi(Settings.level, 1, len(levels))
	get_tree().change_scene_to_file(levels[Settings.level-1])

func next_level() -> bool:
	Settings.level += 1
	Settings.save()
	if (Settings.level <= len(levels)):
		load_current_level()
		return true
	else: return false

func get_amount_levels() -> int:
	return len(levels)

func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

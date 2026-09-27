extends Node

const levels := [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn",
	"res://scenes/levels/level4.tscn",
	"res://scenes/levels/level4_1.tscn",
	"res://scenes/levels/level5.tscn",
	"res://scenes/levels/level6.tscn",
	"res://scenes/levels/level7.tscn",
	"res://scenes/levels/level7_1.tscn",
	"res://scenes/levels/level8.tscn",
	"res://scenes/levels/end.tscn"
]

func load_current_level():
	Settings.level = clampi(Settings.level, 1, len(levels))
	change_scene(levels[Settings.level-1])

func next_level() -> bool:
	Settings.level += 1
	Settings.save()
	if (Settings.level <= len(levels)):
		load_current_level()
		return true
	else: return false

func go_to_credits():
	change_scene("res://scenes/credits_screen.tscn")

func get_amount_levels() -> int:
	return len(levels)

func back_to_menu():
	change_scene("res://scenes/main_menu.tscn")

func to_options():
	change_scene("res://scenes/options_menu.tscn")

func change_scene(path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(path)

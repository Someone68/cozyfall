extends Node

const PATH := "user://settings.cfg"

var level := 1

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) == OK:
		level = cfg.get_value("progress", "level", level)

func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "level", level)
	cfg.save(PATH)

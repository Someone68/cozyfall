extends Node

const PATH := "user://settings.cfg"

var level := 1

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) == OK:
		level = int(cfg.get_value("progress", "level", level))

func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "level", level)
	var err := cfg.save(PATH)
	if err != OK:
		push_error("failed to save settings to %s: %s" % [PATH, error_string(err)])

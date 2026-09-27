extends Node

const PATH := "user://settings.cfg"

var level := 1
var music := true
var sfx := true

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) == OK:
		level = int(cfg.get_value("progress", "level", level))
		music = bool(cfg.get_value("settings", "music", music))
		sfx = bool(cfg.get_value("settings", "sfx", music))

func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "level", level)
	cfg.set_value("settings", "music", music)
	cfg.set_value("settings", "sfx", sfx)
	var err := cfg.save(PATH)
	if err != OK:
		push_error("failed to save settings to %s: %s" % [PATH, error_string(err)])

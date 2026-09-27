extends Node

const PATH := "user://settings.cfg"

const SFX_BUS := "SFX"

var level := 1
var music := true
var sfx := true:
	set(value):
		sfx = value
		_apply_sfx()

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) == OK:
		level = int(cfg.get_value("progress", "level", level))
		music = bool(cfg.get_value("settings", "music", music))
		sfx = bool(cfg.get_value("settings", "sfx", sfx))

func _apply_sfx() -> void:
	var idx := AudioServer.get_bus_index(SFX_BUS)
	if idx != -1:
		AudioServer.set_bus_mute(idx, not sfx)

func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "level", level)
	cfg.set_value("settings", "music", music)
	cfg.set_value("settings", "sfx", sfx)
	var err := cfg.save(PATH)
	if err != OK:
		push_error("failed to save settings to %s: %s" % [PATH, error_string(err)])

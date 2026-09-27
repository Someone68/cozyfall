extends AudioStreamPlayer

const MENU_SCENE := "res://scenes/main_menu.tscn"
const CREDITS_SCREEN := "res://scenes/credits_screen.tscn"
const OPTIONS_MENU := "res://scenes/options_menu.tscn"
const END := "res://scenes/levels/end.tscn"

const MUSIC_BUS := "Music"
const MUFFLE_SCREENS := ["EscapeScreen", "DeathScreen", "LevelComplete"]

var started := false
var _bus_idx := -1
var _lowpass_idx := -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	finished.connect(func(): started = false)
	_bus_idx = AudioServer.get_bus_index(MUSIC_BUS)
	if _bus_idx != -1:
		for i in AudioServer.get_bus_effect_count(_bus_idx):
			if AudioServer.get_bus_effect(_bus_idx, i) is AudioEffectLowPassFilter:
				_lowpass_idx = i
				break

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	var muffle := false
	for screen in MUFFLE_SCREENS:
		if scene.has_node(screen):
			muffle = true
			break
	var should_pause := (get_tree().paused and not muffle) \
		or scene.scene_file_path in [MENU_SCENE, CREDITS_SCREEN, OPTIONS_MENU, END] \
		or not Settings.music
	_set_muffled(muffle and not should_pause)
	if should_pause:
		if not stream_paused:
			stream_paused = true
		return
	if not started:
		play()
		started = true
	if stream_paused:
		stream_paused = false

func _set_muffled(on: bool) -> void:
	if _bus_idx == -1 or _lowpass_idx == -1: return
	if AudioServer.is_bus_effect_enabled(_bus_idx, _lowpass_idx) != on:
		AudioServer.set_bus_effect_enabled(_bus_idx, _lowpass_idx, on)

extends AudioStreamPlayer

const MENU_SCENE := "res://scenes/main_menu.tscn"
const CREDITS_SCREEN := "res://scenes/credits_screen.tscn"
const OPTIONS_MENU := "res://scenes/options_menu.tscn"
const END := "res://scenes/levels/end.tscn"

var started := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	finished.connect(func(): started = false)

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	var should_pause := get_tree().paused \
		or scene.scene_file_path in [MENU_SCENE, CREDITS_SCREEN, OPTIONS_MENU, END] \
		or not Settings.music
	if should_pause:
		if not stream_paused:
			stream_paused = true
		return
	if not started:
		play()
		started = true
	if stream_paused:
		stream_paused = false

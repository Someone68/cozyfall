extends AudioStreamPlayer

const MENU_SCENE := "res://scenes/main_menu.tscn"
const CREDITS_SCREEN := "res://scenes/credits_screen.tscn"
const OPTIONS_MENU := "res://scenes/options_menu.tscn"

var started := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	finished.connect(func(): started = false)

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	if get_tree().paused or scene.scene_file_path == MENU_SCENE or scene.scene_file_path == CREDITS_SCREEN or scene.scene_file_path == OPTIONS_MENU or not Settings.music:
		stream_paused = true
		return
	if not started:
		play()
		started = true
	stream_paused = false

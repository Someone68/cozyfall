extends AudioStreamPlayer

const MENU_SCENE := "res://scenes/main_menu.tscn"

var started := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	finished.connect(func(): started = false)

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	if get_tree().paused or scene.scene_file_path == MENU_SCENE:
		stream_paused = true
		return
	if not started:
		play()
		started = true
	stream_paused = false

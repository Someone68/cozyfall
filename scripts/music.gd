extends AudioStreamPlayer

const MENU_SCENE := "res://scenes/main_menu.tscn"
const RETRY_DELAY := 1.0

var retry_left := 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# the track has to loop in the stream itself - restarting it from script
	# spams play() on web, where the first play() is blocked until the player
	# clicks and playback reports as finished right away
	if stream is AudioStreamWAV and stream.loop_mode == AudioStreamWAV.LOOP_DISABLED:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD

func _process(delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	if get_tree().paused or scene.scene_file_path == MENU_SCENE:
		if not stream_paused: stream_paused = true
		return
	if stream_paused: stream_paused = false
	if playing:
		retry_left = 0.0
		return
	# never started, or playback died - retry slowly instead of every frame
	retry_left -= delta
	if retry_left <= 0.0:
		retry_left = RETRY_DELAY
		play()

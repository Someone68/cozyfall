extends Node

func _ready() -> void:
	set_fullscreen(Settings.fullscreen)

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()

func set_fullscreen(fullscreen : bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func toggle_fullscreen():
	Settings.fullscreen = not Settings.fullscreen
	Settings.save()
	set_fullscreen(Settings.fullscreen)

extends Node

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()

func set_fullscreen(fullscreen : bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		set_fullscreen(false)
	else:
		set_fullscreen(true)

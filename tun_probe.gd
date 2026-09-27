extends Node

func run(level_path: String) -> void:
	var lvl = load(level_path).instantiate()
	get_tree().root.add_child(lvl)
	get_tree().current_scene = lvl
	for i in 10: await get_tree().process_frame
	var p = lvl.get_node("Player")
	var f = lvl.floors.get(p.grid_pos)
	print("%s: tunnel_enabled=%s grid=%s floor=%s tunnelable=%s" % [
		level_path.get_file(), lvl.TUNNELING_ENABLED, p.grid_pos, (f.get_script().resource_path.get_file() if f and f.get_script() else "<none>"), lvl.is_tunnelable(p.grid_pos)])
	var start = p.grid_pos
	var ev := InputEventKey.new()
	ev.physical_keycode = KEY_Z
	ev.keycode = KEY_Z
	ev.pressed = true
	Input.parse_input_event(ev)
	for i in 5: await get_tree().process_frame
	print("   after Z: buffered=%s tunneling=%s grid=%s anim=%s" % [p.buffered_action, p.tunneling, p.grid_pos, p.get_node("AnimatedSprite2D").animation])
	await get_tree().create_timer(3.0).timeout
	print("   3s later: tunneling=%s grid=%s (moved=%s)" % [p.tunneling, p.grid_pos, p.grid_pos != start])
	lvl.queue_free()
	for i in 3: await get_tree().process_frame

func _ready() -> void:
	await get_tree().process_frame
	for n in range(1, 9):
		await run("res://scenes/levels/level%d.tscn" % n)
	get_tree().quit()

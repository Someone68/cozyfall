extends Node2D
const SIZE := Vector2i(12, 12)
const TILE := 8
const MAX_TEMP := 8
const ADJ_DIRS := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
@export var DEATH_SCREEN : PackedScene
@export var WIN_SCREEN : PackedScene
@export var ESCAPE_SCREEN : PackedScene
@export var TUNNELING_ENABLED := true
@export var TEMPERATURE_ENABLED := true

@onready var walls := $Walls
@onready var player := $Player
@onready var hard_walls := $BrickWalls

var solids := {}
var floors := {}
var bonfires := {}
var on_bonfire := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog") and !has_node("EscapeScreen") and !has_node("DeathScreen"):
		var loaded_escape_screen = ESCAPE_SCREEN.instantiate()
		add_child(loaded_escape_screen)
		get_tree().paused = true

func tile_temp_cost(pos: Vector2i) -> int:
	var f = floors.get(pos)
	if f and "temp_cost" in f: return f.temp_cost
	return 1

func is_tunnelable(pos: Vector2i) -> bool:
	if (!TUNNELING_ENABLED): return false
	var f = floors.get(pos)
	return not (f and "no_tunnel" in f and f.no_tunnel)

func death():
	var loaded_death_screen = DEATH_SCREEN.instantiate()
	add_child(loaded_death_screen)
	get_tree().paused = true

func is_hard_wall(pos: Vector2i) -> bool:
	return hard_walls.get_cell_source_id(pos) != -1

func is_wall(pos: Vector2i):
	return not Rect2i(Vector2i.ZERO, SIZE).has_point(pos) \
		or walls.get_cell_source_id(pos) != -1 \
		or is_hard_wall(pos)

func tunnel_path_clear(from: Vector2i, dir: Vector2i, dist: int) -> bool:
	for i in range(1, dist + 1):
		if is_hard_wall(from + dir * i): return false
	return true

func open_door(id) -> void:
	var to_open := []
	for pos in solids:
		var solid = solids[pos]
		if is_instance_valid(solid) and "id" in solid and solid.id == id:
			to_open.append(pos)
	for pos in to_open:
		var door = solids[pos]
		solids.erase(pos)
		if door.has_method("open"):
			door.open()

func can_occupy(pos: Vector2i) -> bool:
	return not (is_wall(pos) or solids.has(pos) or bonfires.has(pos))

func move_player(dir: Vector2i) -> bool:
	var target = player.grid_pos + dir
	if not can_occupy(target): return false
	if is_wall(target) or solids.has(target) or bonfires.has(target): return false
	if floors.has(player.grid_pos):
		var f = floors[player.grid_pos]
		get_tree().create_timer(0.3).timeout.connect(func():
			if is_instance_valid(f) and f.has_method("on_leave"):
				f.on_leave(player))
	player.grid_pos = target
	player.animate_to(target * TILE)
	return true

func level_complete():
	var loaded_win_screen = WIN_SCREEN.instantiate()
	get_tree().paused = true
	var t = get_tree().create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property($WhiteFade, "modulate:a", 1.0, 0.5)
	t.tween_callback(func():
		add_child(loaded_win_screen)
		loaded_win_screen.fade_in()
	)
	t.tween_property($WhiteFade, "modulate:a", 0.0, 1)
	

func _on_player_arrived():
	var pos = player.grid_pos
	if floors.has(pos):
		floors[pos].on_enter(player)
	var near_bonfire = null
	for adj_dir in ADJ_DIRS:
		var adj_pos = pos + adj_dir
		if bonfires.has(adj_pos):
			near_bonfire = bonfires[adj_pos]
			break
	if near_bonfire != null and not on_bonfire:
		print("player is near a bonfire")
		on_bonfire = true
		near_bonfire.on_enter(player)
	elif near_bonfire == null and on_bonfire:
		print("player exited")
		on_bonfire = false
	
	player.after_move()

func set_statusbar(temperature : int):
	var coldness = 8 - temperature
	if (on_bonfire):
		$StatusBar.play("fire")
	elif (coldness <= 7):
		$StatusBar.set_animation("normal")
		$StatusBar.set_frame(coldness)
	elif(coldness == 8):
		$StatusBar.play("full")

func init_player(_dir: Vector2i):
	player.position = Vector2(player.grid_pos * TILE)

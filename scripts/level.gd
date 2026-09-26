extends Node2D
const SIZE := Vector2i(12, 12)
const TILE := 8
const MAX_TEMP := 8
const ADJ_DIRS := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
@export var DEATH_SCREEN : PackedScene
@export var ESCAPE_SCREEN : PackedScene

@onready var walls := $Walls
@onready var player := $Player
var solids := {}
var floors := {}
var bonfires := {}
var on_bonfire := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog"):
		var loaded_escape_screen = ESCAPE_SCREEN.instantiate()
		add_child(loaded_escape_screen)

func death():
	var loaded_death_screen = DEATH_SCREEN.instantiate()
	add_child(loaded_death_screen)

func is_wall(pos: Vector2i):
	return not Rect2i(Vector2i.ZERO, SIZE).has_point(pos) \
		or walls.get_cell_source_id(pos) != -1

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
	player.grid_pos = target
	player.animate_to(target * TILE)
	return true

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

func init_player(dir: Vector2i):
	player.position = (player.grid_pos + dir) * TILE

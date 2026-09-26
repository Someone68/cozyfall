extends Node2D
const SIZE := Vector2i(12, 12)
const TILE := 8
const MAX_TEMP := 8
const ADJ_DIRS := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
@export var DEATH_SCREEN : PackedScene

@onready var walls := $Walls
@onready var player := $Player
var solids := {}
var floors := {}
var bonfires := {}
var on_bonfire := false

func death():
	var loaded_death_screen = DEATH_SCREEN.instantiate()
	add_child(loaded_death_screen)

func is_wall(pos: Vector2i):
	return not Rect2i(Vector2i.ZERO, SIZE).has_point(pos) \
		or walls.get_cell_source_id(pos) != -1

func move_player(dir: Vector2i) -> bool:
	var target = player.grid_pos + dir
	if is_wall(target) or solids.has(target) or bonfires.has(target): return false
	player.grid_pos = target
	player.animate_to(target * TILE)
	if floors.has(target):
		floors[target].on_enter(player)
	var near_bonfire = null
	for adj_dir in ADJ_DIRS: # check in 4 cardinal directions for a bonfire
		var adj_pos = target + adj_dir
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
	return true

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

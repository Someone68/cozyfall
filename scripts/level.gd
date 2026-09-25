extends Node2D
const SIZE := Vector2i(12, 12)
const TILE := 8
const ADJ_DIRS := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]

@onready var walls := $Walls
@onready var player := $Player
var solids := {}
var floors := {}
var bonfires := {}

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
	for adj_dir in ADJ_DIRS: # check in 4 cardinal directions for a bonfire
		var adj_pos = target + adj_dir
		if bonfires.has(adj_pos): bonfires[adj_pos].on_enter(player)
	return true

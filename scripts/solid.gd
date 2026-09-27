extends Node2D
var grid_pos: Vector2i
@onready var level = owner

func _ready():
	grid_pos = Vector2i(position / level.TILE)
	level.solids[grid_pos] = self

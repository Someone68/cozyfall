class_name FloorEntity extends Node2D
var grid_pos: Vector2i
@onready var level = owner

func _ready():
	grid_pos = Vector2i(position / level.TILE)
	level.floors[grid_pos] = self

func on_enter(player: Node2D):
	pass

func on_leave(player: Node2D):
	pass

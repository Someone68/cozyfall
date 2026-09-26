extends Node2D
var grid_pos: Vector2i
@onready var level = owner

@export var id = ""

func _ready():
	grid_pos = Vector2i(position / level.TILE)
	level.solids[grid_pos] = self

func open():
	queue_free()

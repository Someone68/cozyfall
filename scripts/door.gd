extends Node2D
var grid_pos: Vector2i
@onready var level = owner

@export var id = ""
@export_enum("Red:0", "Blue:1", "Yellow:2", "Green:3") var variant := 0

func _ready():
	grid_pos = Vector2i(position / level.TILE)
	level.solids[grid_pos] = self
	$AnimatedSprite2D.set_animation("default")
	$AnimatedSprite2D.set_frame(variant)

func open():
	queue_free()

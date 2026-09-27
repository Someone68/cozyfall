extends Node2D
var grid_pos: Vector2i
@onready var level = owner
var lit := false

func _ready() -> void:
	grid_pos = Vector2i(position / level.TILE)
	level.bonfires[grid_pos] = self
	$AnimatedSprite2D.play("unlit")

func on_enter(player: Node2D):
	player.temperature = player.MAX_TEMPERATURE
	if (not lit): $Fire1.play()
	else: $Fire2.play()
	lit = true
	$AnimatedSprite2D.play("lit")

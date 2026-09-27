extends FloorEntity

@export var fake := false

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("default")

func on_enter(player: Node2D):
	if not fake:
		level.carrot_eat()

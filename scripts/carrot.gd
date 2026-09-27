extends FloorEntity

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("default")

func on_enter(player: Node2D):
	level.carrot_eat()

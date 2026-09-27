extends FloorEntity
var on := false

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("off")

func on_enter(player: Node2D):
	if (on): player.die(true)

func on_leave(_player: Node2D):
	on = true
	$Activate.play()
	$AnimatedSprite2D.play("on")

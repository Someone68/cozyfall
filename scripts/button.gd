extends FloorEntity
@export var door_id := ""
var pressed := false

func _ready() -> void:
	super()
	$AnimatedSprite2D.animation = "off"

func on_enter(player: Node2D):
	print("pressed")
	pressed = true
	$AnimatedSprite2D.play("on")
	var door = level.open_door(door_id)
	if door: door.open()

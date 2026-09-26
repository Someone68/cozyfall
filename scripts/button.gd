extends FloorEntity
@export var door_id := ""
@export_enum("Red:0", "Blue:1", "Yellow:2", "Green:3") var variant := 0
var pressed := false

func _ready() -> void:
	super()
	$AnimatedSprite2D.set_animation("off")
	$AnimatedSprite2D.set_frame(variant)

func on_enter(player: Node2D):
	print("pressed")
	pressed = true
	$AnimatedSprite2D.set_animation("on")
	$AnimatedSprite2D.set_frame(variant)
	var door = level.open_door(door_id)
	if door: door.open()

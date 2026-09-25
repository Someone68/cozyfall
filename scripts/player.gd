extends Node2D
var grid_pos: Vector2i
var moving := false
@onready var level = owner
const TILE := 8
const temperature := 5

func handle_movement():
	if moving: return
	var dir := Vector2i.ZERO
	if Input.is_action_just_pressed("ui_right"): dir = Vector2i.RIGHT
	elif Input.is_action_just_pressed("ui_left"): dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_up"): dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"): dir = Vector2i.DOWN
	if dir != Vector2i.ZERO:
		#level.save_state()
		if not level.move_player(dir):
			pass

func _process(_delta: float):
	handle_movement()

func animate_to(px: Vector2):
	moving = true
	var t := create_tween()
	t.tween_property(self, "position", px, 0.1)
	t.finished.connect(func(): moving = false)

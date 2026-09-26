extends Node2D
@onready var level = owner
const TILE := 8
const MAX_TEMPERATURE := 9
var grid_pos: Vector2i
var can_move := "all"
var temperature := 8
var direction: Vector2i

func play_anim(suffix: String = ""):
	var anim := "right"
	if direction == Vector2i.UP: anim = "up"
	elif direction == Vector2i.DOWN: anim = "down"
	$AnimatedSprite2D.flip_h = direction.x == -1
	$AnimatedSprite2D.play(anim + suffix)

func handle_movement():
	var dir := Vector2i.ZERO
	if can_move == "x" or can_move == "all":
		if Input.is_action_just_pressed("ui_right"): dir = Vector2i.RIGHT
		if Input.is_action_just_pressed("ui_left"): dir = Vector2i.LEFT
	if can_move == "y" or can_move == "all":
		if Input.is_action_just_pressed("ui_up"): dir = Vector2i.UP
		if Input.is_action_just_pressed("ui_down"): dir = Vector2i.DOWN
	if dir != Vector2i.ZERO:
		direction = dir
		#level.save_state()
		if level.move_player(dir):
			temperature -= 1
			play_anim()
		else:
			play_anim("_idle")
		return true
	return false
		

func _process(_delta: float):
	handle_movement()

func animate_to(px: Vector2):
	can_move = "x" if direction == Vector2i.UP or direction == Vector2i.DOWN else "y"
	
	# get how long animation is
	var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
	var anim: StringName = $AnimatedSprite2D.animation
	var dur: float = frames.get_frame_count(anim) / frames.get_animation_speed(anim)
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	
	# move the player
	t.tween_property(self, "position", px, dur)
	t.finished.connect(func():
		can_move = "all"
		play_anim("_idle"))

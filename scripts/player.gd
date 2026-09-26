extends Node2D
@onready var level = owner
const TILE := 8
const MAX_TEMPERATURE := 9
var grid_pos: Vector2i
var moving := false
var temperature := 8
var direction: Vector2i

func play_anim(suffix: String = ""):
	var anim := "right"
	if direction == Vector2i.UP: anim = "up"
	elif direction == Vector2i.DOWN: anim = "down"
	$AnimatedSprite2D.flip_h = direction.x == -1
	$AnimatedSprite2D.play(anim + suffix)

func handle_movement():
	if moving: return false
	var dir := Vector2i.ZERO
	if Input.is_action_just_pressed("ui_right"): dir = Vector2i.RIGHT
	elif Input.is_action_just_pressed("ui_left"): dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_up"): dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"): dir = Vector2i.DOWN
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
	moving = true
	
	# get how long animation is
	var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
	var anim: StringName = $AnimatedSprite2D.animation
	var dur: float = frames.get_frame_count(anim) / frames.get_animation_speed(anim)
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	
	# move the player
	t.tween_property(self, "position", px, dur)
	t.finished.connect(func():
		moving = false
		play_anim("_idle"))

extends Node2D
signal move_finished
@export_enum("north", "west", "east", "south") var starting_direction : String
@onready var level = owner
const TILE := 8
const MAX_TEMPERATURE := 9
const BUFFER_TIME := 0.2
const DIRS := {
	"ui_up": Vector2i.UP,
	"ui_down": Vector2i.DOWN,
	"ui_left": Vector2i.LEFT,
	"ui_right": Vector2i.RIGHT,
}
var buffered_action := ""
var buffer_left := 0.0
var grid_pos : Vector2i
var can_move := "all"
var temperature := 8
var direction: Vector2i
var dead := false
var move_cooldown := false
var tunneling := false
var moving := false
var move_tween: Tween
var held_stack: Array[String] = []

func _ready() -> void:
	grid_pos = Vector2i(position / level.TILE)
	if (starting_direction == "north"): direction = Vector2i.UP
	if (starting_direction == "south"): direction = Vector2i.DOWN
	if (starting_direction == "east"): direction = Vector2i.RIGHT
	if (starting_direction == "west"): direction = Vector2i.LEFT
	await level.ready
	level.init_player(direction)
	play_anim("_idle")

func play_anim(suffix: String = ""):
	if dead: return
	var anim := "right"
	if direction == Vector2i.UP: anim = "up"
	elif direction == Vector2i.DOWN: anim = "down"
	$AnimatedSprite2D.flip_h = direction.x == -1
	$AnimatedSprite2D.play(anim + suffix)

func die(spike := false):
	if (dead == true): return
	print("die")
	dead = true
	if (spike): $DeathSpike.play()
	else: $DeathFreeze.play()
	$AnimatedSprite2D.play("die" + ("_spike" if spike else ""))
	await $AnimatedSprite2D.animation_finished
	print("dead")
	if spike:
		level.death("you stepped on legos!")
	else:
		level.death("you froze to death!")
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	for a in DIRS:
		if event.is_action_pressed(a):
			held_stack.erase(a)
			held_stack.append(a)
			buffered_action = a
			buffer_left = BUFFER_TIME
			return
		if event.is_action_released(a):
			held_stack.erase(a)
			return
	if event.is_action_pressed("tunnel"):
		buffered_action = "tunnel"
		buffer_left = BUFFER_TIME

func tunnel():
	if dead or tunneling or can_move != "all": return
	if not level.is_tunnelable(grid_pos): return
	tunneling = true
	$TunnelIn.play()
	play_anim("_tunnel_in")
	await $AnimatedSprite2D.animation_finished
	var target := grid_pos + direction * 3
	var moved: bool = level.can_occupy(target) \
	and level.is_tunnelable(target) \
	and level.tunnel_path_clear(grid_pos, direction, 3)
	if moved:
		grid_pos = target
		position = Vector2(target * TILE)
	play_anim("_tunnel_out")
	$TunnelOut.play()
	await $AnimatedSprite2D.animation_finished
	tunneling = false
	play_anim("_idle")
	move_cooldown = true
	$MovementCooldown.start()
	if moved:
		move_finished.emit()

func after_move():
	if (!level.TEMPERATURE_ENABLED): return
	if !level.on_bonfire:
		temperature -= level.tile_temp_cost(grid_pos)
	if temperature < 0:
		die()
		return
	level.set_statusbar(temperature)

func _process(delta: float):
	if buffer_left > 0.0:
		buffer_left -= delta
		if buffer_left <= 0.0:
			buffered_action = ""
	consume_input()

func consume_input():
	if dead or tunneling: return
	if buffered_action == "tunnel":
		if can_move == "all":
			buffered_action = ""
			tunnel()
		return
	var dir: Vector2i = DIRS.get(buffered_action, Vector2i.ZERO)
	if dir == Vector2i.ZERO:
		dir = held_dir()
	if dir != Vector2i.ZERO and try_move(dir):
		buffered_action = ""

func held_dir() -> Vector2i:
	for i in range(held_stack.size()):
		if Input.is_action_pressed(held_stack[i]):
			return DIRS[held_stack[i]]
	return Vector2i.ZERO

func try_move(dir: Vector2i) -> bool:
	if move_cooldown or moving: return false
	if dir.x != 0 and can_move == "y": return false
	if dir.y != 0 and can_move == "x": return false
	if not level.can_occupy(grid_pos + dir): return false
	direction = dir
	$Jump.play()
	play_anim()
	#level.save_state()
	move_cooldown = true
	$MovementCooldown.start()
	level.move_player(dir)
	return true

func animate_to(px: Vector2):
	moving = true
	can_move = "none"
	if move_tween and move_tween.is_valid():
		move_tween.kill()
	
	# get how long animation is
	var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
	var anim: StringName = $AnimatedSprite2D.animation
	var dur: float = frames.get_frame_count(anim) / frames.get_animation_speed(anim)
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_SINE)
	
	# move the player
	move_tween.tween_property(self, "position", px, dur)
	move_tween.finished.connect(func():
		moving = false
		can_move = "all"
		play_anim("_idle")
		move_cooldown = true
		$MovementCooldown.start()
		move_finished.emit())

func _on_movement_cooldown_timeout() -> void:
	move_cooldown = false

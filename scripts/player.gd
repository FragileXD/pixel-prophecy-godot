
extends KinematicBody2D

const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)

const RUN_SPEED = 500

var moving = false

onready var anim_player = get_node("anim_player")
onready var sprite = get_node("sprite")

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	var dir = Vector2(0, 0)
	if right:
		dir += RIGHT
	if left:
		dir -= RIGHT
	if down:
		dir += DOWN
	if up:
		dir -= DOWN
		
	if dir.length() != 0 and not moving:
		moving = true
		_update_moving()
	elif dir.length() == 0 and moving:
		moving = false
		_update_moving()
		
	var motion = dir.normalized() * RUN_SPEED
	
	move(motion * delta)
	
func _update_moving():
	if moving:
		anim_player.play("run")
	else:
		anim_player.stop()
		sprite.set_frame(0)


